Return-Path: <linux-kernel-owner+w=401wt.eu-S1757038AbYGHTEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038AbYGHTEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 15:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbYGHTE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 15:04:29 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:59067 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbYGHTE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 15:04:28 -0400
Date: Tue, 8 Jul 2008 15:04:27 -0400
From: Kyle McMartin <kmcmartin@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] padlock: don't whinge when loaded on a non-VIA cpu
Message-ID: <20080708190427.GA28899@phobos.i.cabal.ca>
Reply-To: kyle@mcmartin.ca
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've become seriously tired of seeing these messages on every machine
running an i386 Fedora kernel...

padlock: VIA PadLock not detected.
padlock: VIA PadLock Hash Engine not detected.

So let's eliminate them!

Signed-off-by: Kyle McMartin <kmcmartin@redhat.com>

---
diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index bb30eb9..c11f456 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -384,6 +384,9 @@ static int __init padlock_init(void)
 {
 	int ret;
 
+	if (!(boot_cpu_data.x86_vendor == X86_VENDOR_CENTAUR))
+		return -ENODEV;
+
 	if (!cpu_has_xcrypt) {
 		printk(KERN_ERR PFX "VIA PadLock not detected.\n");
 		return -ENODEV;
diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
index c666b4e..9b360fb 100644
--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -253,6 +253,9 @@ static int __init padlock_init(void)
 {
 	int rc = -ENODEV;
 
+	if (!(boot_cpu_data.x86_vendor == X86_VENDOR_CENTAUR))
+		return -ENODEV;
+
 	if (!cpu_has_phe) {
 		printk(KERN_ERR PFX "VIA PadLock Hash Engine not detected.\n");
 		return -ENODEV;
