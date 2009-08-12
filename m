Return-Path: <linux-kernel-owner+w=401wt.eu-S1751991AbZHLMeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbZHLMeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 08:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbZHLMeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 08:34:17 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:41777 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbZHLMeQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 08:34:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=niwNvz/p8zlC97W29h4wjG9P1U2pefomc6SjHZV+/SamyXLIb+pyi5J3vLXLwOuU9l
         gUxeWZHy68CQSrKs+iBbyD9kNIQnNIS9gpJK8ChjKEzNpuH60op/lWTyRzZSunPI31tq
         edVcKrEL/EnpKdmLvVCOKlXZfIesHcNJ20txM=
MIME-Version: 1.0
In-Reply-To: <20090812024629.ADFC2526EC9@mailhub.coreip.homeip.net>
References: <20090810051513.0558F526EC9@mailhub.coreip.homeip.net>
	 <tip-0d01f31439c1e4d602bf9fdc924ab66f407f5e38@git.kernel.org>
	 <d1af83620908110531x5c7fb448r2a082a63ae22b95c@mail.gmail.com>
	 <20090812024629.ADFC2526EC9@mailhub.coreip.homeip.net>
Date: Wed, 12 Aug 2009 09:34:16 -0300
Message-ID: <d1af83620908120534p70e8963x2d97326aa9b46657@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86, mce: therm_throt - change when we print 
	messages
From: Kevin Winchester <kjwinchester@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/11 Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> On Tue, Aug 11, 2009 at 09:31:14AM -0300, Kevin Winchester wrote:
>> 2009/8/11 tip-bot for Dmitry Torokhov <dmitry.torokhov@gmail.com>:
>> >  static DEFINE_PER_CPU(__u64, next_check) = INITIAL_JIFFIES;
>> >  static DEFINE_PER_CPU(unsigned long, thermal_throttle_count);
>> > +static DEFINE_PER_CPU(bool, thermal_throttle_active);
>> >
>> >  static atomic_t therm_throt_en         = ATOMIC_INIT(0);
>> >
>> > @@ -96,24 +97,27 @@ static int therm_throt_process(int curr)
>> >  {
>> >        unsigned int cpu = smp_processor_id();
>> >        __u64 tmp_jiffs = get_jiffies_64();
>> > +       bool was_throttled = __get_cpu_var(thermal_throttle_active);
>> > +       bool is_throttled = __get_cpu_var(thermal_throttle_active) = curr;
>>
>> This seems a little odd (or perhaps my lack of experience is
>> showing...) - should it be:
>>
>> bool is_throttled = __get_cpu_var(thermal_throttle_active) == curr;
>>
>> ?
>
> No, you still want to assign the value to thermal_throttle_active.
> is_throttled is just a temp so you don't need to invoke
> __get_cpu_var(thermal_throttle_active) all over the function.
>

Thanks - now I understand.  I guess I'm used to seeing:

bool a = b == c;

So it jumped out at me.

-- 
Kevin Winchester
