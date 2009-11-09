Return-Path: <linux-kernel-owner+w=401wt.eu-S1756428AbZKJO2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbZKJO2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 09:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756379AbZKJO2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 09:28:33 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:35975 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756373AbZKJO2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 09:28:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=arSsd5EUZMjAGbC4qQME0ivI5SxTGmy7OSdKLrUeZbTrqF1IW1rLtAHnGlyxb8f55U
         kKyN2NMptGQyB3ZN2KvYLCIcJGzTmObT7+fHWdkwEvaoXPXBTXpPjCS5R5WmoKHY3fkx
         qa2ux2ywD1Yagfvcvsi6DrJ9TwfS0foVA+jWE=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: tabbott@ksplice.com, alan-jenkins@tuffmail.co.uk, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH 1/2] bsearch: avoid unneeded decrement arithmetic
Date: Mon,  9 Nov 2009 12:26:45 -0200
Message-Id: <bc287f9f2e75ef5e82f93b4cd5c4ab0eff0bc920.1257776095.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.6.5.2.153.g6e31f.dirty
In-Reply-To: <cover.1257776095.git.andre.goddard@gmail.com>
References: <cover.1257776095.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
---
 lib/bsearch.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/bsearch.c b/lib/bsearch.c
index 2e70664..f71ac89 100644
--- a/lib/bsearch.c
+++ b/lib/bsearch.c
@@ -33,9 +33,9 @@
 void *bsearch(const void *key, const void *base, size_t num, size_t size,
 	      int (*cmp)(const void *key, const void *elt))
 {
-	int start = 0, end = num - 1, mid, result;
+	int start = 0, end = num, mid, result;
 
-	while (start <= end) {
+	while (start < end) {
 		mid = (start + end) / 2;
 		result = cmp(key, base + mid * size);
 		if (result < 0)
-- 
1.6.5.2.153.g6e31f.dirty

