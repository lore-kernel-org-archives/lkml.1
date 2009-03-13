Return-Path: <linux-kernel-owner+w=401wt.eu-S1757669AbZCMCen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669AbZCMCen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756057AbZCMCeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:34:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:39521 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750AbZCMCeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:34:21 -0400
Date: Fri, 13 Mar 2009 02:33:38 GMT
From: Jan Beulich <jbeulich@novell.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49B90F12.76E4.0078.0@novell.com>
References: <49B90F12.76E4.0078.0@novell.com>
Subject: [tip:x86/mm] x86, 32-bit: also limit NODES_HIGH_SHIFT here
Message-ID: <tip-46d50c98d90cd7feaa5977a09c574063e5c99b3d@git.kernel.org>
Git-Commit-ID: 46d50c98d90cd7feaa5977a09c574063e5c99b3d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 02:33:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  46d50c98d90cd7feaa5977a09c574063e5c99b3d
Gitweb:     http://git.kernel.org/tip/46d50c98d90cd7feaa5977a09c574063e5c99b3d
Author:     Jan Beulich <jbeulich@novell.com>
AuthorDate: Thu, 12 Mar 2009 12:33:06 +0000
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 02:37:17 +0100

x86, 32-bit: also limit NODES_HIGH_SHIFT here

Impact: configuration bug fix

Just like for x86-64, the range of widths valid for NODE_SHIFT is not
unbounded. The upper bound 64-bit uses is definitely also an upper
bound for 32-bit.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <49B90F12.76E4.0078.0@novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 87717f3..076f4f8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1123,7 +1123,7 @@ config NUMA_EMU
 
 config NODES_SHIFT
 	int "Maximum NUMA Nodes (as a power of 2)" if !MAXSMP
-	range 1 9   if X86_64
+	range 1 9
 	default "9" if MAXSMP
 	default "6" if X86_64
 	default "4" if X86_NUMAQ
