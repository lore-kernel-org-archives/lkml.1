Return-Path: <linux-kernel-owner+w=401wt.eu-S933541AbZJLWf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933541AbZJLWf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933511AbZJLWf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:35:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933523AbZJLWfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:35:23 -0400
Date: Tue, 13 Oct 2009 00:33:42 +0200 (CEST)
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
Subject: [PATCH 2/6 RFC] arch/frv/kernel/process.c: Remove the BKL from
 sys_execve
In-Reply-To: <alpine.LFD.2.00.0910130007240.3658@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0910130008320.3658@localhost.localdomain>
References: <alpine.LFD.2.00.0910122350140.3658@localhost.localdomain> <alpine.LFD.2.00.0910130007240.3658@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4489496ad43049df06b7ffc37afcea561fdb52b9 Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Mon, 12 Oct 2009 22:53:25 +0200
Subject: [PATCH] arch/frv/kernel/process.c: Remove the BKL from sys_execve

sys_execve for frv seems to be a copy-and-paste of sys_execve that
no longer requires the bkl. Just remove it.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 arch/frv/kernel/process.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/frv/kernel/process.c b/arch/frv/kernel/process.c
index 9042559..21d0fd1 100644
--- a/arch/frv/kernel/process.c
+++ b/arch/frv/kernel/process.c
@@ -255,15 +255,12 @@ asmlinkage int sys_execve(char __user *name, char __user * __user *argv, char __
 	int error;
 	char * filename;
 
-	lock_kernel();
 	filename = getname(name);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
-		goto out;
+		return error;
 	error = do_execve(filename, argv, envp, __frame);
 	putname(filename);
- out:
-	unlock_kernel();
 	return error;
 }
 
-- 
1.6.0.6


