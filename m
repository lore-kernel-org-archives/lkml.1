Return-Path: <linux-kernel-owner+w=401wt.eu-S1751814AbYIGXWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbYIGXWw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 19:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750783AbYIGXWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 19:22:42 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:47870 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbYIGXWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 19:22:41 -0400
From: David Sanders <linux@sandersweb.net>
Reply-To: linux@sandersweb.net
To: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
Date: Sun, 7 Sep 2008 19:22:32 -0400
User-Agent: KMail/1.9.5
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi-suse@firstfloor.org>
References: <200808311422.12525.linux@sandersweb.net> <48C1C156.9080003@zytor.com> <200809071607.52645.linux@sandersweb.net>
In-Reply-To: <200809071607.52645.linux@sandersweb.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809071922.32974.linux@sandersweb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 September 2008 19:31, H. Peter Anvin wrote:
> David Sanders wrote:
> > I recently discovered that x86 kernels won't boot under Virtual PC.  In
>
> Could you please confirm if the tip kernel solves the problem?
>

Yes the patch you supplied (and now in Linus's tree) fixes (part) of the problem.
In order to get a working kernel I also need a patch for the nops.h issue.  
I have tested and confirmed that the patch posted by Linus works and finally 
solves the problem with virtual PC.

Linus please apply your patch (which I quote below).
---
 arch/x86/Kconfig.cpu |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 2c518fb..b225219 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -382,14 +382,17 @@ config X86_OOSTORE
 # P6_NOPs are a relatively minor optimization that require a family >=
 # 6 processor, except that it is broken on certain VIA chips.
 # Furthermore, AMD chips prefer a totally different sequence of NOPs
-# (which work on all CPUs).  As a result, disallow these if we're
-# compiling X86_GENERIC but not X86_64 (these NOPs do work on all
-# x86-64 capable chips); the list of processors in the right-hand clause
-# are the cores that benefit from this optimization.
+# (which work on all CPUs).  In addition, it looks like Virtual PC
+# does not understand them.
+#
+# As a result, disallow these if we're not compiling for X86_64 (these
+# NOPs do work on all x86-64 capable chips); the list of processors in
+# the right-hand clause are the cores that benefit from this optimization.
 #
 config X86_P6_NOP
 	def_bool y
-	depends on (X86_64 || !X86_GENERIC) && (M686 || MPENTIUMII || MPENTIUMIII || MPENTIUMM || MCORE2 || MPENTIUM4 || MPSC)
+	depends on X86_64
+	depends on (MCORE2 || MPENTIUM4 || MPSC)
 
 config X86_TSC
 	def_bool y



