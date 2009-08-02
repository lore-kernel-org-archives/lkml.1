Return-Path: <linux-kernel-owner+w=401wt.eu-S1752647AbZHBLkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbZHBLkD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 07:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbZHBLkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 07:40:03 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:59866 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbZHBLkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 07:40:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=mtBtvXvlrrehUdKHXG/hS2NdVez7HHBK2kwCeB+kLVTnhX6LV4cT0z6n3iAYgwTll2
         Dynxi/1iMMxXh2Q8Dba2pLdLBnxlthpOF9hMJ5c+WhDdsoS15QsjgugCoAOFdYgxLazm
         MOJor2UrKSZI7fN+7qydH+mHhQ0DULI9xgaR0=
Message-ID: <4A757BCF.40101@gmail.com>
Date: Sun, 02 Aug 2009 13:43:11 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: a.p.zijlstra@chello.nl, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf: Read buffer overflow
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check whether index is within bounds before testing the element.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index b20a4b6..edecdbe 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -252,7 +252,7 @@ static int strcommon(const char *pathname)
 {
 	int n = 0;
 
-	while (pathname[n] == cwd[n] && n < cwdlen)
+	while (n < cwdlen && pathname[n] == cwd[n])
 		++n;
 
 	return n;
diff --git a/tools/perf/util/quote.c b/tools/perf/util/quote.c
index c6e5dc0..2726fe4 100644
--- a/tools/perf/util/quote.c
+++ b/tools/perf/util/quote.c
@@ -318,7 +318,7 @@ char *quote_path_relative(const char *in, int len,
 		strbuf_addch(out, '"');
 	if (prefix) {
 		int off = 0;
-		while (prefix[off] && off < len && prefix[off] == in[off])
+		while (off < len && prefix[off] && prefix[off] == in[off])
 			if (prefix[off] == '/') {
 				prefix += off + 1;
 				in += off + 1;
