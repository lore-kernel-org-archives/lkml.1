Return-Path: <linux-kernel-owner+w=401wt.eu-S1760593AbXLLUKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760593AbXLLUKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 15:10:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759483AbXLLUJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 15:09:47 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:21700 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884AbXLLUJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 15:09:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PlFT/I5mTtk4nlJqxc3OC6eXHpB8rxbuNc7RLgHEUJF/kwzeAOF/URRBqpzpgKnohDoZXU0jFH/XbbHI0KLdKMC1U/YaCD7ZI/+PFxpgpKHqdBDlb7Kf15lU8PwVzCWpykFMR4HInBRYkDtUNh+fXwXoPsz5oqyJZ56qQN6YHtc=
Subject: [PATCH] Remove last users of empty FASTCALL macro
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 12:09:45 -0800
Message-Id: <1197490185.21291.11.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FASTCALL is always empty after the x86 removal.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/aio.c                  |    2 +-
 include/asm-m32r/signal.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 9dec7d2..8a37dbb 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -397,7 +397,7 @@ void fastcall __put_ioctx(struct kioctx *ctx)
  * This prevents races between the aio code path referencing the
  * req (after submitting it) and aio_complete() freeing the req.
  */
-static struct kiocb *FASTCALL(__aio_get_req(struct kioctx *ctx));
+static struct kiocb *__aio_get_req(struct kioctx *ctx);
 static struct kiocb fastcall *__aio_get_req(struct kioctx *ctx)
 {
 	struct kiocb *req = NULL;
diff --git a/include/asm-m32r/signal.h b/include/asm-m32r/signal.h
index 9372586..1a60706 100644
--- a/include/asm-m32r/signal.h
+++ b/include/asm-m32r/signal.h
@@ -157,7 +157,7 @@ typedef struct sigaltstack {
 #undef __HAVE_ARCH_SIG_BITOPS
 
 struct pt_regs;
-extern int FASTCALL(do_signal(struct pt_regs *regs, sigset_t *oldset));
+extern int do_signal(struct pt_regs *regs, sigset_t *oldset);
 
 #define ptrace_signal_deliver(regs, cookie)	do { } while (0)
 
-- 
1.5.3.7.2212.gd092



