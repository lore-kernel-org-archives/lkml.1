Return-Path: <linux-kernel-owner+w=401wt.eu-S1751935AbXLITEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbXLITEG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 14:04:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbXLITDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 14:03:54 -0500
Received: from ext-nj2ut-1.online-age.net ([64.14.54.230]:15955 "EHLO
	ext-nj2ut-1.online-age.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750965AbXLITDx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 14:03:53 -0500
X-Greylist: delayed 658 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Dec 2007 14:03:52 EST
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH 1/1] fix 2.6.24-rc1 nfs_file_mmap change for NOMMU
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Sun, 9 Dec 2007 19:52:37 +0100
Message-ID: <050A770C1DB41144817F02E395E493104CE014@FLRMLVEM02.e2k.ad.ge.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] fix 2.6.24-rc1 nfs_file_mmap change for NOMMU
Thread-Index: Acg6lKsKXdk9InWuRDiEQ5tf2iA5oQ==
From: "Berkhan, Enrik (GE Infra, Oil & Gas)" <enrik.berkhan@ge.com>
To: <trond.myklebust@fys.uio.no>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 09 Dec 2007 18:52:52.0687 (UTC) FILETIME=[B3D76DF0:01C83A94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- generic_file_mmap returns -ENOSYS for NOMMU systems; replicate this
  behaviour

Signed-off-by: Enrik Berkhan <Enrik.Berkhan@ge.com>
---
 fs/nfs/file.c |    4 ++++
 1 files changed, 4 insertions(+)

Index: fs/nfs/file.c
===================================================================
--- fs/nfs/file.c.orig	2007-12-05 09:48:59.000000000 +0100
+++ fs/nfs/file.c	2007-12-05 09:49:56.000000000 +0100
@@ -283,7 +283,11 @@ nfs_file_mmap(struct file * file, struct
 	if (!status) {
 		vma->vm_ops = &nfs_file_vm_ops;
 		vma->vm_flags |= VM_CAN_NONLINEAR;
+#ifdef CONFIG_MMU
 		file_accessed(file);
+#else
+		return -ENOSYS;
+#endif
 	}
 	return status;
 }
