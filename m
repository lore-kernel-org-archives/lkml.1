Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbYJNGed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbYJNGed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 02:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540AbYJNGeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 02:34:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53428 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbYJNGeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 02:34:23 -0400
Message-ID: <48F43D68.40300@cn.fujitsu.com>
Date: Tue, 14 Oct 2008 14:34:16 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] block: simplify string handling in elv_iosched_store()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

strlcpy() guarantees the dest buffer is NULL teminated.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 block/elevator.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 0451892..9482ffa 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -1166,15 +1166,10 @@ ssize_t elv_iosched_store(struct request_queue *q, const char *name,
 			  size_t count)
 {
 	char elevator_name[ELV_NAME_MAX];
-	size_t len;
 	struct elevator_type *e;
 
-	elevator_name[sizeof(elevator_name) - 1] = '\0';
-	strncpy(elevator_name, name, sizeof(elevator_name) - 1);
-	len = strlen(elevator_name);
-
-	if (len && elevator_name[len - 1] == '\n')
-		elevator_name[len - 1] = '\0';
+	strlcpy(elevator_name, name, sizeof(elevator_name));
+	strstrip(elevator_name);
 
 	e = elevator_get(elevator_name);
 	if (!e) {
-- 
1.5.4.rc3

