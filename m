Return-Path: <linux-kernel-owner+w=401wt.eu-S1752457AbYKZQNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbYKZQNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 11:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbYKZQNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 11:13:34 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49922 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbYKZQNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 11:13:33 -0500
Date: Wed, 26 Nov 2008 17:15:21 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, mtk.manpages@gmail.com,
       dl9pf@gmx.de, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>,
       Trivial patch monkey <trivial@kernel.org>
Subject: Document hadling of bad memory
Message-ID: <20081126161521.GC1983@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Document how to deal with bad memory reported with memtest.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/Documentation/bad_memory.txt b/Documentation/bad_memory.txt
new file mode 100644
index 0000000..df84162
--- /dev/null
+++ b/Documentation/bad_memory.txt
@@ -0,0 +1,45 @@
+March 2008
+Jan-Simon Moeller, dl9pf@gmx.de
+
+
+How to deal with bad memory e.g. reported by memtest86+ ?
+#########################################################
+
+There are three possibilities I know of:
+
+1) Reinsert/swap the memory modules
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
+For more details see the BadRAM documentation.
+
+memmap
+######
+
+memmap is already in the kernel and usable as kernel-parameter at
+boot-time.  Its syntax is slightly strange and you may need to
+calculate the values by yourself!
+
+Syntax to exclude a memory area (see kernel-parameters.txt for details):
+memmap=<size>$<address>
+
+Example: memtest86+ reported here errors at address 0x18691458, 0x18698424 and
+         some others. All had 0x1869xxxx in common, so I chose a pattern of
+         0x18690000,0xffff0000.
+
+With the numbers of the example above:
+memmap=64K$0x18690000
+ or
+memmap=0x10000$0x18690000
+

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
