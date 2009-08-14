Return-Path: <linux-kernel-owner+w=401wt.eu-S1756131AbZHNF5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbZHNF5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 01:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756063AbZHNF5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 01:57:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54316 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbZHNF5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 01:57:19 -0400
Date: Thu, 13 Aug 2009 22:57:17 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: torvalds@linux-foundation.org
Subject: [PATCH] scripts/ver_linux
Message-ID: <alpine.DEB.2.01.0908132251000.30417@bogon.housecafe.de>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX19jjoAzSN7lhyhLPwVnCSUiS3GcVLsSHuriIbv
 2QjEzmrSABXtRnsx8H//7JNFCfD1s8liibQBAfNMjdnm/vtxFZ
 LQrlFVcaClaMRsx/8gbOQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

sometimes I'm using scripts/ver_linux to quickly have an overview of my 
(build-)environment. The output is usually a bit off, since I don't have 
"kbd" or "console-tools" installed and don't have /sbin:/usr/sbin in my 
PATH. The patch below makes scripts/ver_linux print a better result, 
compared to its original output:

-module-init-tools      found
+module-init-tools      3.4
+e2fsprogs              1.41.3
+jfsutils               1.1.12
+reiserfsprogs          3.6.19
+reiser4progs           1.0.6
+xfsprogs               2.9.8
 Linux C Library        2.7
 Procps                 3.2.7
-Kbd                    loadkeys:
+Net-tools              1.60
 Sh-utils               6.10

Signed-off-by: Christian Kujau <lists@nerdbynature.de>

--- linux-2.6-git/scripts/ver_linux.orig	2009-08-14 07:47:12.185695350 +0200
+++ linux-2.6-git/scripts/ver_linux	2009-08-14 07:47:23.642348227 +0200
@@ -4,6 +4,7 @@
 # /bin /sbin /usr/bin /usr/sbin /usr/local/bin, but it may
 # differ on your system.
 #
+PATH="$PATH":/sbin:/usr/sbin
 echo 'If some fields are empty or look unusual you may have an old version.'
 echo 'Compare to the current minimal requirements in Documentation/Changes.'
 echo ' '
@@ -76,7 +77,7 @@ ifconfig --version 2>&1 | grep tools | a
 
 # Kbd needs 'loadkeys -h',
 loadkeys -h 2>&1 | awk \
-'(NR==1 && ($3 !~ /option/)) {print "Kbd                   ", $3}'
+'(NR==1 && ($1 = /^loadkeys/)) {print "Kbd                   ", $3}'
 
 # while console-tools needs 'loadkeys -V'.
 loadkeys -V 2>&1 | awk \

-- 
BOFH excuse #17:

fat electrons in the lines
