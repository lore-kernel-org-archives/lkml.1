Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbXFXVkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbXFXVkT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 17:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbXFXVkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 17:40:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:24466 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbXFXVkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 17:40:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ROdSu8Ucd1D7Q2Ox2NnPrNc8a8CGRVI2Ea7n4Fb5nYEQzVDyqTqSxfCvy5xQxIDw2m1dlvCrYzhew+uBPCIcIiFcggdI+vQXvBh0zILKuccPD3/gGsGky91thzkd2jgvifGcIZ/i2VXd/+5YoacZ05iCKIV5EbzjHN4wZFboep4=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Richard Henderson <rth@tamu.edu>
Subject: [PATCH] Avoid potential NULL deref in scripts/genksyms/lex.l
Date: Sun, 24 Jun 2007 23:40:03 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706242340.03871.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

strchr() returns NULL in case the string is not found and if that 
happens we risk dereferencing a NULL pointer. It never hurts to 
check for that condition and exit normally with an error rather 
than crashing.

(no, the indentation is not according to CodingStyle, it's simply 
 following whatever else is in that file)


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 scripts/genksyms/lex.l        |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/scripts/genksyms/lex.l b/scripts/genksyms/lex.l
index 5e544a0..28edc0c 100644
--- a/scripts/genksyms/lex.l
+++ b/scripts/genksyms/lex.l
@@ -154,6 +154,8 @@ repeat:
 
       file = strchr(yytext, '\"')+1;
       e = strchr(file, '\"');
+      if (!file || !e)
+	exit(1);
       *e = '\0';
       cur_filename = memcpy(xmalloc(e-file+1), file, e-file+1);
       cur_line = atoi(yytext+2);
