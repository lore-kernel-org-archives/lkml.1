Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530Ab0AMCWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab0AMCWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 21:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644Ab0AMCWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 21:22:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:36774 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221Ab0AMCWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 21:22:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,264,1262592000"; 
   d="scan'208";a="530755140"
Subject: Re: [PATCH -v2 5/5] x86: use dmi check to treat disabled cpus as
 hotplug cpus.
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4B4D2C44.2060709@kernel.org>
References: <1263338274-6485-1-git-send-email-yinghai@kernel.org>
	 <1263338274-6485-5-git-send-email-yinghai@kernel.org>
	 <1263340563.2854.1011.camel@sbs-t61.sc.intel.com>
	 <4B4D0E39.10200@kernel.org>
	 <1263347315.2854.1296.camel@sbs-t61.sc.intel.com>
	 <4B4D2811.7000001@kernel.org>
	 <1263348363.2854.1360.camel@sbs-t61.sc.intel.com>
	 <4B4D2C44.2060709@kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 12 Jan 2010 18:21:08 -0800
Message-Id: <1263349268.2854.1386.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-12 at 18:13 -0800, Yinghai Lu wrote:
> On 01/12/2010 06:06 PM, Suresh Siddha wrote:
> > On Tue, 2010-01-12 at 17:55 -0800, Yinghai Lu wrote:
> >> you mean this blacklist could be too long?
> > 
> > yes.
> > 
> >>
> >> switch to whitelist for the box can treat disabled cpus as hotplug
> >> cpus?
> > 
> > Do we really need all this? Systems which support physical hotplug
> > typically have lot's of cpu's (mostly will have atleast > 8). Even if we
> > really need to identify, then perhaps we can check if ACPI has any hints
> > regarding the physical hotplug support at boot time (we should check
> > with Andi Kleen or Len Brown on this).
> > 
> > For now, I think we can keep it simple by using the detected enabled
> > cpu's.
> 
> sth like this ?

Well, I was referring more to the apic model selection than the prefill
case. About this possible cpu's, will the wastage be more than few kb
for few disabled cpu's.

thanks,
suresh

> ---
>  arch/x86/kernel/smpboot.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/smpboot.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/smpboot.c
> +++ linux-2.6/arch/x86/kernel/smpboot.c
> @@ -1190,7 +1190,6 @@ early_param("possible_cpus", _setup_poss
>   * - Ashok Raj
>   *
>   * Three ways to find out the number of additional hotplug CPUs:
> - * - If the BIOS specified disabled CPUs in ACPI/mptables use that.
>   * - The user can overwrite it with possible_cpus=NUM
>   * - Otherwise don't reserve additional CPUs.
>   * We do this because additional CPUs waste a lot of memory.
> @@ -1205,7 +1204,7 @@ __init void prefill_possible_map(void)
>  		num_processors = 1;
>  
>  	if (setup_possible_cpus == -1)
> -		possible = num_processors + disabled_cpus;
> +		possible = num_processors;
>  	else
>  		possible = setup_possible_cpus;
>  

