Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbYEDPNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbYEDPNU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 11:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbYEDPNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 11:13:06 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:40944 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbYEDPNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 11:13:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version:content-type:content-transfer-encoding:sender;
        b=dwF5fY+jehIQt39SiUQlm4IiCgkJmZqnT8yDwJvz0khXmc1XGLge87ubpu3VPHrGD8DxwNZXfXMix+CsHcx2fBqGKwWAakxypuNWSGL2KeKlmK58DH7KgILc1ddG2t7oGj78ONpqAui7U2VTV2WPuYwdITSlbPvvwn0xK9/9rnU=
From: Bryan Wu <cooloney@kernel.org>
To: viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] [vfs/proc] task_nommu: fix compile failing bug because of spilt file.h
Date: Sun,  4 May 2008 23:12:55 +0800
Message-Id: <1209913975-19242-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  CC      fs/proc/task_nommu.o
fs/proc/task_nommu.c: In function ‘task_mem’:
fs/proc/task_nommu.c:55: error: dereferencing pointer to incomplete type
make[2]: *** [fs/proc/task_nommu.o] Error 1
make[1]: *** [fs/proc] Error 2
make: *** [fs] Error 2

Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 fs/proc/task_nommu.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 6cba820..987bc69 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -1,6 +1,7 @@
 
 #include <linux/mm.h>
 #include <linux/file.h>
+#include <linux/fdtable.h>
 #include <linux/mount.h>
 #include <linux/ptrace.h>
 #include <linux/seq_file.h>
-- 
1.5.5

