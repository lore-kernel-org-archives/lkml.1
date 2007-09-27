Return-Path: <linux-kernel-owner+w=401wt.eu-S1758797AbXI0Qw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797AbXI0Qw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 12:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756774AbXI0QwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 12:52:21 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:36667 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753683AbXI0QwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 12:52:20 -0400
Date: Thu, 27 Sep 2007 18:53:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.23-rc8-mm2: problems on HP nx6325
Message-ID: <20070927165346.GA919@uranus.ravnborg.org>
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org> <200709271719.06937.rjw@sisk.pl> <200709271759.46018.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709271759.46018.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael.
> 
> Fix CPU hotplug breakage on HP nx6325 and similar boxes caused by a reference
> to disable_apic_timer (labeled as __initdata) from the CPU initialization code.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
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
This is with your configuration a reference from a .text section
to a .init.data section as I see it.

So this ought to have been flagged by the section mismatch
checks in modpost.

I assume you did not see such warning??

	Sam
