Return-Path: <linux-kernel-owner+w=401wt.eu-S1757405AbXGTWbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbXGTWbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754340AbXGTWbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:31:11 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:43824 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbXGTWbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:31:09 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org
Cc: Jesper Juhl <jesper.juhl@gmail.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 2/4] kbuild: fix up printing of Linux C Library version in scripts/ver_linux
Date: Sat, 21 Jul 2007 00:30:42 +0200
Message-Id: <11849706441152-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11849706443410-git-send-email-sam@ravnborg.org>
References: <20070720222039.GA25443@uranus.ravnborg.org> <11849706443410-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jesper.juhl@gmail.com>

I noticed, when running scripts/ver_linux on both a Gentoo system
and a Slackware system, that the line printing the C library
version looked a little odd. So I fixed it up to be in line with
all the rest.

  Old output:
    Linux C Library        > libc.2.5
  New output:
    Linux C Library        2.5

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
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
-- 
1.5.0.6

