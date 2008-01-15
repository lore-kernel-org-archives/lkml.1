Return-Path: <linux-kernel-owner+w=401wt.eu-S1755427AbYAOV1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbYAOV1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 16:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757199AbYAOV1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 16:27:24 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:41111 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108AbYAOV1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 16:27:22 -0500
Date: Tue, 15 Jan 2008 13:25:13 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, linux-sound@vger.kernel.org
Cc: perex@perex.cz, akpm <akpm@linux-foundation.org>, samr <sam@ravnborg.org>
Subject: [PATCH 3/5] sound: fix atiixp section mismatch
Message-Id: <20080115132513.8aecc399.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section mismatch in atiixp by making some functions __devinit.

WARNING: vmlinux.o(.text+0xfd9304): Section mismatch: reference to .init.data:atiixp_quirks (between 'ac97_probing_bugs' and 'snd_atiixp_codec_detect')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 sound/pci/atiixp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.24-rc7-git7.orig/sound/pci/atiixp.c
+++ linux-2.6.24-rc7-git7/sound/pci/atiixp.c
@@ -560,7 +560,7 @@ static int snd_atiixp_aclink_down(struct
 	     ATI_REG_ISR_CODEC2_NOT_READY)
 #define CODEC_CHECK_BITS (ALL_CODEC_NOT_READY|ATI_REG_ISR_NEW_FRAME)
 
-static int ac97_probing_bugs(struct pci_dev *pci)
+static int __devinit ac97_probing_bugs(struct pci_dev *pci)
 {
 	const struct snd_pci_quirk *q;
 
@@ -574,7 +574,7 @@ static int ac97_probing_bugs(struct pci_
 	return -1;
 }
 
-static int snd_atiixp_codec_detect(struct atiixp *chip)
+static int __devinit snd_atiixp_codec_detect(struct atiixp *chip)
 {
 	int timeout;
 
