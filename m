Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbZCPJiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbZCPJiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 05:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbZCPJhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 05:37:54 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:40272 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbZCPJhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 05:37:53 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 1/1] kmod: use explicit names for waiting
Date: Mon, 16 Mar 2009 10:36:14 +0100
Message-Id: <1237196174-5960-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As call_usermodehelper accepts enum umh_wait as a wait parameter,
use constants from this enum instead of bool in __request_module.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/kmod.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index b2a53d0..b750675 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -109,7 +109,8 @@ int __request_module(bool wait, const char *fmt, ...)
 		return -ENOMEM;
 	}
 
-	ret = call_usermodehelper(modprobe_path, argv, envp, wait);
+	ret = call_usermodehelper(modprobe_path, argv, envp,
+			wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC);
 	atomic_dec(&kmod_concurrent);
 	return ret;
 }
-- 
1.6.2

