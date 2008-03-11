Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbYCKRuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbYCKRuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 13:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbYCKRuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 13:50:00 -0400
Received: from mail.gmx.net ([213.165.64.20]:36863 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752296AbYCKRt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 13:49:59 -0400
X-Authenticated: #7313500
X-Provags-ID: V01U2FsdGVkX18qi59TqAIqe262nbL6b9NOGqJRtFsEiIfMDCnF6s
	Ri84/HMHdY8auK
From: Jan-Simon =?iso-8859-1?q?M=F6ller?= <dl9pf@gmx.de>
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
Date: Tue, 11 Mar 2008 18:49:52 +0100
User-Agent: KMail/1.9.9
Cc: "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       devzero@web.de, linux-kernel@vger.kernel.org, rick@vanrein.org
References: <182234194@web.de> <200803101959.47202.dl9pf@gmx.de> <200803111323.11524.lenb@kernel.org>
In-Reply-To: <200803111323.11524.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803111849.53272.dl9pf@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches V3 with corrected Syntax, tnx hpa !
Changed also text according to idea from Len.

diff --git a/Documentation/kernel-parameters.txt 
b/Documentation/kernel-parameters.txt
index 533e67f..f25da88 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1131,6 +1131,10 @@ and is between 256 and 4096 characters. It is defined 
in the file
        memmap=nn[KMG]$ss[KMG]
                        [KNL,ACPI] Mark specific memory as reserved.
                        Region of memory to be used, from ss to ss+nn.
+                       Example: Exclude memory from 0x18690000-0x1869ffff
+                                memmap=64K$0x18690000
+                                or
+                                memmap=0x10000$0x18690000

        meye.*=         [HW] Set MotionEye Camera parameters
                        See Documentation/video4linux/meye.txt.


Signed-off-by: Jan-Simon Moeller <dl9pf@gmx.de>



--- /dev/null   2007-09-21 21:12:45.000000000 +0200
+++ bad-memory.txt      2008-03-11 18:44:45.101344820 +0100
@@ -0,0 +1,56 @@
+March 2008
+Jan-Simon Moeller, dl9pf@gmx.de
+
+
+How to deal with bad memory e.g. reported by memtest86+ ?
+#########################################################
+
+There are three possibilities I know of:
+
+1) Reinsert/swap the memory modules (bad contact?)
+
+2) Buy new modules (best!) or try to exchange the memory
+   if you have spare-parts
+
+3) Use BadRAM or memmap
+
+This Howto is about number 3) .
+
+
+BadRAM
+######
+BadRAM is the actively developed and available as kernel-patch
+here:  http://rick.vanrein.org/linux/badram/
+
+It takes the patterns of memtest86+ as arguments to exclude the defective
+areas of the memory.
+
+Example: memtest86+ reported here errors at address 0x18691458, 0x18698424 
and
+         some others. All had 0x1869xxxx in common, so I chose a pattern of
+         0x18690000,0xffff0000.
+         This means exclusion of the area from 0x18690000 to 0x1869ffff
+         (which is a block of 64k).
+         My kernel-cmdline was:  badram=0x18690000,0xffff0000
+
+There are efforts to bring BadRAM into mainline in some way, possibly using
+memmap internally (maybe 2.6.26 ?).
+Thread on lkml: http://lkml.org/lkml/2008/3/2/42
+
+For more details see the BadRAM documentation.
+
+
+memmap
+######
+memmap is already in the kernel and usable as kernel-parameter at boot-time.
+Its syntax is different and you may need to calculate the values by yourself!
+
+Syntax to exclude a memory area (see kernel-parameters for details):
+memmap=<size>$<address>
+
+With the numbers of the example above:
+memmap=64K$0x18690000
+ or
+memmap=0x10000$0x18690000
+
+TODO: Multiple areas to exclude using memmap ?
+


Signed-off-by: Jan-Simon Moeller <dl9pf@gmx.de>
