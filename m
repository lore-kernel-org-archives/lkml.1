Return-Path: <linux-kernel-owner+w=401wt.eu-S1763814AbYFFC5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763814AbYFFC5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 22:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbYFFC4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 22:56:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33584 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753571AbYFFC4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 22:56:53 -0400
Date: Thu, 5 Jun 2008 19:56:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: Tree for June 5
Message-Id: <20080605195604.41623687.akpm@linux-foundation.org>
In-Reply-To: <20080605175217.cee497f3.sfr@canb.auug.org.au>
References: <20080605175217.cee497f3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2008 17:52:17 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git

Instantly oopses on two x86_64 boxes with this config:
http://userweb.kernel.org/~akpm/config-akpm2.txt

oops: http://userweb.kernel.org/~akpm/p6056454.jpg

At a guess I'd say the sched_domains code is calling into slab before
slab is initalised.  Something like that.


I had to do this:

--- a/arch/x86/kernel/traps_64.c~a
+++ a/arch/x86/kernel/traps_64.c
@@ -504,6 +504,7 @@ void show_registers(struct pt_regs *regs
 		}
 	}
 	printk("\n");
+	for (  ;; );
 }	
 
 int is_valid_bugaddr(unsigned long ip)
_

to collect that oops.  Otherwise it scrolled away due to "trying to
kill init" doing a dump_stack.  pause_on_oops seems to not be working
properly any more.  It used to.

