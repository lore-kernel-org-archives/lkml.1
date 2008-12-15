Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbYLOLip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbYLOLip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 06:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbYLOLic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 06:38:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35811 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbYLOLib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 06:38:31 -0500
From: Gerd Hoffmann <kraxel@redhat.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-api@vger.kernel.org
Cc: Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v3 0/3] preadv & pwritev syscalls.
Date: Mon, 15 Dec 2008 12:36:14 +0100
Message-Id: <1229340977-24345-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

Next revision of the patch series, with the alignment issue fixed by
swapping the last two arguments as suggested by arch maintainers.

I've dropped the now-obsolete wrappers for mips.  Ralf, please
double-check.

thanks,
  Gerd

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 fs/compat.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index e5f49f5..aab2234 100644
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

