Return-Path: <linux-kernel-owner+w=401wt.eu-S1752527AbXB0ULG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbXB0ULG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 15:11:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbXB0ULG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 15:11:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbXB0ULD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 15:11:03 -0500
Message-Id: <200702272010.l1RKAqRi017358@mentos.hsv.redhat.com>
From: Guy Streeter <streeter@redhat.com>
Date: Tue, 27 Feb 2007 13:35:31 -0600
Subject: [PATCH] Cap shmmax at INT_MAX in compat shminfo
To: streeter@redhat.com, linux-kernel@vger.kernel.org, torvalds@osdl.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The value of shmmax may be larger than will fit in the struct used by
the 32bit compat version of sys_shmctl. This change mirrors what the
normal sys_shmctl does when called with the old IPC_INFO command.

Signed-off-by: Guy Streeter <streeter@redhat.com>
---
 ipc/compat.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/ipc/compat.c b/ipc/compat.c
index fa18141..8b44aa9 100644
--- a/ipc/compat.c
+++ b/ipc/compat.c
@@ -542,6 +542,8 @@ static inline int put_compat_shminfo64(struct shminfo64 *smi,
 
 	if (!access_ok(VERIFY_WRITE, up64, sizeof(*up64)))
 		return -EFAULT;
+	if (smi->shmmax > INT_MAX)
+		smi->shmmax = INT_MAX;
 	err  = __put_user(smi->shmmax, &up64->shmmax);
 	err |= __put_user(smi->shmmin, &up64->shmmin);
 	err |= __put_user(smi->shmmni, &up64->shmmni);
@@ -557,6 +559,8 @@ static inline int put_compat_shminfo(struct shminfo64 *smi,
 
 	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)))
 		return -EFAULT;
+	if (smi->shmmax > INT_MAX)
+		smi->shmmax = INT_MAX;
 	err  = __put_user(smi->shmmax, &up->shmmax);
 	err |= __put_user(smi->shmmin, &up->shmmin);
 	err |= __put_user(smi->shmmni, &up->shmmni);
-- 
1.4.4.2

