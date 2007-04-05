Return-Path: <linux-kernel-owner+w=401wt.eu-S1767021AbXDEOoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767021AbXDEOoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 10:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767019AbXDEOoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 10:44:20 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:19279 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767021AbXDEOoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 10:44:18 -0400
X-ORBL: [67.117.73.34]
Date: Thu, 5 Apr 2007 10:43:48 -0400
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Kai Svahn <kai.svahn@nokia.com>
Subject: Re: [PATCH 60/90] ARM: OMAP: Merge gpmc changes from N800 tree
Message-ID: <20070405144345.GI24297@atomide.com>
References: <11757101072553-git-send-email-tony@atomide.com> <11757101101180-git-send-email-tony@atomide.com> <11757101123620-git-send-email-tony@atomide.com> <11757101141643-git-send-email-tony@atomide.com> <11757101164151-git-send-email-tony@atomide.com> <11757101181993-git-send-email-tony@atomide.com> <11757101233966-git-send-email-tony@atomide.com> <11757101252580-git-send-email-tony@atomide.com> <1175710128235-git-send-email-tony@atomide.com> <11757101303810-git-send-email-tony@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="//IivP0gvsAy3Can"
Content-Disposition: inline
In-Reply-To: <11757101303810-git-send-email-tony@atomide.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--//IivP0gvsAy3Can
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Tony Lindgren <tony@atomide.com> [070404 14:11]:
> From: Kai Svahn <kai.svahn@nokia.com>
> 
> This patch merges gpmc changes from N800 tree.
> 
> Signed-off-by: Kai Svahn <kai.svahn@nokia.com>
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> ---
>  arch/arm/mach-omap2/gpmc.c       |    7 +++++++
>  include/asm-arm/arch-omap/gpmc.h |    1 +
>  2 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
> index a3f31f0..b6b47f2 100644
> --- a/arch/arm/mach-omap2/gpmc.c
> +++ b/arch/arm/mach-omap2/gpmc.c
> @@ -111,6 +111,13 @@ unsigned int gpmc_ns_to_ticks(unsigned int time_ns)
>  	return (time_ns * 1000 + tick_ps - 1) / tick_ps;
>  }
>  
> +unsigned int gpmc_round_ns_to_ticks(unsigned int time_ns)
> +{
> +	unsigned long ticks = gpmc_ns_to_ticks(time_ns);
> +
> +	return ticks * gpmc_get_fclk_period() / 1000;
> +}
> +
>  #ifdef DEBUG
>  static int set_gpmc_timing_reg(int cs, int reg, int st_bit, int end_bit,
>  			       int time, const char *name)
> diff --git a/include/asm-arm/arch-omap/gpmc.h b/include/asm-arm/arch-omap/gpmc.h
> index 434672d..0fe920a 100644
> --- a/include/asm-arm/arch-omap/gpmc.h
> +++ b/include/asm-arm/arch-omap/gpmc.h
> @@ -81,6 +81,7 @@ struct gpmc_timings {
>  };
>  
>  extern unsigned int gpmc_ns_to_ticks(unsigned int time_ns);
> +extern unsigned int gpmc_round_ns_to_ticks(unsigned int time_ns);
>  
>  extern void gpmc_cs_write_reg(int cs, int idx, u32 val);
>  extern u32 gpmc_cs_read_reg(int cs, int idx);

Here's an updated version for gpmc_get_fclk_period() needed in
patch 43/90.

Regards,

Tony

--//IivP0gvsAy3Can
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0060-ARM-OMAP-Merge-gpmc-changes-from-N800-tree.txt"

>From 2e3b88049f84dc172eb34ddfab4065ce374760b0 Mon Sep 17 00:00:00 2001
From: Kai Svahn <kai.svahn@nokia.com>
Date: Fri, 26 Jan 2007 12:29:40 -0800
Subject: [PATCH 60/90] ARM: OMAP: Merge gpmc changes from N800 tree

This patch merges gpmc changes from N800 tree
and adds gpmc_get_fclk_period() to gpmc.h.

Signed-off-by: Kai Svahn <kai.svahn@nokia.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/gpmc.c       |    7 +++++++
 include/asm-arm/arch-omap/gpmc.h |    1 +
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index a3f31f0..b6b47f2 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -111,6 +111,13 @@ unsigned int gpmc_ns_to_ticks(unsigned int time_ns)
 	return (time_ns * 1000 + tick_ps - 1) / tick_ps;
 }
 
+unsigned int gpmc_round_ns_to_ticks(unsigned int time_ns)
+{
+	unsigned long ticks = gpmc_ns_to_ticks(time_ns);
+
+	return ticks * gpmc_get_fclk_period() / 1000;
+}
+
 #ifdef DEBUG
 static int set_gpmc_timing_reg(int cs, int reg, int st_bit, int end_bit,
 			       int time, const char *name)
diff --git a/include/asm-arm/arch-omap/gpmc.h b/include/asm-arm/arch-omap/gpmc.h
index 434672d..0fe920a 100644
--- a/include/asm-arm/arch-omap/gpmc.h
+++ b/include/asm-arm/arch-omap/gpmc.h
@@ -81,6 +81,8 @@ struct gpmc_timings {
 };
 
 extern unsigned int gpmc_ns_to_ticks(unsigned int time_ns);
+extern unsigned int gpmc_round_ns_to_ticks(unsigned int time_ns);
+extern unsigned long gpmc_get_fclk_period(void);
 
 extern void gpmc_cs_write_reg(int cs, int idx, u32 val);
 extern u32 gpmc_cs_read_reg(int cs, int idx);
-- 
1.4.4.2


--//IivP0gvsAy3Can--
