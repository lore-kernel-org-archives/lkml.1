Return-Path: <linux-kernel-owner+w=401wt.eu-S1752813AbXFVFuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbXFVFuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 01:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbXFVFuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 01:50:09 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:26180 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbXFVFuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 01:50:08 -0400
Date: Thu, 21 Jun 2007 22:51:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, ak@suse.de
Subject: [PATCH] doc/oops-tracing: add Code: decode info
Message-Id: <20070621225108.bb69a93d.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add info that the Code: bytes line contains <xy> or (wxyz) in some
architecture oops reports and what that means.

Add URL for a script by Andi Kleen that reads the Code: line from an Oops
report file and generates assembly code from the hex bytes.
(This script does not handle Code: lines that contain <xy> or (wxyz)
markings.)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/oops-tracing.txt |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- linux-2.6.22-rc5.orig/Documentation/oops-tracing.txt
+++ linux-2.6.22-rc5/Documentation/oops-tracing.txt
@@ -86,6 +86,21 @@ stuff are the values reported by the Oop
 and do a replace of spaces to "\x" - that's what I do, as I'm too lazy 
 to write a program to automate this all).
 
+Alternatively, you can use the shell script from
+<ftp://ftp.firstfloor.org/pub/ak/shell/decodecode>.  Usage is:
+decodecode <oops.txt
+
+The hex bytes that follow "Code:" may (in some architectures) have a series
+of bytes that precede the current instruction pointer as well as bytes at and
+following the current instruction pointer.  In some cases, one instruction
+byte or word is surrounded by <> or (), as in "<86>" or "(f00d)".  These
+<> or () markings indicate the current instruction pointer.  Example from
+i386, split into multiple lines for readability:
+
+Code: f9 0f 8d f9 00 00 00 8d 42 0c e8 dd 26 11 c7 a1 60 ea 2b f9 8b 50 08 a1
+64 ea 2b f9 8d 34 82 8b 1e 85 db 74 6d 8b 15 60 ea 2b f9 <8b> 43 04 39 42 54
+7e 04 40 89 42 54 8b 43 04 3b 05 00 f6 52 c0
+
 Finally, if you want to see where the code comes from, you can do
 
 	cd /usr/src/linux
