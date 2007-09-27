Return-Path: <linux-kernel-owner+w=401wt.eu-S1758147AbXI0Ptg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147AbXI0Ptg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 11:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755085AbXI0Pt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 11:49:29 -0400
Received: from www.osadl.org ([213.239.205.134]:49987 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755563AbXI0Pt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 11:49:28 -0400
Subject: Re: 2.6.23-rc8-mm2: problems on HP nx6325
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200709271759.46018.rjw@sisk.pl>
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org>
	 <200709271719.06937.rjw@sisk.pl>  <200709271759.46018.rjw@sisk.pl>
Content-Type: text/plain
Date: Thu, 27 Sep 2007 17:49:26 +0200
Message-Id: <1190908166.23376.115.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-27 at 17:59 +0200, Rafael J. Wysocki wrote:
> > 2) CPU hotplug is busted (onlining of CPU1 kills the kernel), probably due to
> >    the same issue that I'm having with the -hrt version of 2.6.23-rc8 (we're
> >    debugging it right now)
> 
> This one is fixed by the following patch:
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Fix CPU hotplug breakage on HP nx6325 and similar boxes caused by a reference
> to disable_apic_timer (labeled as __initdata) from the CPU initialization code.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Doh, I knew I blew it.

Good catch, thanks,

	tglx

> ---
>  arch/x86_64/kernel/apic.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.23-rc8-mm2/arch/x86_64/kernel/apic.c
> ===================================================================
> --- linux-2.6.23-rc8-mm2.orig/arch/x86_64/kernel/apic.c
> +++ linux-2.6.23-rc8-mm2/arch/x86_64/kernel/apic.c
> @@ -42,7 +42,7 @@
>  
>  int apic_verbosity;
>  static int apic_calibrate_pmtmr __initdata;
> -int disable_apic_timer __initdata;
> +int disable_apic_timer __cpuinitdata;
>  
>  /* Local APIC timer works in C2? */
>  int local_apic_timer_c2_ok;

