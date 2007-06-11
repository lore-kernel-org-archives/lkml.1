Return-Path: <linux-kernel-owner+w=401wt.eu-S1756550AbXFKXI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbXFKXI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 19:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbXFKXIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 19:08:05 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:13318 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753475AbXFKXID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 19:08:03 -0400
Date: Mon, 11 Jun 2007 17:11:19 -0600
From: dougthompson@xmission.com
To: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH 1/5] driver edac i5000 code tidying
Message-ID: <466dd697.ueTQaZYB21H9sAXu%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Douglas Thompson <dougthompson@xmission.com>

Various code style conformance patches on the i5000 driver

Signed-off-by:	Douglas Thompson <dougthompson@xmission.com>
---
 i5000_edac.c |   71 +++++++++++++++++++++++++++++------------------------------
 1 file changed, 35 insertions(+), 36 deletions(-)

Index: linux-2.6.22-rc4-mm2/drivers/edac/i5000_edac.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/edac/i5000_edac.c
+++ linux-2.6.22-rc4-mm2/drivers/edac/i5000_edac.c
@@ -384,18 +384,18 @@ struct i5000_error_info {
 
 static struct edac_pci_ctl_info *i5000_pci;
 
-/******************************************************************************
+/*
  *	i5000_get_error_info	Retrieve the hardware error information from
  *				the hardware and cache it in the 'info'
  *				structure
  */
 static void i5000_get_error_info(struct mem_ctl_info *mci,
-				 struct i5000_error_info * info)
+				 struct i5000_error_info *info)
 {
 	struct i5000_pvt *pvt;
 	u32 value;
 
-	pvt = (struct i5000_pvt *)mci->pvt_info;
+	pvt = mci->pvt_info;
 
 	/* read in the 1st FATAL error register */
 	pci_read_config_dword(pvt->branchmap_werrors, FERR_FAT_FBD, &value);
@@ -457,7 +457,7 @@ static void i5000_get_error_info(struct 
 	}
 }
 
-/******************************************************************************
+/*
  * i5000_process_fatal_error_info(struct mem_ctl_info *mci,
  * 					struct i5000_error_info *info,
  * 					int handle_errors);
@@ -465,7 +465,7 @@ static void i5000_get_error_info(struct 
  *	handle the Intel FATAL errors, if any
  */
 static void i5000_process_fatal_error_info(struct mem_ctl_info *mci,
-					struct i5000_error_info * info,
+					struct i5000_error_info *info,
 					int handle_errors)
 {
 	char msg[EDAC_MC_LABEL_LEN + 1 + 90];
@@ -530,7 +530,7 @@ static void i5000_process_fatal_error_in
 	edac_mc_handle_fbd_ue(mci, rank, channel, channel + 1, msg);
 }
 
-/******************************************************************************
+/*
  * i5000_process_fatal_error_info(struct mem_ctl_info *mci,
  * 				struct i5000_error_info *info,
  * 				int handle_errors);
@@ -538,7 +538,7 @@ static void i5000_process_fatal_error_in
  *	handle the Intel NON-FATAL errors, if any
  */
 static void i5000_process_nonfatal_error_info(struct mem_ctl_info *mci,
-					struct i5000_error_info * info,
+					struct i5000_error_info *info,
 					int handle_errors)
 {
 	char msg[EDAC_MC_LABEL_LEN + 1 + 90];
@@ -666,12 +666,12 @@ static void i5000_process_nonfatal_error
 	}
 }
 
-/******************************************************************************
+/*
  *	i5000_process_error_info	Process the error info that is
  *	in the 'info' structure, previously retrieved from hardware
  */
 static void i5000_process_error_info(struct mem_ctl_info *mci,
-				struct i5000_error_info * info,
+				struct i5000_error_info *info,
 				int handle_errors)
 {
 	/* First handle any fatal errors that occurred */
@@ -681,7 +681,7 @@ static void i5000_process_error_info(str
 	i5000_process_nonfatal_error_info(mci, info, handle_errors);
 }
 
-/******************************************************************************
+/*
  *	i5000_clear_error	Retrieve any error from the hardware
  *				but do NOT process that error.
  *				Used for 'clearing' out of previous errors
@@ -694,7 +694,7 @@ static void i5000_clear_error(struct mem
 	i5000_get_error_info(mci, &info);
 }
 
-/******************************************************************************
+/*
  *	i5000_check_error	Retrieve and process errors reported by the
  *				hardware. Called by the Core module.
  */
@@ -706,7 +706,7 @@ static void i5000_check_error(struct mem
 	i5000_process_error_info(mci, &info, 1);
 }
 
-/******************************************************************************
+/*
  *	i5000_get_devices	Find and perform 'get' operation on the MCH's
  *			device/functions we want to reference for this driver
  *
@@ -718,7 +718,7 @@ static int i5000_get_devices(struct mem_
 	struct i5000_pvt *pvt;
 	struct pci_dev *pdev;
 
-	pvt = (struct i5000_pvt *)mci->pvt_info;
+	pvt = mci->pvt_info;
 
 	/* Attempt to 'get' the MCH register we want */
 	pdev = NULL;
@@ -827,7 +827,7 @@ static int i5000_get_devices(struct mem_
 	return 0;
 }
 
-/******************************************************************************
+/*
  *	i5000_put_devices	'put' all the devices that we have
  *				reserved via 'get'
  */
@@ -835,19 +835,18 @@ static void i5000_put_devices(struct mem
 {
 	struct i5000_pvt *pvt;
 
-	pvt = (struct i5000_pvt *)mci->pvt_info;
+	pvt = mci->pvt_info;
 
 	pci_dev_put(pvt->branchmap_werrors);	/* FUNC 1 */
 	pci_dev_put(pvt->fsb_error_regs);	/* FUNC 2 */
 	pci_dev_put(pvt->branch_0);	/* DEV 21 */
 
 	/* Only if more than 2 channels do we release the second branch */
-	if (pvt->maxch >= CHANNELS_PER_BRANCH) {
+	if (pvt->maxch >= CHANNELS_PER_BRANCH)
 		pci_dev_put(pvt->branch_1);	/* DEV 22 */
-	}
 }
 
-/******************************************************************************
+/*
  *	determine_amb_resent
  *
  *		the information is contained in NUM_MTRS different registers
@@ -879,7 +878,7 @@ static int determine_amb_present_reg(str
 	return amb_present;
 }
 
-/******************************************************************************
+/*
  * determine_mtr(pvt, csrow, channel)
  *
  *	return the proper MTR register as determine by the csrow and channel desired
@@ -896,7 +895,7 @@ static int determine_mtr(struct i5000_pv
 	return mtr;
 }
 
-/******************************************************************************
+/*
  */
 static void decode_mtr(int slot_row, u16 mtr)
 {
@@ -951,7 +950,7 @@ static void handle_channel(struct i5000_
 	}
 }
 
-/******************************************************************************
+/*
  *	calculate_dimm_size
  *
  *	also will output a DIMM matrix map, if debug is enabled, for viewing
@@ -1037,7 +1036,7 @@ static void calculate_dimm_size(struct i
 	kfree(mem_buffer);
 }
 
-/******************************************************************************
+/*
  *	i5000_get_mc_regs	read in the necessary registers and
  *				cache locally
  *
@@ -1053,7 +1052,7 @@ static void i5000_get_mc_regs(struct mem
 	int maxdimmperch;
 	int way0, way1;
 
-	pvt = (struct i5000_pvt *)mci->pvt_info;
+	pvt = mci->pvt_info;
 
 	pci_read_config_dword(pvt->system_address, AMBASE,
 			(u32 *) & pvt->ambase);
@@ -1151,7 +1150,7 @@ static void i5000_get_mc_regs(struct mem
 	calculate_dimm_size(pvt);
 }
 
-/******************************************************************************
+/*
  *	i5000_init_csrows	Initialize the 'csrows' table within
  *				the mci control	structure with the
  *				addressing of memory.
@@ -1171,7 +1170,7 @@ static int i5000_init_csrows(struct mem_
 	int channel;
 	int csrow;
 
-	pvt = (struct i5000_pvt *)mci->pvt_info;
+	pvt = mci->pvt_info;
 
 	channel_count = pvt->maxch;
 	max_csrows = pvt->maxdimmperch * 2;
@@ -1221,7 +1220,7 @@ static int i5000_init_csrows(struct mem_
 	return empty;
 }
 
-/******************************************************************************
+/*
  *	i5000_enable_error_reporting
  *			Turn on the memory reporting features of the hardware
  */
@@ -1230,7 +1229,7 @@ static void i5000_enable_error_reporting
 	struct i5000_pvt *pvt;
 	u32 fbd_error_mask;
 
-	pvt = (struct i5000_pvt *)mci->pvt_info;
+	pvt = mci->pvt_info;
 
 	/* Read the FBD Error Mask Register */
 	pci_read_config_dword(pvt->branchmap_werrors, EMASK_FBD,
@@ -1243,7 +1242,7 @@ static void i5000_enable_error_reporting
 			fbd_error_mask);
 }
 
-/******************************************************************************
+/*
  * i5000_get_dimm_and_channel_counts(pdev, &num_csrows, &num_channels)
  *
  *	ask the device how many channels are present and how many CSROWS
@@ -1265,7 +1264,7 @@ static void i5000_get_dimm_and_channel_c
 	*num_channels = (int)value;
 }
 
-/******************************************************************************
+/*
  *	i5000_probe1	Probe for ONE instance of device to see if it is
  *			present.
  *	return:
@@ -1329,7 +1328,7 @@ static int i5000_probe1(struct pci_dev *
 
 	mci->dev = &pdev->dev;	/* record ptr  to the generic device */
 
-	pvt = (struct i5000_pvt *)mci->pvt_info;
+	pvt = mci->pvt_info;
 	pvt->system_address = pdev;	/* Record this device in our private */
 	pvt->maxch = num_channels;
 	pvt->maxdimmperch = num_dimms_per_channel;
@@ -1401,7 +1400,7 @@ fail0:
 	return -ENODEV;
 }
 
-/******************************************************************************
+/*
  *	i5000_init_one	constructor for one instance of device
  *
  * 	returns:
@@ -1424,7 +1423,7 @@ static int __devinit i5000_init_one(stru
 	return i5000_probe1(pdev, id->driver_data);
 }
 
-/**************************************************************************
+/*
  *	i5000_remove_one	destructor for one instance of device
  *
  */
@@ -1446,7 +1445,7 @@ static void __devexit i5000_remove_one(s
 	edac_mc_free(mci);
 }
 
-/**************************************************************************
+/*
  *	pci_device_id	table for which devices we are looking for
  *
  *	The "E500P" device is the first device supported.
@@ -1460,7 +1459,7 @@ static const struct pci_device_id i5000_
 
 MODULE_DEVICE_TABLE(pci, i5000_pci_tbl);
 
-/**************************************************************************
+/*
  *	i5000_driver	pci_driver structure for this module
  *
  */
@@ -1471,7 +1470,7 @@ static struct pci_driver i5000_driver = 
 	.id_table = i5000_pci_tbl,
 };
 
-/**************************************************************************
+/*
  *	i5000_init		Module entry function
  *			Try to initialize this module for its devices
  */
@@ -1486,7 +1485,7 @@ static int __init i5000_init(void)
 	return (pci_rc < 0) ? pci_rc : 0;
 }
 
-/**************************************************************************
+/*
  *	i5000_exit()	Module exit function
  *			Unregister the driver
  */
