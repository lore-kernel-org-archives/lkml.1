Return-Path: <linux-kernel-owner+w=401wt.eu-S1753587AbYLIMcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbYLIMcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 07:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbYLIMcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 07:32:11 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39991 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbYLIMcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 07:32:10 -0500
Date: Tue, 9 Dec 2008 13:31:52 +0100
From: Pavel Machek <pavel@suse.cz>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, mtk.manpages@gmail.com,
       dl9pf@gmx.de, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>,
       Trivial patch monkey <trivial@kernel.org>
Subject: Re: Document hadling of bad memory
Message-ID: <20081209123152.GA1547@ucw.cz>
References: <20081126161521.GC1983@elf.ucw.cz> <20081201105625.25ee9f32.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081201105625.25ee9f32.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I cleaned the document up according to Randy (thanks!). I don't actually know
enough about DRAM error characcteristics, I guess'round the size of
bad region up to nearest 2^n makes sense.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/Documentation/bad_memory.txt b/Documentation/bad_memory.txt
index df84162..a2a8703 100644
--- a/Documentation/bad_memory.txt
+++ b/Documentation/bad_memory.txt
@@ -14,12 +14,12 @@ There are three possibilities I know of:
 
 3) Use BadRAM or memmap
 
-This Howto is about number 3) .
+This Howto is about number 3).
 
 
 BadRAM
 ######
-BadRAM is the actively developed and available as kernel-patch
+BadRAM is the actively developed and available as a kernel patch
 here:  http://rick.vanrein.org/linux/badram/
 
 For more details see the BadRAM documentation.
@@ -27,19 +27,20 @@ For more details see the BadRAM documentation.
 memmap
 ######
 
-memmap is already in the kernel and usable as kernel-parameter at
-boot-time.  Its syntax is slightly strange and you may need to
-calculate the values by yourself!
+memmap is already in the kernel and usable as a kernel parameter at
+boot time.  Its syntax is slightly strange and you may need to
+calculate the values by yourself.
 
 Syntax to exclude a memory area (see kernel-parameters.txt for details):
 memmap=<size>$<address>
 
-Example: memtest86+ reported here errors at address 0x18691458, 0x18698424 and
+Example: memtest86+ reported errors at address 0x18691458, 0x18698424 and
          some others. All had 0x1869xxxx in common, so I chose a pattern of
-         0x18690000,0xffff0000.
+         0x18690000 and size of 0x10000. (Size needs to cover at least all
+	 known bad places, and rounding to nearest power of 2 makes sense
+	 'just to be safe').
 
 With the numbers of the example above:
 memmap=64K$0x18690000
  or
 memmap=0x10000$0x18690000
-

-- 

(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
