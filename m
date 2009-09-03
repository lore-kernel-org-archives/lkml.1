Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbZICFrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbZICFrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 01:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbZICFrC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 01:47:02 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34413 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276AbZICFrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 01:47:01 -0400
Date: Thu, 3 Sep 2009 15:47:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mikael Pettersson <mikpe@it.uu.se>, Russell King <rmk@arm.linux.org.uk>,
       David Howells <dhowells@redhat.com>
Subject: linux-next: manual merge of the security-testing tree with the arm
 tree
Message-Id: <20090903154700.2d4538cf.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Today's linux-next merge of the security-testing tree got a conflicts in
arch/arm/kernel/signal.c between commit
369842658a36bcea28ecb643ba4bdb53919330dd ("ARM: 5677/1: ARM support for
TIF_RESTORE_SIGMASK/pselect6/ppoll/epoll_pwait") from the arm tree and
commits d0420c83f39f79afb82010c2d2cafd150eef651b ("KEYS: Extend
TIF_NOTIFY_RESUME to (almost) all architectures [try #6]") and
ee18d64c1f632043a02e6f5ba5e045bb26a5465f ("KEYS: Add a keyctl to install
a process's session keyring on its parent [try #6]") from the
security-testing tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/kernel/signal.c
index f7194e4,ea4ad3a..0000000
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@@ -694,5 -706,12 +694,12 @@@ asmlinkage voi
  do_notify_resume(struct pt_regs *regs, unsigned int thread_flags, int syscall)
  {
  	if (thread_flags & _TIF_SIGPENDING)
 -		do_signal(&current->blocked, regs, syscall);
 +		do_signal(regs, syscall);
+ 
+ 	if (thread_flags & _TIF_NOTIFY_RESUME) {
+ 		clear_thread_flag(TIF_NOTIFY_RESUME);
+ 		tracehook_notify_resume(regs);
+ 		if (current->replacement_session_keyring)
+ 			key_replace_session_keyring();
+ 	}
  }
