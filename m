Return-Path: <linux-kernel-owner+w=401wt.eu-S1161764AbXECVUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161764AbXECVUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 17:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161513AbXECVUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 17:20:05 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58108 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161485AbXECVUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 17:20:03 -0400
Date: Thu, 3 May 2007 14:19:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 2/2] rename thread_info to stack
Message-Id: <20070503141951.d67d0289.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705010210010.1479@scrub.home>
References: <Pine.LNX.4.64.0705010210010.1479@scrub.home>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007 02:10:34 +0200 (CEST)
Roman Zippel <zippel@linux-m68k.org> wrote:

> This finally renames the thread_info field in task structure to stack,
> so that the assumptions about this field are gone and archs have more
> freedom about placing the thread_info structure.

It needed this build fix:

--- a/include/asm-x86_64/system.h~rename-thread_info-to-stack-fix
+++ a/include/asm-x86_64/system.h
@@ -39,7 +39,7 @@
 		       [threadrsp] "i" (offsetof(struct task_struct, thread.rsp)), \
 		       [ti_flags] "i" (offsetof(struct thread_info, flags)),\
 		       [tif_fork] "i" (TIF_FORK),			  \
-		       [thread_info] "i" (offsetof(struct task_struct, thread_info)), \
+		       [thread_info] "i" (offsetof(struct task_struct, stack)), \
 		       [pda_pcurrent] "i" (offsetof(struct x8664_pda, pcurrent))   \
 		     : "memory", "cc" __EXTRA_CLOBBER)
     
_


It is unpleasing that this code is forced to implicitly assume that the
thing pointed to by task_struct.stack has type `struct thread_info'.

Are we sure this patch is a good thing?
