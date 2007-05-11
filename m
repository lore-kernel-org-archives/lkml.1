Return-Path: <linux-kernel-owner+w=401wt.eu-S1031768AbXEKT5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031768AbXEKT5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031661AbXEKT4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:56:52 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031623AbXEKT4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:56:51 -0400
Date: Fri, 11 May 2007 12:56:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kratochvil <honza@jikos.cz>
Cc: Ingo Molnar <mingo@elte.hu>, Jiri Kosina <jikos@jikos.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] PIE randomization
Message-Id: <20070511125629.3df919cf.akpm@linux-foundation.org>
In-Reply-To: <alpine.LRH.0.98.0705111338230.22353@twin.jikos.cz>
References: <alpine.LRH.0.98.0705111338230.22353@twin.jikos.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007 14:33:46 +0200 (CEST)
Jan Kratochvil <honza@jikos.cz> wrote:

> Hello,
>    I sent this patch 5 days ago, nobody replied. So I am giving it second 
> attempt.
> Andrew, is it possible to test this in -mm branch?
> Original mail follows:
> 
> Hi,
>     this is something like reaction to this thread:
> http://lkml.org/lkml/2007/1/6/124. I hope I was able to separate the PIE 
> randomization part correctly.
> 
> There is platform specific (__i386__ only) part in exec shield, I am not 
> pretty sure why is it there, but wasn't brave enough to touch it. Can 
> someone comment the #ifdef out and test it on some other platform?
> 
> It will be nice to follow with brk randomization, but in exec-shield it is 
> afaik i386 only. Right?
> 
> Randomizes -pie compiled binaries. The implementation is part of Redhat's 
> exec-shield (http://people.redhat.com/mingo/exec-shield/).
> 

I don't know what to do with this.  The changelog doesn't tell me what PIE
randomization _is_, nor why the kernel would want to do it.

"Randomizing -pie compiled binaries" sounds fairly undesirable, actually ;)

> 
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 9cc4f0a..1156f41 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -45,7 +45,7 @@
> 
>    static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs);
>    static int load_elf_library(struct file *);
> -static unsigned long elf_map (struct file *, unsigned long, struct elf_phdr *, int, int);
> +static unsigned long elf_map (struct file *, unsigned long, struct elf_phdr *, int, int, unsigned long);

Your email client is space-stuffing the patches.  That's easy to fix at the
receiving end, but it'd be better to fix it at the sending end, please.

