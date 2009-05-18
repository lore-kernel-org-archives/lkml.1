Return-Path: <linux-kernel-owner+w=401wt.eu-S1753450AbZERM7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbZERM7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 08:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbZERM7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 08:59:21 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:61055 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbZERM7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 08:59:20 -0400
Message-ID: <4A115BA5.6090905@linux.vnet.ibm.com>
Date: Mon, 18 May 2009 14:59:17 +0200
From: Stefan Raspl <raspl@linux.vnet.ibm.com>
Reply-To: raspl@linux.vnet.ibm.com
User-Agent: Thunderbird 2.0.0.12 (X11/20080303)
MIME-Version: 1.0
To: linux-btrace@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com
Subject: [Patch] Remove debugfs entries on bad path
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

debugfs directory entries for devices are not removed on bad path.
If so, subsequent attempts to start blktrace on the respective
devices will not succeed due to existing directories.

Signed-off-by: Stefan Raspl <stefan.raspl@linux.vnet.ibm.com>

---
 kernel/trace/blktrace.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -262,6 +262,7 @@ static void blk_trace_free(struct blk_tr
 {
 	debugfs_remove(bt->msg_file);
 	debugfs_remove(bt->dropped_file);
+	debugfs_remove(bt->dir);
 	relay_close(bt->rchan);
 	free_percpu(bt->sequence);
 	free_percpu(bt->msg_data);

