Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751275AbYLSP7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275AbYLSP7S (ORCPT <rfc822;akpm@linux-foundation.org>);
	Fri, 19 Dec 2008 10:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbYLSP6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 10:58:38 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36391 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbYLSP6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 10:58:35 -0500
From: y@redhat.com
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-api@vger.kernel.org
Cc: aarcange@redhat.com, Gerd Hoffmann <kraxel@redhat.com>
Subject: [Patch v5 1/6] Add missing accounting calls to compat_sys_{readv,writev}.
Date: Fri, 19 Dec 2008 16:58:20 +0100
Message-Id: <1229702305-23027-2-git-send-email-y>
In-Reply-To: <1229702305-23027-1-git-send-email-y>
References: <1229702305-23027-1-git-send-email-y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerd Hoffmann <kraxel@redhat.com>

[ Note: unrelated bugfix spotted during preadv review,
  included for completeness, akpm picked it into -mm already. ]

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

