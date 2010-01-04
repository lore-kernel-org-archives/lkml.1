Return-Path: <linux-kernel-owner+w=401wt.eu-S1753799Ab0ADVnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab0ADVnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 16:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250Ab0ADVnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 16:43:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:47893 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797Ab0ADVnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 16:43:20 -0500
Date: Mon, 4 Jan 2010 21:42:55 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de, jens.axboe@oracle.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, jens.axboe@oracle.com
In-Reply-To: <1261525263-13763-3-git-send-email-yinghai@kernel.org>
References: <1261525263-13763-3-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/pci: Intel ioh bus num reg accessing fix
Message-ID: <tip-a557aae29cf5916295c234d4b10ba3f8f29b8a96@git.kernel.org>
Git-Commit-ID: a557aae29cf5916295c234d4b10ba3f8f29b8a96
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a557aae29cf5916295c234d4b10ba3f8f29b8a96
Gitweb:     http://git.kernel.org/tip/a557aae29cf5916295c234d4b10ba3f8f29b8a96
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Tue, 22 Dec 2009 15:40:40 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 4 Jan 2010 13:21:51 -0800

x86/pci: Intel ioh bus num reg accessing fix

It is above 0x100 (PCI-Express extended register space), so if mmconf
is not enable, we can't access it.

[ hpa: changed the bound from 0x200 to 0x120, which is the tight
  bound. ]

Reported-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <1261525263-13763-3-git-send-email-yinghai@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/pci/intel_bus.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/intel_bus.c b/arch/x86/pci/intel_bus.c
index b7a55dc..f81a2fa 100644
--- a/arch/x86/pci/intel_bus.c
+++ b/arch/x86/pci/intel_bus.c
@@ -49,6 +49,10 @@ static void __devinit pci_root_bus_res(struct pci_dev *dev)
 	u64 mmioh_base, mmioh_end;
 	int bus_base, bus_end;
 
+	/* some sys doesn't get mmconf enabled */
+	if (dev->cfg_size < 0x120)
+		return;
+
 	if (pci_root_num >= PCI_ROOT_NR) {
 		printk(KERN_DEBUG "intel_bus.c: PCI_ROOT_NR is too small\n");
 		return;
