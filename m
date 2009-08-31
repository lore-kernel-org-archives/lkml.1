Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbZHaSZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbZHaSZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 14:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbZHaSZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 14:25:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:33820 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753620AbZHaSZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 14:25:01 -0400
Date: Mon, 31 Aug 2009 18:24:41 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       suresh.siddha@intel.com, venkatesh.pallipadi@intel.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.siddha@intel.com, venkatesh.pallipadi@intel.com,
       tglx@linutronix.de
In-Reply-To: <4A9828F4.4040905@zytor.com>
References: <4A9828F4.4040905@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/pat] mm: remove !NUMA condition from PAGEFLAGS_EXTENDED condition set
Message-ID: <tip-a269cca9926faf8e44b340b017be0d884203141b@git.kernel.org>
Git-Commit-ID: a269cca9926faf8e44b340b017be0d884203141b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 31 Aug 2009 18:24:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a269cca9926faf8e44b340b017be0d884203141b
Gitweb:     http://git.kernel.org/tip/a269cca9926faf8e44b340b017be0d884203141b
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Mon, 31 Aug 2009 11:17:44 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 31 Aug 2009 11:17:44 -0700

mm: remove !NUMA condition from PAGEFLAGS_EXTENDED condition set

CONFIG_PAGEFLAGS_EXTENDED disables a trick to conserve pageflags.
This trick is indended to be enabled when the pressure on page flags
is very high.

The previous condition was:

-       depends on 64BIT || SPARSEMEM_VMEMMAP || !NUMA || !SPARSEMEM

... however, the sparsemem code already has a way to crowd out the
node number from the pageflags, which means that !NUMA actually
doesn't contribute to hard pageflags exhaustion.

This is required for the new PG_uncached flag to not cause pageflags
exhaustion on x86_32 + PAE + SPARSEMEM + !NUMA.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <4A9828F4.4040905@zytor.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Suresh Siddha <suresh.siddha@intel.com>


---
 mm/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index c948d4c..fe221c7 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -153,7 +153,7 @@ config MEMORY_HOTREMOVE
 #
 config PAGEFLAGS_EXTENDED
 	def_bool y
-	depends on 64BIT || SPARSEMEM_VMEMMAP || !NUMA || !SPARSEMEM
+	depends on 64BIT || SPARSEMEM_VMEMMAP || !SPARSEMEM
 
 # Heavily threaded applications may benefit from splitting the mm-wide
 # page_table_lock, so that faults on different parts of the user address
