Return-Path: <linux-kernel-owner+w=401wt.eu-S1758281AbYILXhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281AbYILXhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 19:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756618AbYILXhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 19:37:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756064AbYILXhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 19:37:37 -0400
Date: Fri, 12 Sep 2008 16:36:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: me@bobcopeland.com, stern@rowland.harvard.edu,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       bogdano@mandriva.com.br, lcapitulino@mandriva.com.br,
       draconux@gmail.com, dlallement@mandriva.com, pterjan@mandriva.com,
       axboe@kernel.dk
Subject: Re: Partition check considered as error is breaking mounting in
 2.6.27
Message-Id: <20080912163650.0f85a759.akpm@linux-foundation.org>
In-Reply-To: <200809121807.28345.herton@mandriva.com.br>
References: <Pine.LNX.4.44L0.0809121423030.14509-100000@iolanthe.rowland.org>
	<200809121714.05443.herton@mandriva.com.br>
	<b6c5339f0809121327k5fd6c980le0ec5d46be089af2@mail.gmail.com>
	<200809121807.28345.herton@mandriva.com.br>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2008 18:07:27 -0300
Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:

> Yes, here goes a new version:

Well gee.  Given a choice, I went and replied to the wrong thread. 
Here's what I think:

From: Andrew Morton <akpm@linux-foundation.org>

Herton Krzesinski reports that the error-checking changes in
04ebd4aee52b06a2c38127d9208546e5b96f3a19 ("block/ioctl.c and
fs/partition/check.c: check value returned by add_partition") cause his
buggy USB camera to no longer mount.  "The camera is an Olympus X-840. 
The original issue comes from the camera itself: its format program
creates a partition with an off by one error".

Buggy devices happen.  It is better for the kernel to warn and to proceed
with the mount.

Reported-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: Abdel Benamrouche <draconux@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/check.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/partitions/check.c~rescan_partitions-make-device-capacity-errors-non-fatal fs/partitions/check.c
--- a/fs/partitions/check.c~rescan_partitions-make-device-capacity-errors-non-fatal
+++ a/fs/partitions/check.c
@@ -540,7 +540,6 @@ int rescan_partitions(struct gendisk *di
 		if (from + size > get_capacity(disk)) {
 			printk(KERN_ERR " %s: p%d exceeds device capacity\n",
 				disk->disk_name, p);
-			continue;
 		}
 		res = add_partition(disk, p, from, size, state->parts[p].flags);
 		if (res) {
_

