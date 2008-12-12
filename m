Return-Path: <linux-kernel-owner+w=401wt.eu-S1758392AbYLLOCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392AbYLLOCN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 09:02:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758752AbYLLOBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 09:01:50 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51586 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758712AbYLLOBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 09:01:49 -0500
From: Gerd Hoffmann <kraxel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH] Add missing accounting calls to compat_sys_{readv,writev}.
Date: Fri, 12 Dec 2008 15:01:42 +0100
Message-Id: <1229090502-32161-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$subject says all.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 fs/compat.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 3a25cf3..e28014a 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1187,6 +1187,9 @@ compat_sys_readv(unsigned long fd, const struct compat_iovec __user *vec, unsign
 	ret = compat_do_readv_writev(READ, file, vec, vlen, &file->f_pos);
 
 out:
+	if (ret > 0)
+		add_rchar(current, ret);
+	inc_syscr(current);
 	fput(file);
 	return ret;
 }
@@ -1210,6 +1213,9 @@ compat_sys_writev(unsigned long fd, const struct compat_iovec __user *vec, unsig
 	ret = compat_do_readv_writev(WRITE, file, vec, vlen, &file->f_pos);
 
 out:
+	if (ret > 0)
+		add_wchar(current, ret);
+	inc_syscw(current);
 	fput(file);
 	return ret;
 }
-- 
1.5.6.5

