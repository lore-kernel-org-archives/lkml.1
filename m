Return-Path: <linux-kernel-owner+w=401wt.eu-S933264AbXEGLoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933264AbXEGLoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 07:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933285AbXEGLoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 07:44:30 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:35999 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933264AbXEGLo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 07:44:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=SCq4QJqmKgCirK5dggsvJbf9LkrJwUMYv6dglR9SsX8EB+PJ0/LhkL9JEkTrtTwFyw+Hx/q7V/EKnxE/r+3ouB1wbbE0qdTappfSh5egktIWBEjyF45eRJbbCj+oNY3l8KCfM9V2ycdba2qv+y+qJy97TH2zEbmuSwX1lLI8TCk=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fix up printing of Linux C Library version in scripts/ver_linux
Date: Mon, 7 May 2007 13:44:05 +0200
User-Agent: KMail/1.9.6
Cc: Sam Ravnborg <sam@ravnborg.org>, jesper.juhl@gmail.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705071344.06068.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I just noticed, when running scripts/ver_linux on a Gentoo system, that the
line printing the C library version looked a little odd. So I fixed it up
to be in line with all the rest.

Old output:
Linux C Library        > libc.2.5
New output:
Linux C Library        2.5


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

scripts/ver_linux |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/ver_linux b/scripts/ver_linux
index 72876df..8f8df93 100755
--- a/scripts/ver_linux
+++ b/scripts/ver_linux
@@ -66,8 +66,8 @@ showmount --version 2>&1 | grep nfs-utils | awk \
 'NR==1{print "nfs-utils             ", $NF}'
 
 ls -l `ldd /bin/sh | awk '/libc/{print $3}'` | sed \
--e 's/\.so$//' | awk -F'[.-]'   '{print "Linux C Library        " \
-$(NF-2)"."$(NF-1)"."$NF}'
+-e 's/\.so$//' | sed -e 's/>//' | \
+awk -F'[.-]' '{print "Linux C Library        "$(NF-1)"."$NF}'
 
 ldd -v > /dev/null 2>&1 && ldd -v || ldd --version |head -n 1 | awk \
 'NR==1{print "Dynamic linker (ldd)  ", $NF}'


