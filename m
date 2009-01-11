Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353AbZAKLnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbZAKLnt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 06:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbZAKLnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 06:43:39 -0500
Received: from mail00a.mail.t-online.hu ([84.2.40.5]:60937 "EHLO
	mail00a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbZAKLni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 06:43:38 -0500
Message-ID: <4969DB65.3090309@freemail.hu>
Date: Sun, 11 Jan 2009 12:43:33 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: block: how shall register_blkdev() work?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail00a.mail.t-online.hu 32722; Body=2 Fuz1=2
	Fuz2=2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I started to write some testcases for register_blkdev(), see
http://sourceforge.net/mailarchive/forum.php?thread_name=4969BE28.2030303%40freemail.hu&forum_name=ltp-list .

I am not sure how register_blkdev() should work, so I tried to
write down what I could find out so far, but there are still some open
questions.

Could you please review and correct the following description?

Signed-off-by: Márton Németh <nm127@freemail.hu>

--- linux-2.6.28/block/genhd.c.orig	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.28/block/genhd.c	2009-01-11 12:27:02.000000000 +0100
@@ -244,6 +244,24 @@ void blkdev_show(struct seq_file *seqf,
 }
 #endif /* CONFIG_PROC_FS */

+/**
+ * register_blkdev - register a new block device
+ *
+ * @major: [in] the requested major device number [1..255]. If
+ *         @major=0, try to allocate any unused major number.
+ * @name: [in] the name of the new block device
+ *
+ * ??? The @name must be unique within the system. ???
+ * OR: ??? You can use any zero terminated @name string. Note, however, if
+ *         you use a name which is already used it might mask the previous
+ *         device. ???
+ *
+ * Returns the allocated major number [1..255] or the return value is
+ * a negative error code if the wanted @major number is not available
+ * or there is no more major nubmers available when @major=0.
+ *
+ * ??? What does the return value 0 mean?
+ */
 int register_blkdev(unsigned int major, const char *name)
 {
 	struct blk_major_name **n, *p;



Regards,

	Márton Németh
