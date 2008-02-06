Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbYBFQ0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbYBFQ0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 11:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbYBFQ0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 11:26:39 -0500
Received: from styx.suse.cz ([82.119.242.94]:50120 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752041AbYBFQ0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 11:26:38 -0500
Date: Wed, 6 Feb 2008 17:26:37 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Hugh Dickins <hugh@veritas.com>,
       Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH] Document randomize_va_space and CONFIG_COMPAT_BRK (was Re:
 [PATCH 2/2] ASLR: add possibility for more fine-grained tweaking)
In-Reply-To: <20080206134959.GA25689@elte.hu>
Message-ID: <Pine.LNX.4.64.0802061650230.30955@jikos.suse.cz>
References: <Pine.LNX.4.64.0802061438150.30955@jikos.suse.cz>
 <Pine.LNX.4.64.0802061442300.30955@jikos.suse.cz> <20080206134959.GA25689@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008, Ingo Molnar wrote:

> i've already added the patch below to x86.git.

OK, cool, thanks.

Still, I think that we want the Documentation/sysctl/kernel.txt part of my 
patch probably. Updated patch below.


From: Jiri Kosina <jkosina@suse.cz>

Document randomize_va_space and CONFIG_COMPAT_BRK

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 8984a53..dc8801d 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -41,6 +41,7 @@ show up in /proc/sys/kernel:
 - pid_max
 - powersave-nap               [ PPC only ]
 - printk
+- randomize_va_space
 - real-root-dev               ==> Documentation/initrd.txt
 - reboot-cmd                  [ SPARC only ]
 - rtsig-max
@@ -280,6 +281,34 @@ send before ratelimiting kicks in.
 
 ==============================================================
 
+randomize-va-space:
+
+This option can be used to select the type of process address
+space randomization that is used in the system, for architectures
+that support this feature.
+
+0 - Turn the process address space randomization off by default.
+
+1 - Make the addresses of mmap base, stack and VDSO page randomized.
+    This, among other things, implies that shared libraries will be
+    loaded to random addresses. Also for PIE-linked binaries, the location
+    of code start is randomized.
+
+    With heap randomization, the situation is a little bit more
+    complicated.
+    There a few legacy applications out there (such as some ancient
+    versions of libc.so.5 from 1996) that assume that brk area starts
+    just after the end of the code+bss. These applications break when
+    start of the brk area is randomized. There are however no known
+    non-legacy applications that would be broken this way, so for most
+    systems it is safe to choose full randomization. However there is
+    a CONFIG_COMPAT_BRK option for systems with ancient and/or broken
+    binaries, that makes heap non-randomized, but keeps all other
+    parts of process address space randomized if randomize_va_space
+    sysctl is turned on.
+
+==============================================================
+
 reboot-cmd: (Sparc only)
 
 ??? This seems to be a way to give an argument to the Sparc
