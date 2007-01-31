Return-Path: <linux-kernel-owner+w=401wt.eu-S1030274AbXAaQuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030274AbXAaQuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 11:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030283AbXAaQuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 11:50:52 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59725 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030274AbXAaQuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 11:50:51 -0500
Date: Wed, 31 Jan 2007 17:02:57 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: [PATCH] ubi:  int versus size_t printk warnings
Message-ID: <20070131170257.79ca59b7@localhost.localdomain>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Another mtd driver, another set of 32bit assumptions. Please compile mtd
stuff on 64bit now and then, or if stuff is for 32bit only systems then
add the right CONFIG rules.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-rc6-mm3/drivers/mtd/ubi/io.c linux-2.6.20-rc6-mm3/drivers/mtd/ubi/io.c
--- linux.vanilla-2.6.20-rc6-mm3/drivers/mtd/ubi/io.c	2007-01-31 14:20:41.000000000 +0000
+++ linux-2.6.20-rc6-mm3/drivers/mtd/ubi/io.c	2007-01-31 15:24:50.142281168 +0000
@@ -129,8 +129,8 @@
 			yield();
 			goto retry;
 		}
-		ubi_err("error %d while reading %d bytes from PEB %d:%d, "
-			"read %d bytes", err, len, pnum, offset, *read);
+		ubi_err("error %d while reading %Zd bytes from PEB %d:%d, "
+			"read %Zd bytes", err, len, pnum, offset, *read);
 		dump_stack();
 	}
 
@@ -190,14 +190,14 @@
 
 	err = mtd_write(io, buf, pnum, offset, len, written);
 	if (unlikely(err)) {
-		ubi_err("error %d while writing %d bytes to PEB %d:%d, written"
-			" %d bytes", err, len, pnum, offset, *written);
+		ubi_err("error %d while writing %Zd bytes to PEB %d:%d, written"
+			" %Zd bytes", err, len, pnum, offset, *written);
 		dump_stack();
 	}
 
 	/* The below is just for debugging and is compiled out if disabled */
 	if (ubi_dbg_is_write_failure() && !err) {
-		ubi_err("cannot write %d bytes to PEB %d:%d (emulated)",
+		ubi_err("cannot write %Zd bytes to PEB %d:%d (emulated)",
 			len, pnum, offset);
 		dump_stack();
 		return -EIO;
@@ -597,7 +597,7 @@
 
 		/* The shift must be aligned to 32-bit boundary */
 		if (io->vid_hdr_shift % 4) {
-			ubi_err("unaligned VID header shift %d",
+			ubi_err("unaligned VID header shift %Zd",
 				io->vid_hdr_shift);
 			goto out_mtd;
 		}
@@ -615,7 +615,7 @@
 	    io->leb_start < io->vid_hdr_offset + UBI_VID_HDR_SIZE ||
 	    io->leb_start > io->peb_size - UBI_VID_HDR_SIZE ||
 	    io->leb_start % io->min_io_size) {
-		ubi_err("bad VID header (%d) or data offsets (%d)",
+		ubi_err("bad VID header (%Zd) or data offsets (%Zd)",
 			io->vid_hdr_offset, io->leb_start);
 		goto out_mtd;
 	}
@@ -847,12 +847,12 @@
 		goto bad;
 	}
 	if (unlikely(vid_hdr_offset != io->vid_hdr_offset)) {
-		ubi_err("bad VID header offset %d at PEB %d, expected %d",
+		ubi_err("bad VID header offset %d at PEB %d, expected %Zd",
 			vid_hdr_offset, pnum, io->vid_hdr_offset);
 		goto bad;
 	}
 	if (unlikely(leb_start != io->leb_start)) {
-		ubi_err("bad data offset %d at PEB %d, expected %d",
+		ubi_err("bad data offset %d at PEB %d, expected %Zd",
 			pnum, leb_start, io->leb_start);
 		goto bad;
 	}
