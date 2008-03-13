Return-Path: <linux-kernel-owner+w=401wt.eu-S1755931AbYCMKMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbYCMKMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 06:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754881AbYCMKLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 06:11:36 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35234 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854AbYCMKLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 06:11:34 -0400
Date: Thu, 13 Mar 2008 09:08:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: dl9pf@gmx.de, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>,
       Trivial patch monkey <trivial@kernel.org>
Subject: document memmap option better and help people with bad memory
Message-ID: <20080313080804.GA19808@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide example for memmap exclude option (it is slightly strange an
non-trivial) and provide nice small HOWTO for people with bad memory.

Signed-off-by: Jan-Simon Moeller <dl9pf@gmx.de>
Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit ec630f2291d7a3a154e22fa54cd74e5f6aa47f9a
tree 9cf33f9fcda3ea363061acebc971c37815f6c907
parent 456fc99ea933d38466ee25681908868cde3425c5
author Pavel <pavel@amd.ucw.cz> Thu, 13 Mar 2008 09:06:15 +0100
committer Pavel <pavel@amd.ucw.cz> Thu, 13 Mar 2008 09:06:15 +0100

 Documentation/bad_memory.txt        |   45 +++++++++++++++++++++++++++++++++++
 Documentation/kernel-parameters.txt |    4 +++
 2 files changed, 49 insertions(+), 0 deletions(-)

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
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 533e67f..f25da88 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1131,6 +1131,10 @@ and is between 256 and 4096 characters. 
 	memmap=nn[KMG]$ss[KMG]
 			[KNL,ACPI] Mark specific memory as reserved.
 			Region of memory to be used, from ss to ss+nn.
+			Example: Exclude memory from 0x18690000-0x1869ffff
+			         memmap=64K$0x18690000
+			         or
+			         memmap=0x10000$0x18690000
 
 	meye.*=		[HW] Set MotionEye Camera parameters
 			See Documentation/video4linux/meye.txt.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
