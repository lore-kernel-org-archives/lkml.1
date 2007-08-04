Return-Path: <linux-kernel-owner+w=401wt.eu-S932947AbXHDSdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932947AbXHDSdr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 14:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765570AbXHDScj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 14:32:39 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:44971 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765326AbXHDSch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 14:32:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=g50z9Y1BsNZ5fhtSYXabT5g1QrM8f1m3Su8UErkkbZNG62ICtTO0inzN3GOw2Uz3/ov7qLd3cSyh4HRS1qUAI2GIXHyxtMM78Ii6RpWPK1sAseCJYq/QCwmfLfgfKOtlobdBzcxwsb21yOJ/pR3FePS5YEIlPTe9qFLA8N840jc=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH][RESEND] improve scripts/gcc-version.sh output a bit when called without args
Date: Sat, 4 Aug 2007 20:30:42 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, jesper.juhl@gmail.com
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200708042030.42402.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Resend of patch from 7 May 2007 17:18:00)


Currently, if you call scripts/gcc-version.sh without arguments it will 
generate this output : 

$ sh scripts/gcc-version.sh
scripts/gcc-version.sh: line 12: [: =: unary operator expected
scripts/gcc-version.sh: line 16: -E: command not found
scripts/gcc-version.sh: line 17: -E: command not found
0000

Not too pretty. I believe this is an improvement : 

$ sh scripts/gcc-version.sh
Error: No compiler specified.
Usage:
        scripts/gcc-version.sh <gcc-command>


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 scripts/gcc-version.sh |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/scripts/gcc-version.sh b/scripts/gcc-version.sh
index 8a1d187..a5121a6 100644
--- a/scripts/gcc-version.sh
+++ b/scripts/gcc-version.sh
@@ -9,10 +9,16 @@
 # gcc-2.95.3, `030301' for gcc-3.3.1, etc.
 #
 
-if [ $1 = "-p" ] ; then with_patchlevel=1; shift; fi
+if [[ $1 = "-p" ]] ; then with_patchlevel=1; shift; fi
 
 compiler="$*"
 
+if [ ${#compiler} -eq 0 ]; then
+	echo "Error: No compiler specified."
+	echo -e "Usage:\n\t$0 <gcc-command>"
+	exit 1
+fi
+
 MAJOR=$(echo __GNUC__ | $compiler -E -xc - | tail -n 1)
 MINOR=$(echo __GNUC_MINOR__ | $compiler -E -xc - | tail -n 1)
 if [ "x$with_patchlevel" != "x" ] ; then



