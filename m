Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188AbZCLL6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbZCLL6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 07:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbZCLL6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 07:58:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:59737 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581AbZCLL6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 07:58:21 -0400
Date: Thu, 12 Mar 2009 11:57:37 GMT
From: Jan Beulich <jbeulich@novell.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49B8F44F.76E4.0078.0@novell.com>
References: <49B8F44F.76E4.0078.0@novell.com>
Subject: [tip:x86/asm] x86-64: move save_paranoid into .kprobes.text
Message-ID: <tip-c2810188c1b810c68139608a207befae0a4f1e69@git.kernel.org>
Git-Commit-ID: c2810188c1b810c68139608a207befae0a4f1e69
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 12 Mar 2009 11:57:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c2810188c1b810c68139608a207befae0a4f1e69
Gitweb:     http://git.kernel.org/tip/c2810188c1b810c68139608a207befae0a4f1e69
Author:     "Jan Beulich" <jbeulich@novell.com>
AuthorDate: Thu, 12 Mar 2009 10:38:55 +0000
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 12 Mar 2009 11:57:46 +0100

x86-64: move save_paranoid into .kprobes.text

Impact: mark save_paranoid as non-kprobe-able code

This appears to be necessary as the function gets called from
kprobes-unsafe exception handling stubs (i.e. which themselves
live in .kprobes.text).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <49B8F44F.76E4.0078.0@novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/entry_64.S |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 54866bb..a331ec3 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -368,6 +368,7 @@ ENTRY(save_rest)
 END(save_rest)
 
 /* save complete stack frame */
+	.pushsection .kprobes.text, "ax"
 ENTRY(save_paranoid)
 	XCPT_FRAME 1 RDI+8
 	cld
@@ -396,6 +397,7 @@ ENTRY(save_paranoid)
 1:	ret
 	CFI_ENDPROC
 END(save_paranoid)
+	.popsection
 
 /*
  * A newly forked process directly context switches into this address.
