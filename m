Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbXJYQ5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbXJYQ5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750765AbXJYQ5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:57:12 -0400
Received: from www.tglx.de ([62.245.132.106]:38036 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbXJYQ5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:57:12 -0400
Date: Thu, 25 Oct 2007 18:56:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
cc: Adrian Bunk <bunk@kernel.org>, "Brown, Len" <len.brown@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: RE: [2.6 patch] unexport tick_nohz_get_sleep_length
In-Reply-To: <653FFBB4508B9042B5D43DC9E18836F5018EBEF1@scsmsx415.amr.corp.intel.com>
Message-ID: <alpine.LFD.0.9999.0710251855510.3186@localhost.localdomain>
References: <20071024162422.GH30533@stusta.de> <alpine.LFD.0.9999.0710251126430.3186@localhost.localdomain> <653FFBB4508B9042B5D43DC9E18836F5018EBEF1@scsmsx415.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007, Pallipadi, Venkatesh wrote:
> >On Wed, 24 Oct 2007, Adrian Bunk wrote:
> >
> >> This patch removes the unused 
> >> EXPORT_SYMBOL_GPL(tick_nohz_get_sleep_length).
> >> 
> >> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> >> 
> >> ---
> >> f7c83dfe117f4fd072b2506ae090e4145abda362 
> >> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> >> index 10a1347..5997456 100644
> >> --- a/kernel/time/tick-sched.c
> >> +++ b/kernel/time/tick-sched.c
> >> @@ -320,8 +320,6 @@ ktime_t tick_nohz_get_sleep_length(void)
> >>  	return ts->sleep_length;
> >>  }
> >>  
> >> -EXPORT_SYMBOL_GPL(tick_nohz_get_sleep_length);
> >> -
> >
> >Hmm, this was added to allow the cpuidle governers modular
> >build. Seems this was changed to compiled in only.
> >
> >Len, Venki, is this the final decision ?
> >
> 
> Yes. This was done recently for proper fallback to old ACPI policy in
> case CPUIDLE is not selected. With that being module, falling back to
> ACPI policy at run time makes things ugly.

Makes sense. I go ahead and nuke the export.

Thanks,

	tglx
