Return-Path: <linux-kernel-owner+w=401wt.eu-S1762756AbYDVKRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762756AbYDVKRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 06:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbYDVKRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 06:17:07 -0400
Received: from hu-out-0506.google.com ([72.14.214.239]:25674 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbYDVKRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 06:17:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:message-id;
        b=d4eI2R80gxtW0f0dsbwMSnA7RNEw98UKgdnis3JwmzoRmDnAFGsz1sRgDWcPZxTWCdP8kAxDDX7hIbXzOrLEgj8mBir7caHON4kbaIgMjHD7Y5EgshGmjTMTgsYYqrKf2YzV2OruOw+sJ8UEoT/NgGB97xZVw4WcpEWPnGSNi1Q=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: David Chinner <dgc@sgi.com>
Subject: [PATCH] xfs: remove unused parameter of xfs_iomap_write_allocate
Date: Tue, 22 Apr 2008 12:16:25 +0200
User-Agent: KMail/1.8.2
Cc: Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080419142329.GA5339@elte.hu> <200804220514.45191.vda.linux@googlemail.com> <200804221142.00914.vda.linux@googlemail.com>
In-Reply-To: <200804221142.00914.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_5rbDIdg/x1aYHDd"
Message-Id: <200804221216.25905.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_5rbDIdg/x1aYHDd
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi David,

xfs_iomap_write_allocate() does not use count parameter.
This patch removes it.

Code size difference on 32-bit x86:

# size */fs/xfs/xfs.o
 393457    2904    2952  399313   617d1 linux-2.6-xfs4-TEST/fs/xfs/xfs.o
 393441    2904    2952  399297   617c1 linux-2.6-xfs5-TEST/fs/xfs/xfs.o

Compile tested only.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_5rbDIdg/x1aYHDd
Content-Type: text/x-diff;
  charset="koi8-r";
  name="xfs4-xfs_iomap_write_allocate-remove_unused_params.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="xfs4-xfs_iomap_write_allocate-remove_unused_params.patch"

--- linux-2.6-xfs4/fs/xfs/xfs_iomap.c	Tue Apr 22 04:06:44 2008
+++ linux-2.6-xfs5/fs/xfs/xfs_iomap.c	Tue Apr 22 11:59:32 2008
@@ -267,7 +267,7 @@
 			break;
 		}
 
-		error = xfs_iomap_write_allocate(ip, offset, count,
+		error = xfs_iomap_write_allocate(ip, offset,
 						 &imap, &nimaps);
 		break;
 	}
@@ -710,7 +710,6 @@
 xfs_iomap_write_allocate(
 	xfs_inode_t	*ip,
 	xfs_off_t	offset,
-	size_t		count,
 	xfs_bmbt_irec_t *map,
 	int		*retmap)
 {
--- linux-2.6-xfs4/fs/xfs/xfs_iomap.h	Tue Apr 22 04:06:44 2008
+++ linux-2.6-xfs5/fs/xfs/xfs_iomap.h	Tue Apr 22 11:59:16 2008
@@ -80,7 +80,7 @@
 				  int, struct xfs_bmbt_irec *, int *, int);
 extern int xfs_iomap_write_delay(struct xfs_inode *, xfs_off_t, size_t, int,
 				 struct xfs_bmbt_irec *, int *);
-extern int xfs_iomap_write_allocate(struct xfs_inode *, xfs_off_t, size_t,
+extern int xfs_iomap_write_allocate(struct xfs_inode *, xfs_off_t,
 				struct xfs_bmbt_irec *, int *);
 extern int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, size_t);
 

--Boundary-00=_5rbDIdg/x1aYHDd--
