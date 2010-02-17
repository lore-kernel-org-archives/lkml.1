Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab0BQTxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 14:53:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:51579 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456Ab0BQTw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 14:52:59 -0500
Date: Wed, 17 Feb 2010 19:52:12 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, sliakh.lkml@gmail.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, jiang@cs.ncsu.edu
Reply-To: mingo@redhat.com, hpa@zytor.com, sliakh.lkml@gmail.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, jiang@cs.ncsu.edu
In-Reply-To: <tip-7f5562635f80456c98d573cc45d10137dfcb1b8b@git.kernel.org>
References: <tip-7f5562635f80456c98d573cc45d10137dfcb1b8b@git.kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] module: fix () used as prototype in include/linux/module.h
Message-ID: <tip-45d5f58b53a055913fee4351cb3ce1133d3c5261@git.kernel.org>
Git-Commit-ID: 45d5f58b53a055913fee4351cb3ce1133d3c5261
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Feb 2010 19:52:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  45d5f58b53a055913fee4351cb3ce1133d3c5261
Gitweb:     http://git.kernel.org/tip/45d5f58b53a055913fee4351cb3ce1133d3c5261
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Mon, 1 Feb 2010 17:33:56 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 17 Feb 2010 10:11:24 -0800

module: fix () used as prototype in include/linux/module.h

Checkin 7f5562635f80456c98d573cc45d10137dfcb1b8b had () used as a
prototype, which means (void) in C++, but means (...) in C, which is
almost never correct, and therefore issues a warning.  Change it to
the properly intended (void).

Cc: Siarhei Liakh <sliakh.lkml@gmail.com>
Cc: Xuxian Jiang <jiang@cs.ncsu.edu>
LKML-Reference: <tip-7f5562635f80456c98d573cc45d10137dfcb1b8b@git.kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 include/linux/module.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index c6040ce..3232b31 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -668,11 +668,11 @@ static inline int module_get_iter_tracepoints(struct tracepoint_iter *iter)
 	return 0;
 }
 
-static inline void set_all_modules_text_rw()
+static inline void set_all_modules_text_rw(void)
 {
 }
 
-static inline void set_all_modules_text_ro()
+static inline void set_all_modules_text_ro(void)
 {
 }
 #endif /* CONFIG_MODULES */
