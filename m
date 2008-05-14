Return-Path: <linux-kernel-owner+w=401wt.eu-S1761650AbYENFIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761650AbYENFIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 01:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760735AbYENFHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 01:07:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42036
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760524AbYENFHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 01:07:02 -0400
Date: Tue, 13 May 2008 22:06:56 -0700 (PDT)
Message-Id: <20080513.220656.213078618.davem@davemloft.net>
To: mingo@elte.hu
CC: acme@redhat.com, srostedt@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2]: ftrace: Remove packed attribute on ftrace_page.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It causes unaligned access traps on platforms like sparc
(ftrace_page may be marked packed, but once we return
a dyn_ftrace sub-object from this array to another piece
of code, the "packed" part of the typing information doesn't
propagate).

But also, it didn't serve any purpose either.  Even if packed,
on 64-bit or 32-bit, it didn't give us any more dyn_ftrace
entries per-page.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 kernel/trace/ftrace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index afd617b..5588c63 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -177,9 +177,9 @@ static DEFINE_MUTEX(ftrace_filter_lock);
 
 struct ftrace_page {
 	struct ftrace_page	*next;
-	int			index;
+	unsigned long		index;
 	struct dyn_ftrace	records[];
-} __attribute__((packed));
+};
 
 #define ENTRIES_PER_PAGE \
   ((PAGE_SIZE - sizeof(struct ftrace_page)) / sizeof(struct dyn_ftrace))
-- 
1.5.5.rc0.16.g02b00

