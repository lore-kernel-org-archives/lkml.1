Return-Path: <linux-kernel-owner+w=401wt.eu-S1752173AbXJUXK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbXJUXK2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 19:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750757AbXJUXKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 19:10:20 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:53369 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbXJUXKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 19:10:19 -0400
Message-ID: <471BDC55.8070900@tiscali.nl>
Date: Mon, 22 Oct 2007 01:10:13 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] errors with assignments in if
References: <471BD68B.9030408@tiscali.nl>
In-Reply-To: <471BD68B.9030408@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> I am not entirely certain about the third one:
> 
> from fs/udf/udf_sb.h:
> 
> #define UDF_SB_VAT(X)                           ( UDF_SB(X)->s_vat )
> 
> if it's the desired behavior then I think this should at least be changed to
> 
> UDF_SB_VAT(sb) = udf_iget(sb, ino);
> if (!(UDF_SB_VAT(sb)))

On a second glance, I think it's the desired behavior. Use this patch instead.
---
    Errors with assignments in ifs
    
    Signed-off-by: Roel Kluin <12o3l@tiscali.nl>

diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index d9af436..e6e85b7 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -651,7 +651,7 @@ static u32 omap2_get_clksel(u32 *div_sel, u32 *field_mask,
 		break;
 	case CM_SYSCLKOUT_SEL1:
 		div_addr = (u32)&PRCM_CLKOUT_CTRL;
-		if ((div_off == 3) || (div_off = 11))
+		if ((div_off == 3) || (div_off == 11))
 			mask= 0x3;
 		break;
 	case CM_CORE_SEL1:
diff --git a/drivers/isdn/hisax/elsa.c b/drivers/isdn/hisax/elsa.c
index 948a9b2..ed610ed 100644
--- a/drivers/isdn/hisax/elsa.c
+++ b/drivers/isdn/hisax/elsa.c
@@ -883,7 +883,7 @@ setup_elsa_isa(struct IsdnCard *card)
 	val += 'A' - 3;
 	if (val == 'B' || val == 'C')
 		val ^= 1;
-	if ((cs->subtyp == ELSA_PCFPRO) && (val = 'G'))
+	if ((cs->subtyp == ELSA_PCFPRO) && (val == 'G'))
 		val = 'C';
 	printk(KERN_INFO
 	       "Elsa: %s found at %#lx Rev.:%c IRQ %d\n",

