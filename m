Return-Path: <linux-kernel-owner+w=401wt.eu-S932603AbZAIXje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603AbZAIXje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760392AbZAIXiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:38:54 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:52863 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889AbZAIXiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:38:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:to:from:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=dycv5fr5/tHXF8+lzxje7IFUv1meqP9oonaLQdqlE8RkaJO0uG5KF/KdobDpmjWKd9
         utO9VAoImIL36xqVL/KsBelEB29266w7NqsELjgWuJsJ4OYEe+bsey/I7EQkizRxJkw0
         VoANL8YFIoRyA94iFzp0kp7aF+E+DklYk3/r4=
Subject: [PATCH 1/5] Fix dubious bitwise 'or' usage spotted by sparse.
To: LKML <linux-kernel@vger.kernel.org>
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Trivial Kernel Patches <trivial@kernel.org>
Date: Sat, 10 Jan 2009 02:47:57 +0300
Message-ID: <20090109234757.11800.1259.stgit@zaytsev.su>
In-Reply-To: <20090109234113.11800.55672.stgit@zaytsev.su>
References: <20090109234113.11800.55672.stgit@zaytsev.su>
User-Agent: StGit/0.14.3.292.gb975
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't change the semantics, but it looks like
the logical 'or' was meant to be used here.

Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
---
 mm/page_alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d8ac014..6923237 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -306,7 +306,7 @@ static void destroy_compound_page(struct page *page, unsigned long order)
 	for (i = 1; i < nr_pages; i++) {
 		struct page *p = page + i;
 
-		if (unlikely(!PageTail(p) |
+		if (unlikely(!PageTail(p) ||
 				(p->first_page != page)))
 			bad_page(page);
 		__ClearPageTail(p);

