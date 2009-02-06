Return-Path: <linux-kernel-owner+w=401wt.eu-S1752461AbZBFJHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbZBFJHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 04:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZBFJHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 04:07:11 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:58426 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbZBFJHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 04:07:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QPa/pxNz5yOFqG235HlYzjRoA9QffQouFgFE0eyPCIqJiH+eIt+arXLsIWLZKGf4qd
         xtK59/Rhh9/UANdYJ1oUE45Mb+xRgNtEfrf8DBeSRgc+a8Kj1J4N5AMgzh5bQ49T8Q7n
         dsnW4c7fk1yznk3RWW/UgDEHTaDnCED3pNLs8=
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: linux-kernel@vger.kernel.org, Bert Wesarg <bert.wesarg@googlemail.com>
Subject: [PATCH urcu] Use pthread_equal() for pthread_t's equality test
Date: Fri,  6 Feb 2009 10:07:00 +0100
Message-Id: <1233911220-27912-1-git-send-email-bert.wesarg@googlemail.com>
X-Mailer: git-send-email 1.6.1.rc4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bert Wesarg <bert.wesarg@googlemail.com>
---
 urcu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/urcu.c b/urcu.c
index d0d6138..e401d8d 100644
--- a/urcu.c
+++ b/urcu.c
@@ -185,7 +185,7 @@ void urcu_remove_reader(pthread_t id)
 
 	assert(reader_data != NULL);
 	for (index = reader_data; index < reader_data + num_readers; index++) {
-		if (index->tid == id) {
+		if (pthread_equal(index->tid, id)) {
 			memcpy(index, &reader_data[num_readers - 1],
 				sizeof(struct reader_data));
 			reader_data[num_readers - 1].tid = 0;
-- 
1.6.1.rc4

