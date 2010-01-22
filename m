Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048Ab0AVRto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab0AVRto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 12:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755355Ab0AVRto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 12:49:44 -0500
Received: from mga11.intel.com ([192.55.52.93]:13723 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280Ab0AVRtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 12:49:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,324,1262592000"; 
   d="scan'208";a="533701478"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, alan@linux.intel.com,
       charles.f.johnson@intel.com
Cc: Mark Allyn <mark.a.allyn@intel.com>
Subject: Introduction to rar_register patch set of 5 patches
Date: Fri, 22 Jan 2010 09:53:30 -0800
Message-Id: <1264182811-28933-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following five patches are for the Restricted Access Region
Register (rar_register) driver.

This driver is for the Intel MID platform.

Restricted access regions are regions of memory that can be
locked so that the x86 processor cannot access them. However,
peripheral devices with DMA can access them.

Restricted access regions are used to protect sensitive 
information from access by unauthorized software running
on the x86 processor.

The scenario is that encrypted information is presented to
an encryption/decryption device. That device in turn does
decryption of the information and places into one of the
restricted access regions. Another device can then access
and use the decrypted information. The x86 processor, however,
cannot see that data.

The rar_register driver provides address information for the
individual restricted access regions to other device driver
that need to use the regions. 

The rar_register also locks restricted access regions upon
request by other device drivers. 

The rar_register device does not interact with user space
processes at all. It only ineracts with other device driver.

There are five patches. They are:

Patch 1 of 5 for rar_register; renaming to rar_register
	This renames the current rar resigter driver to
	the name rar_register. This is to differentiate
	it from the rar_handler driver, which will be
	submitted later.
Patch 2 of 5 for rar_register - renaming directory to rar_register
	This renames the directory in which the driver files
	are located; again for clarity.
Patch 3 of 5 for rar_register - provide better explanation in Kconfig
	This patch provides a better explanation of what this
	driver is for in the Kconfig file
Patch 4 of 5 for rar_register - fix checkpatch errors and debug header
	This patch cleans up checkpatch errors and warnings as well as
	fixes bugs in the rar_register.h header file
Patch 5 of 5 for rar_register - fix checkpatch errors and debug program file
	This patch cleans up checkpatch errors and warnings as well as
	fixes bugs in the rar_register.c program file

Please note that patches 1, 2, and 3 are for 'housekeeping'. They do nothing
to correct any checkpatch errors/warnings in the driver.

Patches 4 and 5 clean up checkpatch issues in the rar_register.h and
rar_register.c file respectively.

After patch 5 is applied, there should be no checkpatch issues in the entire
driver directory


Please note that I did a test build of this patch set after patch 3 and after
patch 5 of this set.

If there are issues with either patch 4 or patch 5, you can still submit 
patches 1, 2, and 3 and expect a clean build.

These patches were applied against the kernel next that I pulled as of Wednesday, 
January 21, 2010.

Mark Allyn
mark.a.allyn@intel.com
