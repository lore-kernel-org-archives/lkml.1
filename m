Return-Path: <linux-kernel-owner+w=401wt.eu-S941458AbXGaCqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941458AbXGaCqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761038AbXGaCqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:46:04 -0400
Received: from mail.windriver.com ([147.11.1.11]:37843 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760427AbXGaCqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:46:01 -0400
Message-ID: <46AEA245.9090300@windriver.com>
Date: Mon, 30 Jul 2007 21:45:25 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: apw@shadowen.org, rdunlap@xenotime.net, jschopp@austin.ibm.com
Subject: [PATCH] Check patch reports multiple var with a function assignment
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Jul 2007 02:45:26.0006 (UTC) FILETIME=[D9359160:01C7D31C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Running checkpatch.pl products an warning when it should not.  I believe 
it can be fixed by adding to the regular expression, but feel free to 
fix it another way as I may not know all the cases this is trying to catch.

-- check patch output --
WARNING: declaring multiple variables together should be avoided
#451: FILE: drivers/serial/8250.c:1685:
+       unsigned char lsr = serial_inp(up, UART_LSR);

-- end check patch output --

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 73751ab..32c6d74 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -825,8 +825,8 @@ sub process {
 
 # check for multiple declarations, allowing for a function declaration
 # continuation.
-               if ($line =~ 
/^.\s*$Type\s+$Ident(?:\s*=[^,{]*)?\s*,\s*$Ident.*/ &&
-                   $line !~ 
/^.\s*$Type\s+$Ident(?:\s*=[^,{]*)?\s*,\s*$Type\s*$Ident.*/) {
+               if ($line =~ 
/^.\s*$Type\s+$Ident(?:\s*=[^,{\(]*)?\s*,\s*$Ident.*/ &&
+                   $line !~ 
/^.\s*$Type\s+$Ident(?:\s*=[^,{\(]*)?\s*,\s*$Type\s*$Ident.*/) {
                        WARN("declaring multiple variables together 
should be avoided\n" . $herecurr);
                }

