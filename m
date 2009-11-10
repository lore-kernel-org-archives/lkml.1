Return-Path: <linux-kernel-owner+w=401wt.eu-S1757496AbZKKPCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbZKKPCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 10:02:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757434AbZKKPCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 10:02:07 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:59510 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757377AbZKKPCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 10:02:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=kmex1ctSJk0Hw1UGS2IeCCnLTrRQAHMRgdgpGuWMD+E6PV7ND0oIdZa2jPM19R0GS9
         TR7wPLkvcZts2KsFMCdqDKGvsnZPwPj0rNQ2DA+YG5H9vLV2IzoY8v473POHnc8hKf4E
         9vydCJZf9raDuq/ELxbNYAWVA2roT7sglgB0M=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: tabbott@ksplice.com, alan-jenkins@tuffmail.co.uk, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH v4 1/2] bsearch: avoid unneeded decrement arithmetic
Date: Tue, 10 Nov 2009 13:00:24 -0200
Message-Id: <28b3abe6d9a03d4251c0b42a3505c8bc5f861e69.1257864802.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.6.5.2.153.g6e31f.dirty
In-Reply-To: <cover.1257864802.git.andre.goddard@gmail.com>
References: <cover.1257864802.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
---
 lib/bsearch.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/bsearch.c b/lib/bsearch.c
index 2e70664..33cbba6 100644
--- a/lib/bsearch.c
+++ b/lib/bsearch.c
@@ -33,13 +33,13 @@
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
-			end = mid - 1;
+			end = mid;
 		else if (result > 0)
 			start = mid + 1;
 		else
-- 
1.6.5.2.153.g6e31f.dirty

