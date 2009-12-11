Return-Path: <linux-kernel-owner+w=401wt.eu-S1762593AbZLKVCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762593AbZLKVCs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 16:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756858AbZLKVCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 16:02:45 -0500
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:59020 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876AbZLKVCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 16:02:45 -0500
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: linux-kernel@vger.kernel.org
Subject: K8 ECC error with linux-2.6.32
Date: Fri, 11 Dec 2009 22:02:47 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.32-fglrx; KDE/4.3.80; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912112202.48173.johannes.hirte@fem.tu-ilmenau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With kernel 2.6.32 I get now:

Dec 11 21:26:37 datengrab kernel: Northbridge Error, node 0, core: -1
Dec 11 21:26:37 datengrab kernel: K8 ECC error.

First I thought this triggered by radeon KMS, since with this driver I get 
lots of this entries in the log together with screen corruptions. It doesn't 
happen on X start up but after a while working with X.

Now I've seen that the ECC errors also appear with the proprietary fglrx 
driver. It only occours one time at X start up here

Dec 11 21:26:37 datengrab kernel: [fglrx] AGP detected, AgpState   = 
0x1f000b3b (hardware caps of chipset)
Dec 11 21:26:37 datengrab kernel: [fglrx] [agp] enabling AGP with 
mode=0x1f000b3a
Dec 11 21:26:37 datengrab kernel: agpgart-amd64 0000:00:00.0: AGP 3.0 bridge
Dec 11 21:26:37 datengrab kernel: agpgart-amd64 0000:00:00.0: putting AGP V3 
device into 8x mode
Dec 11 21:26:37 datengrab kernel: pci 0000:01:00.0: putting AGP V3 device into 
8x mode
Dec 11 21:26:37 datengrab kernel: [fglrx] AGP enabled,  AgpCommand = 
0x1f000312 (selected caps)
Dec 11 21:26:37 datengrab kernel: [fglrx] Setup AGP aperture
Dec 11 21:26:37 datengrab kernel: Northbridge Error, node 0, core: -1
Dec 11 21:26:37 datengrab kernel: K8 ECC error.
Dec 11 21:26:38 datengrab kernel: [fglrx] Could not enable MSI; System 
prevented initialization
Dec 11 21:26:38 datengrab kernel: [fglrx] Firegl kernel thread PID: 2565
Dec 11 21:26:39 datengrab kernel: [fglrx] Gart cacheable size:1316 M.
Dec 11 21:26:39 datengrab kernel: [fglrx] Reserved FB block: Shared offset:0, 
size:1000000
Dec 11 21:26:39 datengrab kernel: [fglrx] Reserved FB block: Unshared 
offset:fd0b000, size:2f5000
Dec 11 21:26:39 datengrab kernel: [fglrx] Reserved FB block: Unshared 
offset:1fffb000, size:5000

After forcing AGP 8x to 4x mode, it doesn't happen again with fglrx. I've 
changed drivers/char/agp/generic.c for this. For curiosity the radeon driver 
with KMS initialized AGP in 4x mode itself without the need to force it.

Dec  7 22:50:59 datengrab kernel: agpgart-amd64 0000:00:00.0: AGP 3.0 bridge
Dec  7 22:50:59 datengrab kernel: agpgart-amd64 0000:00:00.0: putting AGP V3 
device into 4x mode
Dec  7 22:50:59 datengrab kernel: radeon 0000:01:00.0: putting AGP V3 device 
into 4x mode

Nevertheless the ECC errors happen here together with the screen corruptions 
which make a restart of X necessary.

Any ideas whats going wrong here?

regards,
  Johannes
