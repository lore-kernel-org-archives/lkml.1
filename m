Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbYB1A5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbYB1A5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 19:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761476AbYB1A4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 19:56:24 -0500
Received: from el-out-1112.google.com ([209.85.162.177]:41507 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761415AbYB1A4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 19:56:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YQidC7zvb1oxw7y/qNHgEyEmRbgp3j0jHgGRCHtJ4xtZTK4hdc/GCJ4RDHxFTUHgkHxhGDAl+VZPWUdMt45ouP6ewL8N9kFQaOA8nH16k176OPzzuDEKokeADbWQUvwoO27f6Lw1vM6o1uQH7izvHN6YkfS8zd7QoawTm9636C0=
Subject: [PATCH 06/12] sound: rme32.c fix integer as NULL pointer warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 16:56:06 -0800
Message-Id: <1204160167.20280.54.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel style does assignment outside of if() statements.
sound/pci/rme32.c:1353:71: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 sound/pci/rme32.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/sound/pci/rme32.c b/sound/pci/rme32.c
index df184aa..e7ef3a1 100644
--- a/sound/pci/rme32.c
+++ b/sound/pci/rme32.c
@@ -1350,7 +1350,8 @@ static int __devinit snd_rme32_create(struct rme32 * rme32)
 		return err;
 	rme32->port = pci_resource_start(rme32->pci, 0);
 
-	if ((rme32->iobase = ioremap_nocache(rme32->port, RME32_IO_SIZE)) == 0) {
+	rme32->iobase = ioremap_nocache(rme32->port, RME32_IO_SIZE);
+	if (!rme32->iobase) {
 		snd_printk(KERN_ERR "unable to remap memory region 0x%lx-0x%lx\n",
 			   rme32->port, rme32->port + RME32_IO_SIZE - 1);
 		return -ENOMEM;
-- 
1.5.4.3.342.g99e8


