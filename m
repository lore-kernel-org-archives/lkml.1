Return-Path: <linux-kernel-owner+w=401wt.eu-S1753315AbZLJA54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbZLJA54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 19:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbZLJA5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 19:57:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:44661 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbZLJA5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 19:57:51 -0500
Date: Thu, 10 Dec 2009 00:57:32 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org, hpa@zytor.com,
       mingo@redhat.com, brgerst@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, jeremy@goop.org,
       linux-kernel@vger.kernel.org, brgerst@gmail.com, tglx@linutronix.de
In-Reply-To: <1260403316-5679-3-git-send-email-brgerst@gmail.com>
References: <1260403316-5679-3-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86-64, paravirt: Call set_iopl_mask() on 64 bits
Message-ID: <tip-fc380ceed7fe469728ea4acdbda4495ea943ee1c@git.kernel.org>
Git-Commit-ID: fc380ceed7fe469728ea4acdbda4495ea943ee1c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc380ceed7fe469728ea4acdbda4495ea943ee1c
Gitweb:     http://git.kernel.org/tip/fc380ceed7fe469728ea4acdbda4495ea943ee1c
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Wed, 9 Dec 2009 16:54:08 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 9 Dec 2009 16:54:08 -0800

x86-64, paravirt: Call set_iopl_mask() on 64 bits

set_iopl_mask() is a no-op on 64 bits, but it is also a paravirt hook,
so call it even on 64 bits.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1260403316-5679-3-git-send-email-brgerst@gmail.com>
---
 arch/x86/kernel/ioport.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
index 85ecc7c..8eec0ec 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -116,10 +116,8 @@ long sys_iopl(unsigned int level, struct pt_regs *regs)
 			return -EPERM;
 	}
 	regs->flags = (regs->flags & ~X86_EFLAGS_IOPL) | (level << 12);
-#ifdef CONFIG_X86_32
 	t->iopl = level << 12;
 	set_iopl_mask(t->iopl);
-#endif
 
 	return 0;
 }
