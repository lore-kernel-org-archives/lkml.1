Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935814Ab0CMAf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:35:58 -0500
Received: from kroah.org ([198.145.64.141]:47110 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935513Ab0CMAcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:32:16 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:15 2010
Message-Id: <20100313002714.996798887@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:27:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiri Slaby <jslaby@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Ollie Wild <aaw@google.com>,
       x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [112/145] x86, ia32_aout: do not kill argument mapping
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Jiri Slaby <jslaby@suse.cz>

commit 318f6b228ba88a394ef560efc1bfe028ad5ae6b6 upstream.

Do not set current->mm->mmap to NULL in 32-bit emulation on 64-bit
load_aout_binary after flush_old_exec as it would destroy already
set brpm mapping with arguments.

Introduced by b6a2fea39318e43fee84fa7b0b90d68bed92d2ba
mm: variable length argument support
where the argument mapping in bprm was added.

[ hpa: this is a regression from 2.6.22... time to kill a.out? ]

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
LKML-Reference: <1265831716-7668-1-git-send-email-jslaby@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ollie Wild <aaw@google.com>
Cc: x86@kernel.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/ia32/ia32_aout.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -327,7 +327,6 @@ static int load_aout_binary(struct linux
 	current->mm->free_area_cache = TASK_UNMAPPED_BASE;
 	current->mm->cached_hole_size = 0;
 
-	current->mm->mmap = NULL;
 	install_exec_creds(bprm);
 	current->flags &= ~PF_FORKNOEXEC;
 


