Return-Path: <linux-kernel-owner+w=401wt.eu-S1760603AbZAIXjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760603AbZAIXjt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:39:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932152AbZAIXjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:39:01 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:16262 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760443AbZAIXjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:39:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:to:from:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=i9Jk8Bdnmcm5wnlkZbySH/QWvmehzivnxbXripb/2Z6xg3scr2JJddb97AJlrL8NNo
         MFjfCX6E2C0M0tioy7vSotTbP5NAQCw42Oe97Vdgjq1El+06b5FYeIMfMF0/epPevoeA
         A/hkNrvAjE+0C1hr9hJqv6gydHGGgg6PTyFwA=
Subject: [PATCH 2/5] Fix dubious bitwise 'or' usage spotted by sparse.
To: LKML <linux-kernel@vger.kernel.org>
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Trivial Kernel Patches <trivial@kernel.org>
Date: Sat, 10 Jan 2009 02:48:05 +0300
Message-ID: <20090109234805.11800.57259.stgit@zaytsev.su>
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
 drivers/isdn/mISDN/l1oip_codec.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/mISDN/l1oip_codec.c b/drivers/isdn/mISDN/l1oip_codec.c
index a2dc457..43b3795 100644
--- a/drivers/isdn/mISDN/l1oip_codec.c
+++ b/drivers/isdn/mISDN/l1oip_codec.c
@@ -330,7 +330,7 @@ l1oip_4bit_alloc(int ulaw)
 	/* alloc conversion tables */
 	table_com = vmalloc(65536);
 	table_dec = vmalloc(512);
-	if (!table_com | !table_dec) {
+	if (!table_com || !table_dec) {
 		l1oip_4bit_free();
 		return -ENOMEM;
 	}

