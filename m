Return-Path: <linux-kernel-owner+w=401wt.eu-S1759941AbXFCKF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941AbXFCKF6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 06:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755394AbXFCKFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 06:05:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:63940 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579AbXFCKFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 06:05:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=XQ0+KYOml4cTbQOKITGh+t3A7Dj/pHoX3oFZ0Z/CZDyiOCRAykvUYCzzWoIyyH5hNlVghZ0LS405XF46DipfTloujCIL7yap99gxDReXsgASgK5bhT0DV2SAxmJSQ5ypsDUJGCrr/xQ26YErgnShsIyfapSY/j5uqhYt5SV+IxU=
Date: Sun, 3 Jun 2007 18:06:11 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Doug Thompson <norsk5@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 23/36] drivers edac Lindent amd76x driver
Message-ID: <20070603100611.GC2467@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: Doug Thompson <norsk5@yahoo.com>,
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <325199.9497.qm@web50101.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <325199.9497.qm@web50101.mail.re2.yahoo.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 03, 2007 at 02:34:03AM -0700, Doug Thompson wrote:
>From:	Douglas Thompson <dougthompson@xmission.com>
>
>Run this driver through Lindent for cleanup
>
>Signed-off-by: Dave Jiang <djiang@mvista.com>
>Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
>---
> amd76x_edac.c |   54
>+++++++++++++++++++++++++-----------------------------
> 1 file changed, 25 insertions(+), 29 deletions(-)
>---
>
>Index: linux-2.6.22-rc1/drivers/edac/amd76x_edac.c
>===================================================================
>--- linux-2.6.22-rc1.orig/drivers/edac/amd76x_edac.c
>+++ linux-2.6.22-rc1/drivers/edac/amd76x_edac.c
>@@ -86,11 +86,9 @@ struct amd76x_dev_info {
> 
> static const struct amd76x_dev_info amd76x_devs[] = {
> 	[AMD761] = {
>-		.ctl_name = "AMD761"
>-	},
>+		    .ctl_name = "AMD761"},
> 	[AMD762] = {
>-		.ctl_name = "AMD762"
>-	},
>+		    .ctl_name = "AMD762"},
> };
> 
> /**
>@@ -102,21 +100,21 @@ static const struct amd76x_dev_info amd7
>  *	on the chip so that further errors will be reported
>  */
> static void amd76x_get_error_info(struct mem_ctl_info *mci,
>-		struct amd76x_error_info *info)
>+				  struct amd76x_error_info *info)
> {
> 	struct pci_dev *pdev;
> 
> 	pdev = to_pci_dev(mci->dev);
> 	pci_read_config_dword(pdev, AMD76X_ECC_MODE_STATUS,
>-				&info->ecc_mode_status);
>+			      &info->ecc_mode_status);
> 
> 	if (info->ecc_mode_status & BIT(8))
> 		pci_write_bits32(pdev, AMD76X_ECC_MODE_STATUS,
>-				(u32) BIT(8), (u32) BIT(8));
>+				 (u32) BIT(8), (u32) BIT(8));
> 
> 	if (info->ecc_mode_status & BIT(9))
> 		pci_write_bits32(pdev, AMD76X_ECC_MODE_STATUS,
>-				(u32) BIT(9), (u32) BIT(9));
>+				 (u32) BIT(9), (u32) BIT(9));
> }
> 
> /**
>@@ -130,7 +128,8 @@ static void amd76x_get_error_info(struct
>  *	then attempt to handle and clean up after the error
>  */
> static int amd76x_process_error_info(struct mem_ctl_info *mci,
>-		struct amd76x_error_info *info, int handle_errors)
>+				     struct amd76x_error_info *info,
>+				     int handle_errors)
> {
> 	int error_found;
> 	u32 row;
>@@ -138,7 +137,7 @@ static int amd76x_process_error_info(str
> 	error_found = 0;
> 
> 	/*
>-	 *	Check for an uncorrectable error
>+	 *      Check for an uncorrectable error
> 	 */
> 	if (info->ecc_mode_status & BIT(8)) {
> 		error_found = 1;
>@@ -146,12 +145,12 @@ static int amd76x_process_error_info(str
> 		if (handle_errors) {
> 			row = (info->ecc_mode_status >> 4) & 0xf;
> 			edac_mc_handle_ue(mci, mci->csrows[row].first_page, 0,
>-				row, mci->ctl_name);
>+					  row, mci->ctl_name);
> 		}
> 	}
> 
> 	/*
>-	 *	Check for a correctable error
>+	 *      Check for a correctable error
> 	 */
> 	if (info->ecc_mode_status & BIT(9)) {
> 		error_found = 1;
>@@ -159,7 +158,7 @@ static int amd76x_process_error_info(str
> 		if (handle_errors) {
> 			row = info->ecc_mode_status & 0xf;
> 			edac_mc_handle_ce(mci, mci->csrows[row].first_page, 0,
>-				0, row, 0, mci->ctl_name);
>+					  0, row, 0, mci->ctl_name);
> 		}
> 	}
> 
>@@ -182,7 +181,7 @@ static void amd76x_check(struct mem_ctl_
> }
> 
> static void amd76x_init_csrows(struct mem_ctl_info *mci, struct
>pci_dev *pdev,
>-		enum edac_type edac_mode)
>+			       enum edac_type edac_mode)
> {
> 	struct csrow_info *csrow;
> 	u32 mba, mba_base, mba_mask, dms;
>@@ -193,8 +192,7 @@ static void amd76x_init_csrows(struct me
> 
> 		/* find the DRAM Chip Select Base address and mask */
> 		pci_read_config_dword(pdev,
>-				      AMD76X_MEM_BASE_ADDR + (index * 4),
>-				      &mba);
>+				      AMD76X_MEM_BASE_ADDR + (index * 4), &mba);
> 
> 		if (!(mba & BIT(0)))
> 			continue;
>@@ -249,7 +247,7 @@ static int amd76x_probe1(struct pci_dev 
> 	mci->mtype_cap = MEM_FLAG_RDDR;
> 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_EC | EDAC_FLAG_SECDED;
> 	mci->edac_cap = ems_mode ?
>-			(EDAC_FLAG_EC | EDAC_FLAG_SECDED) : EDAC_FLAG_NONE;
>+	    (EDAC_FLAG_EC | EDAC_FLAG_SECDED) : EDAC_FLAG_NONE;
> 	mci->mod_name = EDAC_MOD_STR;
> 	mci->mod_ver = AMD76X_REVISION;
> 	mci->ctl_name = amd76x_devs[dev_idx].ctl_name;
>@@ -258,12 +256,12 @@ static int amd76x_probe1(struct pci_dev 
> 	mci->ctl_page_to_phys = NULL;
> 
> 	amd76x_init_csrows(mci, pdev, ems_modes[ems_mode]);
>-	amd76x_get_error_info(mci, &discard);  /* clear counters */
>+	amd76x_get_error_info(mci, &discard);	/* clear counters */
> 
> 	/* Here we assume that we will never see multiple instances of this
> 	 * type of memory controller.  The ID is therefore hardcoded to 0.
> 	 */
>-	if (edac_mc_add_mc(mci,0)) {
>+	if (edac_mc_add_mc(mci, 0)) {
> 		debugf3("%s(): failed edac_mc_add_mc()\n", __func__);
> 		goto fail;
> 	}
>@@ -272,14 +270,14 @@ static int amd76x_probe1(struct pci_dev 
> 	debugf3("%s(): success\n", __func__);
> 	return 0;
> 
>-fail:
>+      fail:
> 	edac_mc_free(mci);
> 	return -ENODEV;
> }
> 

I wonder whether Lindent is always use whitespaces, not tabs, before a label.

I think this should be fixed manually. And it seems that there shouldn't be any spaces before the label 'fail' in this context.

Regards!


WANG Cong

