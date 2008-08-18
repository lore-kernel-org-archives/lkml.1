Return-Path: <linux-kernel-owner+w=401wt.eu-S1759206AbYHRSwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206AbYHRSwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760021AbYHRSwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:52:03 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:33826 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757075AbYHRSwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:52:02 -0400
Date: Mon, 18 Aug 2008 20:51:38 +0200
From: Vegard Nossum <vegardno@ifi.uio.no>
To: David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] security: fix build breakage
Message-ID: <20080818185138.GA15961@ben.ifi.uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0808181143n6df11e16j90413c0ccae80176@mail.gmail.com>
User-Agent: Mutt/1.5.10i
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: C0495188FE187EC97304FC5D502AEE6798035A5D
X-UiO-SPAM-Test: remote_host: 129.240.64.202 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 3 total 2357 max/h 24 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case it wasn't fixed already, here it is.. :-)

>From 122c9e0c51d43675a1d02b8a82d7eae8e87f9042 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegardno@ben.ifi.uio.no>
Date: Mon, 18 Aug 2008 20:47:03 +0200
Subject: [PATCH] security: fix build breakage

Introduced by:

commit 5cd9c58fbe9ec92b45b27e131719af4f2bd9eb40
Author: David Howells <dhowells@redhat.com>
Date:   Thu Aug 14 11:37:28 2008 +0100

   security: Fix setting of PF_SUPERPRIV by __capable()

Should this commit be re-tested also with LTP with CONFIG_SECURITY=n?

Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Vegard Nossum <vegardno@ben.ifi.uio.no>
---
 include/linux/security.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 2ee5ecf..80c4d00 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1755,7 +1755,7 @@ static inline int security_ptrace_may_access(struct task_struct *child,
 	return cap_ptrace_may_access(child, mode);
 }
 
-static inline int security_ptrace_traceme(struct task_struct *child)
+static inline int security_ptrace_traceme(struct task_struct *parent)
 {
 	return cap_ptrace_traceme(parent);
 }
-- 
1.5.6.4

