Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab0CCWtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 17:49:23 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:65086 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab0CCWtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 17:49:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=J4XDwZBoDljZNBj2ekCzmCKQdZ8yi8D9/i0HuNxEV0nLQ17qLaZsiYV/WHpQWcFRUQ
         TmfYh5pfGcrrnQdHpbZ+6rSGRdnD6Dv31xjASD7xgOL1RayPajEdB5fj0CM5sVF0d1nI
         XgbY84MbGy2vsE9n1m1VyOdexAR8oiRcnB6bk=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>,
       rt-users <linux-rt-users@vger.kernel.org>
Cc: Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>,
       Xavier Miller <xavier.miller@cauwe.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Clark Williams <williams@redhat.com>, Carsten Emde <ce@ceag.ch>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH] =?UTF-8?q?mm/highmem.c:=20Fix=20=E2=80=98pkmap=5Fcount=E2=80=99=20undeclared?=
Date: Wed,  3 Mar 2010 23:49:06 +0100
Message-Id: <1267656546-19173-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following problem that occurs when CONFIG_DEBUG_VM=y

mm/highmem.c:534: error: ‘pkmap_count’ undeclared (first use in this function)

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 mm/highmem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/highmem.c b/mm/highmem.c
index 1b534a8..887a487 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -531,7 +531,7 @@ static int __set_page_address(struct page *page, void *virtual, int pos)
 	struct page_address_map *pam;
 
 	VM_BUG_ON(!PageHighMem(page));
-	VM_BUG_ON(atomic_read(&pkmap_count[pos]) != 0);
+	VM_BUG_ON(atomic_read(&pkmap[pos].count) != 0);
 	VM_BUG_ON(pos < 0 || pos >= LAST_PKMAP);
 
 	pas = page_slot(page);
-- 
1.6.5.7

