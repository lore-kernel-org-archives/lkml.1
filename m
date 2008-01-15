Return-Path: <linux-kernel-owner+w=401wt.eu-S1758148AbYAOV2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148AbYAOV2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 16:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757268AbYAOV12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 16:27:28 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:41139 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757208AbYAOV1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 16:27:24 -0500
Date: Tue, 15 Jan 2008 13:25:29 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, linux-sound@vger.kernel.org
Cc: perex@perex.cz, akpm <akpm@linux-foundation.org>, samr <sam@ravnborg.org>
Subject: [PATCH 4/5] sound: fix rme9652 section mismatch
Message-Id: <20080115132529.937171b7.randy.dunlap@oracle.com>
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

Fix section mismatch in hdsp:  snd_hdsp_proc_init() can be called from
an ioctl at any time.

WARNING: vmlinux.o(.text+0x1089bc2): Section mismatch: reference to .init.text: (between 'snd_hdsp_create_alsa_devices' and 'snd_hdsp_free')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 sound/pci/rme9652/hdsp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc7-git7.orig/sound/pci/rme9652/hdsp.c
+++ linux-2.6.24-rc7-git7/sound/pci/rme9652/hdsp.c
@@ -3558,7 +3558,7 @@ snd_hdsp_proc_read(struct snd_info_entry
 
 }
 
-static void __devinit snd_hdsp_proc_init(struct hdsp *hdsp)
+static void snd_hdsp_proc_init(struct hdsp *hdsp)
 {
 	struct snd_info_entry *entry;
 
