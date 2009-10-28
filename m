Return-Path: <linux-kernel-owner+w=401wt.eu-S1753287AbZJ1L4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbZJ1L4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 07:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753103AbZJ1L4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 07:56:03 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:45823 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbZJ1L4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 07:56:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=QKcuMFec3abGYQqXIE9r8A0q/1nXw1Xs+1MS4nEYdep/8gmhLlYfS8nSuz7X7uoE73
         AbnGiy+S1nmX8NjDudrgUyvymI2wf+Tc06GlQ0prOXMeNKQ29JIMNb6Ck+/sgpqla+k/
         QLawT5d/0reBcKsLpuyTYkUO/x3eSBGp9xBBE=
Date: Wed, 28 Oct 2009 14:56:02 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: m.s.tsirkin@gmail.com, linux-kernel@vger.kernel.org, stefani@seibold.net
Subject: [PATCH] proc: fix ->stack_start in compat mode
Message-ID: <20091028115602.GA26295@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assign tsk->stack_start even when doing compat execve(2).

As side effect, fix segfault inside boehm-gc library.
http://bugzilla.kernel.org/show_bug.cgi?id=14478

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 Michael, please, confirm.

 Stefani, I get "Stack usage: 0 kB", you may want to look at it.

 fs/compat.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1532,6 +1532,8 @@ int compat_do_execve(char * filename,
 	if (retval < 0)
 		goto out;
 
+	current->stack_start = current->mm->start_stack;
+
 	/* execve succeeded */
 	current->fs->in_exec = 0;
 	current->in_execve = 0;
