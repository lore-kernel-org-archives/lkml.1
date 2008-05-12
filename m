Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbYELNxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbYELNxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 09:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750897AbYELNwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 09:52:55 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:22777 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbYELNws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 09:52:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=KEN977n7e4nr78rFvZEOR42M0p3mMnUlM1oEQNPY2QpAFyCNlAGo0uE49yIckcF/216+7PXFXROzEVK+//S3sRw53PFP7sZekdv75/fhbrdBLcZKWqbPZIXog3dB9rgioBQZoan23lTYRWqYMeY8QBpOwY2JygltKmPaXCbijlc=
Date: Mon, 12 May 2008 15:52:42 +0200
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] decodecode: use cross-compiler/toolchain if defined
Message-ID: <20080512135242.GA5014@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

Not sure if this is really in the kbuild domain, but I see you've taken
patches to this script before, so I'll make an attempt too :-)

Vegard


>From 75166add6121dbda4fad2e197d4fe6525dee580c Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Mon, 12 May 2008 15:36:38 +0200
Subject: [PATCH] decodecode: use cross-compiler/toolchain if defined

>From the Makefile: "CROSS_COMPILE specify [sic] the prefix used for all
executables used".

This is also very useful for decoding oopses on other archs than the
native one, so it seems natural to have it in the decodecode script as
well.

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Vegard Nossum <vegardno@ifi.uio.no>
---
 scripts/decodecode |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/scripts/decodecode b/scripts/decodecode
index 235d393..09b45a0 100644
--- a/scripts/decodecode
+++ b/scripts/decodecode
@@ -48,8 +48,8 @@ if [ $marker -ne 0 ]; then
 	beforemark=`echo "$code" | cut -c-$((${marker} - 1))`
 	echo -n "	.byte 0x" > $T.s
 	echo $beforemark | sed -e 's/ /,0x/g' >> $T.s
-	as $AFLAGS -o $T.o $T.s
-	objdump -S $T.o
+	${CROSS_COMPILE}as $AFLAGS -o $T.o $T.s
+	${CROSS_COMPILE}objdump -S $T.o
 	rm $T.o $T.s
 
 # and fix code at-and-after marker
@@ -59,6 +59,6 @@ fi
 code=`echo $code | sed -e 's/ [<(]/ /;s/[>)] / /;s/ /,0x/g'`
 echo -n "	.byte 0x" > $T.s
 echo $code >> $T.s
-as $AFLAGS -o $T.o $T.s
-objdump -S $T.o
+${CROSS_COMPILE}as $AFLAGS -o $T.o $T.s
+${CROSS_COMPILE}objdump -S $T.o
 rm $T $T.s $T.o
-- 
1.5.4.1

