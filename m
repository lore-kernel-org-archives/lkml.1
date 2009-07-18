Return-Path: <linux-kernel-owner+w=401wt.eu-S1751444AbZGRMHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444AbZGRMHJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 08:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbZGRMHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 08:07:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:60125 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbZGRMHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 08:07:06 -0400
Date: Sat, 18 Jul 2009 12:06:11 GMT
From: tip-bot for Catalin Marinas <catalin.marinas@arm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       bug-track@fisher-privat.net, penberg@cs.helsinki.fi, sam@ravnborg.org,
       catalin.marinas@arm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       bug-track@fisher-privat.net, catalin.marinas@arm.com, sam@ravnborg.org,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1247565175.28240.37.camel@pc1117.cambridge.arm.com>
References: <1247565175.28240.37.camel@pc1117.cambridge.arm.com>
Subject: [tip:x86/urgent] x86: Include all of .data.* sections in _edata on 64-bit
Message-ID: <tip-8bcdbe427924a1e4b4e4cf68020e92e9f93fe011@git.kernel.org>
Git-Commit-ID: 8bcdbe427924a1e4b4e4cf68020e92e9f93fe011
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 18 Jul 2009 12:06:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8bcdbe427924a1e4b4e4cf68020e92e9f93fe011
Gitweb:     http://git.kernel.org/tip/8bcdbe427924a1e4b4e4cf68020e92e9f93fe011
Author:     Catalin Marinas <catalin.marinas@arm.com>
AuthorDate: Tue, 14 Jul 2009 10:52:55 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 18 Jul 2009 13:59:20 +0200

x86: Include all of .data.* sections in _edata on 64-bit

The .data.read_mostly and .data.cacheline_aligned sections
aren't covered by the _sdata .. _edata range on x86-64. This
affects kmemleak reporting leading to possible false
positives by not scanning the whole data section.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Alexey Fisher <bug-track@fisher-privat.net>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
LKML-Reference: <1247565175.28240.37.camel@pc1117.cambridge.arm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>


---
 arch/x86/kernel/vmlinux.lds.S |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 367e878..59f31d2 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -112,11 +112,6 @@ SECTIONS
 		_sdata = .;
 		DATA_DATA
 		CONSTRUCTORS
-
-#ifdef CONFIG_X86_64
-		/* End of data section */
-		_edata = .;
-#endif
 	} :data
 
 #ifdef CONFIG_X86_32
@@ -156,10 +151,8 @@ SECTIONS
 	.data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
 		*(.data.read_mostly)
 
-#ifdef CONFIG_X86_32
 		/* End of data section */
 		_edata = .;
-#endif
 	}
 
 #ifdef CONFIG_X86_64
