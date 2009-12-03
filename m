Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbZLCWZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbZLCWZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 17:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbZLCWZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 17:25:31 -0500
Received: from mail-ew0-f222.google.com ([209.85.219.222]:33439 "EHLO
	mail-ew0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbZLCWZ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 17:25:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=J8+BTfKDQChBMdwIjnX+h6FJ+lL9rM3ERLnrEyFFShbsMw/2zV3hYsLM2HFkcUR6zB
         IvPUEbdp0t5uOHgvI3afoKznJBmUQD5zbw352bFc4RulVXGsAgKSfOIC85VSC+fSdosQ
         8BvQ7Hxm86GDwV4+95wsS1nSLsWZmNAAtuM18=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 00/86] PATA fixes
Date: Thu, 3 Dec 2009 23:23:39 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <200912032306.52022.bzolnier@gmail.com> <4B18376B.3080404@garzik.org>
In-Reply-To: <4B18376B.3080404@garzik.org>
MIME-Version: 1.0
Message-Id: <200912032323.39846.bzolnier@gmail.com>
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 December 2009 11:10:51 pm Jeff Garzik wrote:
> On 12/03/2009 05:06 PM, Bartlomiej Zolnierkiewicz wrote:
> > On Thursday 03 December 2009 11:02:36 pm Jeff Garzik wrote:
> >> On 12/03/2009 04:56 PM, Bartlomiej Zolnierkiewicz wrote:
> >>> On Thursday 03 December 2009 10:51:09 pm Jeff Garzik wrote:
> >>>
> >>>>>>>           pata_via: clear UDMA transfer mode bit for PIO and MWDMA
> >>>>>>
> >>>>>> applied -- even though Alan's comment was correct.  It is standard
> >>>>>> kernel practice to place cosmetic changes into their own patches,
> >>>>>> because it is standard kernel practice to break up logically distinct
> >>>>>> changes.
> >>>>>
> >>>>> We are talking about:
> >>>>>
> >>>>>     pata_via.c |   19 +++++++++++++------
> >>>>>     1 file changed, 13 insertions(+), 6 deletions(-)
> >>>>>
> >>>>> patch here (http://lkml.org/lkml/2009/11/25/380) and cosmetic change
> >>>>> is clearly documented in the patch description.
> >>>>>
> >>>>>
> >>>>> Do people really wonder why I find upstream to be too much hassle to
> >>>>> deal with?
> >>>>
> >>>> The thousand other kernel developers seem to be able to split up their
> >>>> patches, separating out cosmetic changes from functional ones.  It has
> >>>> clear engineering benefits, and has been standard practice for a decade
> >>>> or more.
> >>>>
> >>>> Why is it such an imposition for your patches to look like everyone
> >>>> else's?  And by "everyone", I mean all other kernel developers, not just
> >>>> other ATA developers.
> >>>>
> >>>> You seem to consider standard kernel practice a hassle.  Separating out
> >>>> cosmetic changes is not only a libata practice, it is the norm for the
> >>>> entire kernel.
> >>>
> >>> Indeed.
> >>>
> >>>   From 94be9a58d7e683ac3c1df1858a17f09ebade8da0 Mon Sep 17 00:00:00 2001
> >>> From: Jeff Garzik<jeff@garzik.org>
> >>> Date: Fri, 16 Jan 2009 10:17:09 -0500
> >>> Subject: [PATCH] [libata] get-identity ioctl: Fix use of invalid memory pointer
> >>>    for SAS drivers.
> >>>
> >>> Caught by Ke Wei (and team?) at Marvell.
> >>>
> >>> Also, move the ata_scsi_ioctl export to libata-scsi.c, as that seems to be the
> >>> general trend.
> >>>
> >>> Acked-by: James Bottomley<James.Bottomley@HansenPartnership.com>
> >>> Signed-off-by: Jeff Garzik<jgarzik@redhat.com>
> >>
> >> If your point, by posting this patch, is that it includes a ton of
> >> gratuitous cosmetic changes, you misread the patch.
> >>
> >> ata_scsi_ioctl() remains in existence; only the callers need to use the
> >> new SAS-related ioctl function were updated.  The remainder continued to
> >> use ata_scsi_ioctl().
> >
> > Moving kernel exports around is completely unrelated to a bug fix.
> 
> Did the patch contain -cosmetic- changes intermingled with code changes, 
> in the same code lines?  No.

Took me a bit longer to find such one since you are not doing much
patches any longer. ;)

> Is it good kernel practice to intermingle cosmetic changes with 
> functional ones, in the same code lines?  Also, no.

I prefer using common sense over black-and-white rules.

If patch is a _really_ tiny one (< 20 LOC changed) it sometimes makes
sense to save the time on handling separate patches.

--
Bartlomiej Zolnierkiewicz


>From ee9ccdf70163ca6408f6965e0fbc65baeac7312c Mon Sep 17 00:00:00 2001
From: Jeff Garzik <jeff@garzik.org>
Date: Thu, 12 Jul 2007 15:51:22 -0400
Subject: [PATCH] [libata] sata_mv: Fix and clean up per-chip-generation tests

Due to a mistake in test logic, Gen-IIE chips were being treated as
Gen-II chips in some cases.  Fix this, and in the process, clean up
IS_50XX/IS_60XX tests to the more uniform IS_GEN_{I,II,IIE} tests.

Signed-off-by: Jeff Garzik <jeff@garzik.org>
---
 drivers/ata/sata_mv.c |   29 ++++++++++++++---------------
 1 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index d40c41c..8a77a0a 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -301,8 +301,9 @@ enum {
 	MV_HP_ERRATA_60X1B2	= (1 << 3),
 	MV_HP_ERRATA_60X1C0	= (1 << 4),
 	MV_HP_ERRATA_XX42A0	= (1 << 5),
-	MV_HP_50XX		= (1 << 6),
-	MV_HP_GEN_IIE		= (1 << 7),
+	MV_HP_GEN_I		= (1 << 6),
+	MV_HP_GEN_II		= (1 << 7),
+	MV_HP_GEN_IIE		= (1 << 8),
 
 	/* Port private flags (pp_flags) */
 	MV_PP_FLAG_EDMA_EN	= (1 << 0),
@@ -310,10 +311,8 @@ enum {
 	MV_PP_FLAG_HAD_A_RESET	= (1 << 2),
 };
 
-#define IS_50XX(hpriv) ((hpriv)->hp_flags & MV_HP_50XX)
-#define IS_60XX(hpriv) (((hpriv)->hp_flags & MV_HP_50XX) == 0)
-#define IS_GEN_I(hpriv) IS_50XX(hpriv)
-#define IS_GEN_II(hpriv) IS_60XX(hpriv)
+#define IS_GEN_I(hpriv) ((hpriv)->hp_flags & MV_HP_GEN_I)
+#define IS_GEN_II(hpriv) ((hpriv)->hp_flags & MV_HP_GEN_II)
 #define IS_GEN_IIE(hpriv) ((hpriv)->hp_flags & MV_HP_GEN_IIE)
 
 enum {
@@ -1406,7 +1405,7 @@ static void mv_err_intr(struct ata_port *ap, struct ata_queued_cmd *qc)
 			", dev disconnect" : ", dev connect");
 	}
 
-	if (IS_50XX(hpriv)) {
+	if (IS_GEN_I(hpriv)) {
 		eh_freeze_mask = EDMA_EH_FREEZE_5;
 
 		if (edma_err_cause & EDMA_ERR_SELF_DIS_5) {
@@ -2100,7 +2099,7 @@ static void mv_channel_reset(struct mv_host_priv *hpriv, void __iomem *mmio,
 
 	writelfl(ATA_RST, port_mmio + EDMA_CMD_OFS);
 
-	if (IS_60XX(hpriv)) {
+	if (IS_GEN_II(hpriv)) {
 		u32 ifctl = readl(port_mmio + SATA_INTERFACE_CTL);
 		ifctl |= (1 << 7);		/* enable gen2i speed */
 		ifctl = (ifctl & 0xfff) | 0x9b1000; /* from chip spec */
@@ -2116,7 +2115,7 @@ static void mv_channel_reset(struct mv_host_priv *hpriv, void __iomem *mmio,
 
 	hpriv->ops->phy_errata(hpriv, mmio, port_no);
 
-	if (IS_50XX(hpriv))
+	if (IS_GEN_I(hpriv))
 		mdelay(1);
 }
 
@@ -2163,7 +2162,7 @@ comreset_retry:
 	} while (time_before(jiffies, deadline));
 
 	/* work around errata */
-	if (IS_60XX(hpriv) &&
+	if (IS_GEN_II(hpriv) &&
 	    (sstatus != 0x0) && (sstatus != 0x113) && (sstatus != 0x123) &&
 	    (retry-- > 0))
 		goto comreset_retry;
@@ -2396,7 +2395,7 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 	switch(board_idx) {
 	case chip_5080:
 		hpriv->ops = &mv5xxx_ops;
-		hp_flags |= MV_HP_50XX;
+		hp_flags |= MV_HP_GEN_I;
 
 		switch (rev_id) {
 		case 0x1:
@@ -2416,7 +2415,7 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 	case chip_504x:
 	case chip_508x:
 		hpriv->ops = &mv5xxx_ops;
-		hp_flags |= MV_HP_50XX;
+		hp_flags |= MV_HP_GEN_I;
 
 		switch (rev_id) {
 		case 0x0:
@@ -2436,6 +2435,7 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 	case chip_604x:
 	case chip_608x:
 		hpriv->ops = &mv6xxx_ops;
+		hp_flags |= MV_HP_GEN_II;
 
 		switch (rev_id) {
 		case 0x7:
@@ -2455,7 +2455,6 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 	case chip_7042:
 	case chip_6042:
 		hpriv->ops = &mv6xxx_ops;
-
 		hp_flags |= MV_HP_GEN_IIE;
 
 		switch (rev_id) {
@@ -2522,7 +2521,7 @@ static int mv_init_host(struct ata_host *host, unsigned int board_idx)
 	hpriv->ops->enable_leds(hpriv, mmio);
 
 	for (port = 0; port < host->n_ports; port++) {
-		if (IS_60XX(hpriv)) {
+		if (IS_GEN_II(hpriv)) {
 			void __iomem *port_mmio = mv_port_base(mmio, port);
 
 			u32 ifctl = readl(port_mmio + SATA_INTERFACE_CTL);
@@ -2557,7 +2556,7 @@ static int mv_init_host(struct ata_host *host, unsigned int board_idx)
 	/* and unmask interrupt generation for host regs */
 	writelfl(PCI_UNMASK_ALL_IRQS, mmio + PCI_IRQ_MASK_OFS);
 
-	if (IS_50XX(hpriv))
+	if (IS_GEN_I(hpriv))
 		writelfl(~HC_MAIN_MASKED_IRQS_5, mmio + HC_MAIN_IRQ_MASK_OFS);
 	else
 		writelfl(~HC_MAIN_MASKED_IRQS, mmio + HC_MAIN_IRQ_MASK_OFS);
-- 
1.6.4.2

