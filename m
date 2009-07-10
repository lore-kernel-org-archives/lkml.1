Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbZGJKFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbZGJKFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 06:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbZGJKFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 06:05:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44511 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbZGJKFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 06:05:23 -0400
Subject: Re: [PATCH][cpufreq][Powernow-k8] support family 0xf with 2 low
 p-states
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Langsdorf <mark.langsdorf@amd.com>, linux-kernel@vger.kernel.org,
       davej@redhat.com, cpufreq@vger.kernel.org
In-Reply-To: <20090702141543.e6d8c0cd.akpm@linux-foundation.org>
References: <200907261055.25501.mark.langsdorf@amd.com>
	 <20090702141543.e6d8c0cd.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 10 Jul 2009 12:05:12 +0200
Message-Id: <1247220312.7529.24.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-02 at 14:15 -0700, Andrew Morton wrote:
> On Sun, 26 Jul 2009 10:55:25 -0500
> Mark Langsdorf <mark.langsdorf@amd.com> wrote:
> >
> > Subject: [PATCH][cpufreq][Powernow-k8] support family 0xf with 2 low p-states
> 
> Please leave the subsystem identification text outside the []. 
> Documentation/SubmittingPatches section 15 has details.
> 
> 
> > --- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
> > +++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
> > @@ -215,7 +215,8 @@ struct pst_s {
> >  
> >  #define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "powernow-k8", msg)
> >  
> > -static int core_voltage_pre_transition(struct powernow_k8_data *data, u32 reqvid);
> > +static int core_voltage_pre_transition(struct powernow_k8_data *data,
> > +	u32 reqvid, u32 regfid);
> >  static int core_voltage_post_transition(struct powernow_k8_data *data, u32 reqvid);
> >  static int core_frequency_transition(struct powernow_k8_data *data, u32 reqfid);
> 
> It's fairly dopey to have static function declarations in a header file
> - no other .c fail can _use_ them, so they may as well be tucked away

hehe, FAIL, hehe ;-)

> inside their .c file.  And that's only needed if the functions indeed
> need to be forward-declared.

