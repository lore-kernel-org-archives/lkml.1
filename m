Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbXHAXXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbXHAXXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 19:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbXHAXXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 19:23:08 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:34033 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbXHAXXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 19:23:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=awLGgYTiV3+idz2wvJ+BXqUwZuPM3NWdnA3rWDaFGjw6O6UQaOsxYUkbsYYI15W8SSgFfszm3ZJ9FX88YjZS4aX2gmtK/ZJqUvyVqYtwmNtfvw+IWzry+w9YYbDw6/fYAmiUKX9w936N+0AAEGazGf2PrMZjk9lMln1Erlqpx/U=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] scripts/ver_linux : correct printing of binutils version
Date: Thu, 2 Aug 2007 01:21:15 +0200
User-Agent: KMail/1.9.7
Cc: lkml@ravnborg.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708020121.15883.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently scripts/ver_linux prints "Binutils" or other random 
information for the version number in the "binutils" output line 
on some distributions. This patch corrects that.

When I initially submitted a patch to correct that, I was not aware 
that the output from "ld -v" could differ as much as it turned out 
it can, so my original fix turned out to not cover all bases.
This patch works correctly with all the different "ld -v" output 
that people posted in replys to my first patch, so it should be a 
clear win over what we have currently.

Please apply.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 scripts/ver_linux |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/scripts/ver_linux b/scripts/ver_linux
index 8f8df93..27a5a21 100755
--- a/scripts/ver_linux
+++ b/scripts/ver_linux
@@ -21,9 +21,7 @@ gcc --version 2>&1| grep gcc | awk \
 make --version 2>&1 | awk -F, '{print $1}' | awk \
       '/GNU Make/{print "Gnu make              ",$NF}'
 
-ld -v | awk -F\) '{print $1}' | awk \
-'/BFD/{print "binutils              ",$NF} \
-/^GNU/{print "binutils              ",$4}'
+echo "binutils               $(ld -v | egrep -o '[0-9]+\.[0-9\.]+')"
 
 echo -n "util-linux             "
 fdformat --version | awk '{print $NF}' | sed -e s/^util-linux-// -e s/\)$//




