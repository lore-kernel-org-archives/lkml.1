Return-Path: <linux-kernel-owner+w=401wt.eu-S933550AbZJLWfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933550AbZJLWfz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933512AbZJLWfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:35:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933498AbZJLWfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:35:53 -0400
Date: Tue, 13 Oct 2009 00:34:02 +0200 (CEST)
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
Subject: [PATCH 3/6 RFC] arch/h83000/kernel/process.c: Remove BKL from
 sys_execve
In-Reply-To: <alpine.LFD.2.00.0910130008320.3658@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0910130010000.3658@localhost.localdomain>
References: <alpine.LFD.2.00.0910122350140.3658@localhost.localdomain> <alpine.LFD.2.00.0910130007240.3658@localhost.localdomain> <alpine.LFD.2.00.0910130008320.3658@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5cd96ce7851d01c1c28da724dd50713c8a1c66d7 Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Mon, 12 Oct 2009 23:04:11 +0200
Subject: [PATCH] arch/h83000/kernel/process.c: Remove BKL from sys_execve

This looks like a copy-and-paste job for code that no-longer needs the BKL
Just remove it.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 arch/h8300/kernel/process.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/h8300/kernel/process.c b/arch/h8300/kernel/process.c
index e2f33d0..bd883fa 100644
--- a/arch/h8300/kernel/process.c
+++ b/arch/h8300/kernel/process.c
@@ -218,15 +218,12 @@ asmlinkage int sys_execve(char *name, char **argv, char **envp,int dummy,...)
 	char * filename;
 	struct pt_regs *regs = (struct pt_regs *) ((unsigned char *)&dummy-4);
 
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


