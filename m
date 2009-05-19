Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbZESH7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbZESH7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 03:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbZESH7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 03:59:09 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:39316 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbZESH7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 03:59:08 -0400
Message-ID: <4A1266CC.5040801@linux.vnet.ibm.com>
Date: Tue, 19 May 2009 09:59:08 +0200
From: Stefan Raspl <raspl@linux.vnet.ibm.com>
Reply-To: raspl@linux.vnet.ibm.com
User-Agent: Thunderbird 2.0.0.12 (X11/20080303)
MIME-Version: 1.0
To: mingo@redhat.com, Li Zefan <lizf@cn.fujitsu.com>, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, linux-btrace@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [Patch updated] blktrace: remove debugfs entries on bad path
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

debugfs directory entries for devices are not removed on some
of the failure pathes in do_blk_trace_setup().
One way to reproduce is to start blktrace on multiple devices
with insufficient Vmalloc space: Devices will fail with
a message like this:

	BLKTRACESETUP(2) /dev/sdu failed: 5/Input/output error

If so, the respective entries in debugfs
(e.g. /sys/kernel/debug/block/sdu) will remain and subsequent
attempts to start blktrace on the respective devices will not
succeed due to existing directories.



Acked-by: Li Zefan <lizf@cn.fujitsu.com>
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
