Return-Path: <linux-kernel-owner+w=401wt.eu-S1751330AbXBNXUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbXBNXUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 18:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbXBNXUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 18:20:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33407 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbXBNXUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 18:20:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@osdl.org>
Subject: 2.6.20-git10: BUG at drivers/pci/pci.c:817 during suspend to disk
Date: Thu, 15 Feb 2007 00:16:24 +0100
User-Agent: KMail/1.9.5
Cc: Jeff Garzik <jeff@garzik.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702150016.24865.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've got this in the resume-during-suspend phase of suspend to disk with
2.6.20-git10 on HPC nx6325:

PCI: Setting latency timer of device 0000:00:06.0 to 64
sata_sil 0000:00:12.0: resuming
BUG: at drivers/pci/pci.c:817 pcim_enable_device()

Call Trace:
 [<ffffffff8031c05e>] pcim_enable_device+0x93/0xb3
 [<ffffffff8039a74c>] ata_pci_device_do_resume+0x21/0x5e
 [<ffffffff803a5f8a>] sil_pci_device_resume+0x1c/0x51
 [<ffffffff8031e072>] pci_device_resume+0x22/0x53
 [<ffffffff8038bea4>] resume_device+0xca/0x131
 [<ffffffff8038bf8c>] dpm_resume+0x81/0xd3
 [<ffffffff8038c00e>] device_resume+0x30/0x45
 [<ffffffff802a0d8c>] snapshot_ioctl+0x245/0x63e
 [<ffffffff8023f7f2>] do_ioctl+0x5e/0x77
 [<ffffffff8022dab2>] vfs_ioctl+0x25c/0x279
 [<ffffffff8024948a>] sys_ioctl+0x5f/0x82
 [<ffffffff8021555d>] sys_write+0x47/0x70
 [<ffffffff8025911e>] system_call+0x7e/0x83

The box has survived the entire suspend-resume cycle, though, and seems to be
fully functional.

Greetings,
Rafael


-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King
