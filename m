Return-Path: <linux-kernel-owner+w=401wt.eu-S1765500AbZDHNyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765500AbZDHNyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760111AbZDHNyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:54:21 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:42199 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753349AbZDHNyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:54:20 -0400
X-Sasl-enc: KtHdJiESmPBOgrJWhLhXsOgtOv5tQDXGUhoI4TCYQHRO 1239198859
Message-ID: <49DCAC88.7010500@fastmail.fm>
Date: Wed, 08 Apr 2009 14:54:16 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: Bert Wesarg <bert.wesarg@googlemail.com>
CC: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 20/56] inflate: Remove void casts
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm> <36ca99e90904080439u7098d2feka5dd39f8ab6a470c@mail.gmail.com>
In-Reply-To: <36ca99e90904080439u7098d2feka5dd39f8ab6a470c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heres the fixed patch

Thanks,

Jack

--

inflate: Remove void casts

From: Jack Stone <jwjstone@fastmail.fm>

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---

 lib/inflate.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/lib/inflate.c b/lib/inflate.c
index 1a8e8a9..1eb0cd8 100644
--- a/lib/inflate.c
+++ b/lib/inflate.c
@@ -249,7 +249,7 @@ static void *malloc(int size)
 
        malloc_ptr = (malloc_ptr + 3) & ~3;     /* Align */
 
-       p = (void *)malloc_ptr;
+       p = malloc_ptr;
        malloc_ptr += size;
 
        if (free_mem_end_ptr && malloc_ptr >= free_mem_end_ptr)
@@ -481,8 +481,7 @@ DEBG1("3 ");
         z = 1 << j;             /* table entries for j-bit table */
 
         /* allocate and link in new table */
-        if ((q = (struct huft *)malloc((z + 1)*sizeof(struct huft))) ==
-            (struct huft *)NULL)
+        if ((q = malloc((z + 1)*sizeof(struct huft))) == NULL)
         {
           if (h)
             huft_free(u[0]);
