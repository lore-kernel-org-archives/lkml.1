Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbZJZJiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbZJZJiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 05:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbZJZJiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 05:38:51 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:34629 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999AbZJZJiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 05:38:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=DnQ3ylKSOZVEniGfnKPM0LTlop8nPPx81vBIMX1hhjgVu5rXCbRGy3Li3pFaV2hBGu
         l5KSzmGUang6F4xBUljkPmU69ZyRLaRiLv4Bu91/5dPHOLPEJK0AOdM1QrdGaccvR7nV
         L2qiTn5vo9a5gloSsHZNrV5simZIx0td7HMIc=
MIME-Version: 1.0
Date: Mon, 26 Oct 2009 05:38:54 -0400
Message-ID: <787b0d920910260238o2c3d2647k6c4ec16052307d3f@mail.gmail.com>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
From: Albert Cahalan <acahalan@gmail.com>
To: sukadev@linux.vnet.ibm.com, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sukadev Bhattiprolu writes:

>         struct clone_struct {
>                 u64 flags;
>                 u64 child_stack;
>                 u32 nr_pids;
>                 u32 reserved1;
>                 u64 parent_tid;
>                 u64 child_tid;
>                 u64 reserved2;
>         };
>
>         sys_clone3(struct clone_struct __user *cs, pid_t __user *pids)

We'll be needing a clone4() for ia64 if you don't include the
stack_size parameter.

You have a prime opportunity to fix a portability problem that
has been quite a pain for some time. There are currently 3 cases
that userspace has to suffer with:

1. specify one end of the stack with clone
2. specify the other end of the stack with clone (HP PA-RISC)
3. specify the base and size with clone2 (IA-64)

Portable code ends up with an icky #ifdef mess.

BTW, the extra stack info is also useful for other purposes.
It's information that could appear in /proc/*/maps data.
With an extra flag, thread stacks could be freed on thread exit
so that other threads don't have to babysit an exiting thread.
