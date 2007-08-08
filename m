Return-Path: <linux-kernel-owner+w=401wt.eu-S938167AbXHHUSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938167AbXHHUSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 16:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934989AbXHHUSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 16:18:17 -0400
Received: from smtpauth05.prod.mesa1.secureserver.net ([64.202.165.99]:33806
	"HELO smtpauth05.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760941AbXHHUSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 16:18:16 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Aug 2007 16:18:16 EDT
From: "Subbaiah Venkata" <kvsnaidu@sapnaidu.net>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] lib/sort.c, 2.6.22 kernel
Date: Wed, 8 Aug 2007 16:19:55 -0700
Message-ID: <000201c7da12$a1aec340$0a02a8c0@NetWin>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcfaEqEXzK7oWHGQSXSltrJUrjbsug==
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello, I fixed and tested a small bug in lib/sort.c file, heap sort
function.

The fix avoids unnecessary swap of contents when i is 0 (saves few loads and
stores),
which happens every time sort function is called. I felt the fix is worth
bringing it 
to your attention given the importance and frequent use of the sort
function.

Thank you all.

==================================================================
diff --git a/lib/sort.c b/lib/sort.c
index 9615678..6abbaf3 100644
--- a/lib/sort.c
+++ b/lib/sort.c
@@ -67,7 +67,7 @@ void sort(void *base, size_t num, size_t size,
        }

        /* sort */
-       for (i = n - size; i >= 0; i -= size) {
+       for (i = n - size; i > 0; i -= size) {
                swap(base, base + i, size);
                for (r = 0; r * 2 + size < i; r = c) {
                        c = r * 2 + size;

