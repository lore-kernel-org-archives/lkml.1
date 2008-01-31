Return-Path: <linux-kernel-owner+w=401wt.eu-S1761690AbYAaD5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761690AbYAaD5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 22:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbYAaD5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 22:57:12 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:58958 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbYAaD5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 22:57:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Nnk/KWAZ9zooCxHB3Ht8NtaGH/qK+IZIPnaeWrYNy3BuuW4FiG/sDneLZm5MuxoCSzghxKufhZlfuhGJHbeEGyPWLvq9U9jYVtnHX1KA9wEsvt0IQBQdD06hcREk4C6q+CZBZbfTV1tVCF/C/TEmF7z6DG+14rgqqiT6E1nxeVA=
Subject: [PATCH] x86: fix sparse warning in kernel/scx200_32.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain
Date: Wed, 30 Jan 2008 19:57:08 -0800
Message-Id: <1201751829.23523.5.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/scx200_32.c:68:72: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/scx200_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/scx200_32.c b/arch/x86/kernel/scx200_32.c
index 87bc159..7e004ac 100644
--- a/arch/x86/kernel/scx200_32.c
+++ b/arch/x86/kernel/scx200_32.c
@@ -65,7 +65,7 @@ static int __devinit scx200_probe(struct pci_dev *pdev, const struct pci_device_
 		base = pci_resource_start(pdev, 0);
 		printk(KERN_INFO NAME ": GPIO base 0x%x\n", base);
 
-		if (request_region(base, SCx200_GPIO_SIZE, "NatSemi SCx200 GPIO") == 0) {
+		if (!request_region(base, SCx200_GPIO_SIZE, "NatSemi SCx200 GPIO")) {
 			printk(KERN_ERR NAME ": can't allocate I/O for GPIOs\n");
 			return -EBUSY;
 		}
-- 
1.5.4.rc4.1142.gf5a97



