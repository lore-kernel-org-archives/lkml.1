Return-Path: <linux-kernel-owner+w=401wt.eu-S1765110AbZFLQZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765110AbZFLQZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763749AbZFLQY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:24:56 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39059 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758932AbZFLQYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:24:55 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 02/27] Blackfin: export ip_compute_csum/csum_partial_copy_from_user symbols
Date: Fri, 12 Jun 2009 12:24:20 -0400
Message-Id: <1244823885-22410-3-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
References: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All other arches do this, and some places like the net/scsi code will fail
as modules without them.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/lib/checksum.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/lib/checksum.c b/arch/blackfin/lib/checksum.c
index 762a7f0..cd605e7 100644
--- a/arch/blackfin/lib/checksum.c
+++ b/arch/blackfin/lib/checksum.c
@@ -116,6 +116,7 @@ __sum16 ip_compute_csum(const void *buff, int len)
 {
 	return (__force __sum16)~do_csum(buff, len);
 }
+EXPORT_SYMBOL(ip_compute_csum);
 
 /*
  * copy from fs while checksumming, otherwise like csum_partial
@@ -130,6 +131,7 @@ csum_partial_copy_from_user(const void __user *src, void *dst,
 	memcpy(dst, (__force void *)src, len);
 	return csum_partial(dst, len, sum);
 }
+EXPORT_SYMBOL(csum_partial_copy_from_user);
 
 /*
  * copy from ds while checksumming, otherwise like csum_partial
-- 
1.6.3.1

