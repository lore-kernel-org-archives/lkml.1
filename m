Return-Path: <linux-kernel-owner+w=401wt.eu-S933534AbZJLWgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933534AbZJLWgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757141AbZJLWgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:36:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774AbZJLWgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:36:36 -0400
Date: Tue, 13 Oct 2009 00:34:24 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>, Mike Frysinger <vapier@gentoo.org>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Roman Zippel <zippel@linux-m68k.org>, Greg Ungerer <gerg@uclinux.org>,
       David Howells <dhowells@redhat.com>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Subject: [PATCH 4/6 RFC] arch/m68k/kernel/process.c: Remove the BKL from
 sys_execve
In-Reply-To: <alpine.LFD.2.00.0910130010000.3658@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0910130011180.3658@localhost.localdomain>
References: <alpine.LFD.2.00.0910122350140.3658@localhost.localdomain> <alpine.LFD.2.00.0910130007240.3658@localhost.localdomain> <alpine.LFD.2.00.0910130008320.3658@localhost.localdomain> <alpine.LFD.2.00.0910130010000.3658@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2dfc4e18d8968d00c0ad16c4c9e7ffd58809944b Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Mon, 12 Oct 2009 23:09:24 +0200
Subject: [PATCH] arch/m68k/kernel/process.c: Remove the BKL from sys_execve

This seems like a copy-and-paste from code that no-longer needs the BKL
Just remove it.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 arch/m68k/kernel/process.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/m68k/kernel/process.c b/arch/m68k/kernel/process.c
index 41230c5..0529659 100644
--- a/arch/m68k/kernel/process.c
+++ b/arch/m68k/kernel/process.c
@@ -317,15 +317,12 @@ asmlinkage int sys_execve(char __user *name, char __user * __user *argv, char __
 	char * filename;
 	struct pt_regs *regs = (struct pt_regs *) &name;
 
-	lock_kernel();
 	filename = getname(name);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
-		goto out;
+		return error;
 	error = do_execve(filename, argv, envp, regs);
 	putname(filename);
-out:
-	unlock_kernel();
 	return error;
 }
 
-- 
1.6.0.6


