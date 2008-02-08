Return-Path: <linux-kernel-owner+w=401wt.eu-S1761431AbYBHQr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761431AbYBHQr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 11:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755796AbYBHQrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 11:47:48 -0500
Received: from hancock.steeleye.com ([71.30.118.248]:48608 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754985AbYBHQrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 11:47:47 -0500
Message-ID: <47AC87AE.9040408@steeleye.com>
Date: Fri, 08 Feb 2008 11:47:42 -0500
From: Paul Clements <paul.clements@steeleye.com>
User-Agent: Swiftdove 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, nbd-general@lists.sourceforge.net
Subject: [PATCH 1/1] NBD: make nbd default to deadline I/O scheduler
Content-Type: multipart/mixed;
 boundary="------------000502010208000601020109"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000502010208000601020109
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

There have been numerous reports of problems with nbd and cfq. Deadline 
gives better performance for nbd, anyway, so let's use it by default.

--
Paul

--------------000502010208000601020109
Content-Type: text/x-patch;
 name="nbd_default_to_deadline.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nbd_default_to_deadline.diff"

There have been numerous reports of problems with nbd and cfq. Deadline gives better performance for nbd, anyway, so let's use it by default.

Signed-Off-By: Paul Clements <paul.clements@steeleye.com>

--- ./drivers/block/nbd.c.max_nbd_killed	2008-02-07 16:46:24.000000000 -0500
+++ ./drivers/block/nbd.c	2008-02-08 11:38:47.000000000 -0500
@@ -667,6 +667,7 @@ static int __init nbd_init(void)
 			put_disk(disk);
 			goto out;
 		}
+		elevator_init(disk->queue, "deadline");
 	}
 
 	if (register_blkdev(NBD_MAJOR, "nbd")) {

--------------000502010208000601020109--
