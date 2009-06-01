Return-Path: <linux-kernel-owner+w=401wt.eu-S1757916AbZFAQ4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916AbZFAQ4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 12:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbZFAQ4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 12:56:32 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:65522 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbZFAQ4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 12:56:31 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/yKDLNiFjoiTdFCn1GhYFT
Date: Mon, 1 Jun 2009 09:56:24 -0700
From: Tony Lindgren <tony@atomide.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH 00/10] OMAP clock/powerdomain/SDRC patches for
	post-2.6.30
Message-ID: <20090601165623.GB4825@atomide.com>
References: <20090526220517.25381.75976.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526220517.25381.75976.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Walmsley <paul@pwsan.com> [090526 15:27]:
> Hello Russell,
> 
> here is the next set of OMAP clock patches for review for the
> post-2.6.30 merge window.  They apply on top of the previous set
> ("OMAP clock/SDRC patches on v2.6.30-rc5").  If you're happy with
> these patches, Tony will queue them up into his for-next branch.

Looks like Russell now has all the omap for-next merged to his
devel branch. Only this series is missing and the omap4 SMP patches.

Paul, can you please reply with the output from git request-pull 
for Russell to pull these in too?

AFAIK, there should not be any need to rebase this series, it
should merge clean from v2.6.30-rc7 to Russell's devel branch.

Regards,

Tony


 
> This series completes basic support for OMAP3 CORE DVFS.  A few other
> minor bugs are fixed by the off-by-one patch and the GPIO debounce
> clock patch.
> 
> 
> regards,
> 
> - Paul
> 
> ---
> 
> Paul Walmsley (8):
>       OMAP3 clock: GPIO de-bounce clocks don't affect module idle state
>       OMAP3 SDRC: set FIXEDDELAY when disabling SDRC DLL
>       OMAP3 SRAM: convert SRAM code to use macros rather than magic numbers
>       OMAP3 SRAM: add more comments on the SRAM code
>       OMAP3 clock/SDRC: program SDRC_MR register during SDRC clock change
>       OMAP3 clock: add a short delay when lowering CORE clk rate
>       OMAP3 clock: initialize SDRC timings at kernel start
>       OMAP3 clock: remove wait for DPLL3 M2 clock to stabilize
> 
> Roel Kluin (1):
>       OMAP2 clock/powerdomain: off by 1 error in loop timeout comparisons
> 
> Tero Kristo (1):
>       OMAP3: Add support for DPLL3 divisor values higher than 2
> 
> 
>  arch/arm/mach-omap2/clock.c            |    2 
>  arch/arm/mach-omap2/clock34xx.c        |   42 ++++++++--
>  arch/arm/mach-omap2/clock34xx.h        |   12 +--
>  arch/arm/mach-omap2/io.c               |   38 +++++++++
>  arch/arm/mach-omap2/powerdomain.c      |    2 
>  arch/arm/mach-omap2/sram34xx.S         |  129 +++++++++++++++++++++-----------
>  arch/arm/plat-omap/include/mach/sram.h |    6 +
>  arch/arm/plat-omap/sram.c              |    8 +-
>  8 files changed, 171 insertions(+), 68 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
