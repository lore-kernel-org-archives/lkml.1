Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbXHUU1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbXHUU1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 16:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbXHUU1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 16:27:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbXHUU1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 16:27:38 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: ak@suse.de, akpm@linux-foundation.org, rusty@rustycorp.com.au,
       lguest@ozlabs.org, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH] turn err into errx in lguest call sites
Date: Tue, 21 Aug 2007 17:28:37 -0300
Message-Id: <1187728117715-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.2.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These two callsites should really be errx instead of err, since there is
no errno associated with them in the moment they are issued.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 Documentation/lguest/lguest.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/lguest/lguest.c b/Documentation/lguest/lguest.c
index f791840..c9d41e9 100644
--- a/Documentation/lguest/lguest.c
+++ b/Documentation/lguest/lguest.c
@@ -159,7 +159,7 @@ static unsigned long entry_point(void *start, void *end,
 		if (memcmp(p, "GenuineLguest", strlen("GenuineLguest")) == 0)
 			return (long)p + strlen("GenuineLguest") + page_offset;
 
-	err(1, "Is this image a genuine lguest?");
+	errx(1, "Is this image a genuine lguest?");
 }
 
 /* This routine takes an open vmlinux image, which is in ELF, and maps it into
@@ -858,7 +858,7 @@ static u32 handle_block_output(int fd, const struct iovec *iov,
 	/* We first check that the read or write is within the length of the
 	 * block file. */
 	if (off >= device_len)
-		err(1, "Bad offset %llu vs %llu", off, device_len);
+		errx(1, "Bad offset %llu vs %llu", off, device_len);
 	/* Move to the right location in the block file.  This shouldn't fail,
 	 * but best to check. */
 	if (lseek64(dev->fd, off, SEEK_SET) != off)
-- 
1.5.2.2

