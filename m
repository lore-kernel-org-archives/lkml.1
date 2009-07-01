Return-Path: <linux-kernel-owner+w=401wt.eu-S1758634AbZGABW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634AbZGABW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765502AbZGABEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 21:04:21 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:59225 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765500AbZGABES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 21:04:18 -0400
From: Andy Isaacson <adi@vmware.com>
To: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Cc: adi@hexapodia.org, Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       dds@google.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Shahbaz Khan <shaz.linux@gmail.com>, seiji.munetoh@gmail.com
Subject: [PATCH 0/6] tpm_tis: various cleanups, and support for Intel iTPM
Date: Tue, 30 Jun 2009 18:04:09 -0700
Message-Id: <1246410255-6839-1-git-send-email-adi@vmware.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several patches to improve drivers/char/tpm/tpm_tis.c:

 - autoload tpm_tis.ko based on acpi / pnp
 - fix driver/hardware bugs observed on iTPM
 - improve module probing printks
 - add workaround code for iTPM

With these patches, the T500's iTPM probes ok and has reasonable
contents in /sys/kernel/security/tpm0/ascii_bios_measurements:

% dmesg|grep tpm
[    8.599680] tpm_tis INTC0102:00: found 0xfed40000(0x5000)
[    8.599769] tpm_tis INTC0102:00: no IRQ found in _CRS, polling mode
[    8.608607] tpm_tis INTC0102:00: 1.2 TPM (8086:1020 rev 6)
[    8.608665] tpm_tis INTC0102:00: Intel iTPM workaround enabled
% sudo head -3 /sys/kernel/security/tpm0/ascii_bios_measurements
 0 d6184a2d2e3a8bfae13a1ebb37d62e222bfab57d 08 [S-CRTM Version]
 1 0f18524a0ed83806de3bab13c05e2dcc7a8e9c09 09 [CPU Microcode]
 0 d9f7d65755c884f6c25680d577f348523006eed3 01 [POST CODE]

Also, I've tested that the driver still works on Dell E4300.

I'm not sure that switching to ACPI probing is either necessary or a
good idea, but I wasn't able to get the pnp_driver system to load the
driver on the Lenovo.

 drivers/char/tpm/Kconfig   |    2 +-
 drivers/char/tpm/tpm_tis.c |  202 +++++++++++++++++------
 2 files changed, 150 insertions(+), 54 deletions(-)

-andy
