Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbZGGPZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbZGGPZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756876AbZGGPZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:25:26 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:46519 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052AbZGGPZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:25:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=RSgUinK6l2w4yS/uPDpqxEMxpHYLMgioeP9eKRfqI2a5yAv8u87A1wlaouJ8C8v1jM
         ZxWXwDmxaQOa3Id6CcOZiBFA4jDtbC5uApEfTKycRP0d/8GSk67Bnafuc3SP8zftd42l
         +h3ogXD506zSI/SALk/5OT8q30BCdU7qDSBUg=
MIME-Version: 1.0
From: Joao Correia <joaomiguelcorreia@gmail.com>
Date: Tue, 7 Jul 2009 16:25:03 +0100
Message-ID: <a5d9929e0907070825j1dda6584t93196e2730dedc5c@mail.gmail.com>
Subject: [PATCH 1/3] Increase lockdep limits: MAX_STACK_TRACE_ENTRIES
To: LKML <linux-kernel@vger.kernel.org>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, a.p.zijlstra@chello.nl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Applies to current Linus tree, as of 2.6.31-rc2)

As it stands now, the limit is too low and is being hit by false
positives. Increasing its value will allow for more room to work with.

This was suggested by Ingo Molnar
(http://article.gmane.org/gmane.linux.kernel/852005) but never
submitted as a patch, to the best of my knowledge.


Signed-off-by: Joao Correia <joaomiguelcorreia@gmail.com>

---
 kernel/lockdep_internals.h | 2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index 699a2ac..93af1f1 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -65,7 +65,7 @@ enum {
  * Stack-trace: tightly packed array of stack backtrace
  * addresses. Protected by the hash_lock.
  */
-#define MAX_STACK_TRACE_ENTRIES	262144UL
+#define MAX_STACK_TRACE_ENTRIES	1048576UL

 extern struct list_head all_lock_classes;
 extern struct lock_chain lock_chains[];
---
