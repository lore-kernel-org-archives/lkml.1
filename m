Return-Path: <linux-kernel-owner+w=401wt.eu-S1755696AbZHLCP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696AbZHLCP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 22:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755637AbZHLCP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 22:15:57 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:58085 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631AbZHLCP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 22:15:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent:message-id;
        b=IBapjv+nUCIqTtdRs/wi0ohdN0efmQ/fx02H2QJ3gknZYsn6nNn9U2iHhBI5rxWDiI
         pYPbFY3jjdNZMsQmWpCdvFhJtExzqruapeUKNyq5NQtHiqQWB90/uPVMqC+urHyxhzW4
         Jpdrcn/cEkaabTpygowgR9E+yqPMmFa1sZ/h0=
Date: Tue, 11 Aug 2009 19:15:54 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, mce: therm_throt - change when we print
	messages
References: <20090810051513.0558F526EC9@mailhub.coreip.homeip.net> <tip-0d01f31439c1e4d602bf9fdc924ab66f407f5e38@git.kernel.org> <d1af83620908110531x5c7fb448r2a082a63ae22b95c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d1af83620908110531x5c7fb448r2a082a63ae22b95c@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090812024629.ADFC2526EC9@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 09:31:14AM -0300, Kevin Winchester wrote:
> 2009/8/11 tip-bot for Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> >  static DEFINE_PER_CPU(__u64, next_check) = INITIAL_JIFFIES;
> >  static DEFINE_PER_CPU(unsigned long, thermal_throttle_count);
> > +static DEFINE_PER_CPU(bool, thermal_throttle_active);
> >
> >  static atomic_t therm_throt_en         = ATOMIC_INIT(0);
> >
> > @@ -96,24 +97,27 @@ static int therm_throt_process(int curr)
> >  {
> >        unsigned int cpu = smp_processor_id();
> >        __u64 tmp_jiffs = get_jiffies_64();
> > +       bool was_throttled = __get_cpu_var(thermal_throttle_active);
> > +       bool is_throttled = __get_cpu_var(thermal_throttle_active) = curr;
> 
> This seems a little odd (or perhaps my lack of experience is
> showing...) - should it be:
> 
> bool is_throttled = __get_cpu_var(thermal_throttle_active) == curr;
> 
> ?

No, you still want to assign the value to thermal_throttle_active.
is_throttled is just a temp so you don't need to invoke
__get_cpu_var(thermal_throttle_active) all over the function.

-- 
Dmitry
