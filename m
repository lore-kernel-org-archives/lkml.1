Return-Path: <linux-kernel-owner+w=401wt.eu-S1757703AbXGHXsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703AbXGHXsg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 19:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbXGHXs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 19:48:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:57472 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbXGHXs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 19:48:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Bmiw16Citski+469tJDp1mCpYgrXunN7EIWSfcohvPk1/fCyStI/UBJACL2qJSn/VTpSks+gA2mou4aCu5Jizu908sTGPX2NglDvl0YRlTkHDjj9Vv6bAyH+EKf+MnB8So8tmMXax8NcT7emBE/Azs2zTkSqAGt9TXI2xZXSz10=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] fixup binutils printing from scripts/ver_linux
Date: Mon, 9 Jul 2007 01:47:58 +0200
User-Agent: KMail/1.9.7
Cc: Jesper Juhl <jesper.juhl@gmail.com>, sam@ravenborg.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707090147.58611.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I just found that scripts/ver_linux does not print the binutils version 
properly on my Slackware 12.0 system. 
The following patch fixes things up.

Pre this patch:
juhl@dragon:~/kernel/linux-2.6$ scripts/ver_linux
...
binutils               Binutils
...

Post this patch:
juhl@dragon:~/kernel/linux-2.6$ scripts/ver_linux
...
binutils               2.17.50.0.17.20070615
...


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 scripts/ver_linux |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/scripts/ver_linux b/scripts/ver_linux
index 72876df..2f96a1b 100755
--- a/scripts/ver_linux
+++ b/scripts/ver_linux
@@ -21,9 +21,8 @@ gcc --version 2>&1| grep gcc | awk \
 make --version 2>&1 | awk -F, '{print $1}' | awk \
       '/GNU Make/{print "Gnu make              ",$NF}'
 
-ld -v | awk -F\) '{print $1}' | awk \
-'/BFD/{print "binutils              ",$NF} \
-/^GNU/{print "binutils              ",$4}'
+echo "binutils               $(ld -v | awk -F \) \
+{'print $2'} | tr -d ' ')"
 
 echo -n "util-linux             "
 fdformat --version | awk '{print $NF}' | sed -e s/^util-linux-// -e s/\)$//





-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html


