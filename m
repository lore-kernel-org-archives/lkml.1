Return-Path: <linux-kernel-owner+w=401wt.eu-S1759537AbXHUHUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537AbXHUHUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 03:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbXHUHTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 03:19:52 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:26072 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbXHUHTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 03:19:51 -0400
Date: Tue, 21 Aug 2007 11:19:38 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: sam@ravnborg.org, akpm@osdl.org
Cc: jesper.juhl@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] ver_linux is [censored]
Message-ID: <20070821071938.GA17761@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4a645d5ea65baaa5736bcb566673bf4a351b2ad8 broke ver_linux
on etch which glibc has 3-digit version number. Patch replaces awk
wanking with more robust sed wanking.

Tested on gentoo, etch, centos 4.2.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 scripts/ver_linux |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/scripts/ver_linux
+++ b/scripts/ver_linux
@@ -65,9 +65,9 @@ isdnctrl 2>&1 | grep version | awk \
 showmount --version 2>&1 | grep nfs-utils | awk \
 'NR==1{print "nfs-utils             ", $NF}'
 
-ls -l `ldd /bin/sh | awk '/libc/{print $3}'` | sed \
--e 's/\.so$//' | sed -e 's/>//' | \
-awk -F'[.-]' '{print "Linux C Library        "$(NF-1)"."$NF}'
+echo -n "Linux C Library        "
+ls -l `ldd /bin/sh | awk '/libc/{print $3}'` 	| \
+	sed -e 's/.*libc-//' -e 's/\.so$//'
 
 ldd -v > /dev/null 2>&1 && ldd -v || ldd --version |head -n 1 | awk \
 'NR==1{print "Dynamic linker (ldd)  ", $NF}'


