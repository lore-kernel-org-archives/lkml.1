Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbZFVOZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbZFVOZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbZFVOZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:25:32 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:54303 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbZFVOZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:25:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=B0rf0TSYZZ5zkpeVzzQC+B+H7KQUEgqfeLFHzCDUKiKAlbIL4Tu7Gyub37xCY3pFEn
         VA8NvVNbHa+W874yXXUuKtdZTq6gyA5Yar2JW9TcBCvlGO5TuENdo8GOmmnhV9QL/him
         Si9HvwSFxG8Ug3+4OOS0QK9upWOQkEMocKo28=
Message-ID: <4A3FB09D.9050903@gmail.com>
Date: Mon, 22 Jun 2009 18:26:05 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: ingo <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] tools: fread does not return negative on error
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

size_t res cannot be less than 0. fread returns 0 on error.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Is this correct? please review.

diff --git a/tools/perf/util/strbuf.c b/tools/perf/util/strbuf.c
index eaba093..376a337 100644
--- a/tools/perf/util/strbuf.c
+++ b/tools/perf/util/strbuf.c
@@ -259,7 +259,7 @@ size_t strbuf_fread(struct strbuf *sb, size_t size, FILE *f)
 	res = fread(sb->buf + sb->len, 1, size, f);
 	if (res > 0)
 		strbuf_setlen(sb, sb->len + res);
-	else if (res < 0 && oldalloc == 0)
+	else if (res == 0 && oldalloc == 0)
 		strbuf_release(sb);
 	return res;
 }
