Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933735Ab0BESrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 13:47:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:12974 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933708Ab0BESri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 13:47:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,414,1262592000"; 
   d="scan'208";a="490020771"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, alan@linux.intel.com,
       charles.f.johnson@intel.com, greg@kroah.com
Cc: Mark Allyn <mark.a.allyn@intel.com>
Subject: Patch set for Restricted Access Region Register driver
Date: Fri,  5 Feb 2010 10:51:52 -0800
Message-Id: <1265395912-15918-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following six patches are for the Restricted Access Region
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

There are six patches:

1 renaming driver to rar_register
2 renaming directory to rar_register
3 provide better explanation in Kconfig
4 fix checkpatch errors and debug header file
5 fix checkpatch errors and debug program file
6 add suspend and resume functions

Patches 1 and 2 are for renaming the driver from
rar to rar_register. They do not fix checkpatch issues.

A sucessful build was completed following all of these
patches.

