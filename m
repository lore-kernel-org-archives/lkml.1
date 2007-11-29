Return-Path: <linux-kernel-owner+w=401wt.eu-S1761653AbXK2AFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761653AbXK2AFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 19:05:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758325AbXK2AFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 19:05:41 -0500
Received: from smtp.ono.com ([62.42.230.12]:15829 "EHLO resmaa02.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754866AbXK2AFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 19:05:40 -0500
Date: Thu, 29 Nov 2007 01:05:31 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: void* arithmnetic
Message-ID: <20071129010531.22b3a71f@werewolf>
X-Mailer: Claws Mail 3.1.0cvs43 (GTK+ 2.12.2; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all...

Since begin of the ages the build of the nvidia driver says things like
this:

include/asm/compat.h:210: warning: pointer of type 'void *' used in arithmetic

There are several of this warnings. The code in question for this example
is:

static __inline__ void __user *compat_alloc_user_space(long len)
{
    struct pt_regs *regs = task_pt_regs(current);
    return (void __user *)regs->rsp - len;
}

As this is dealing with mem blocks, I suppose it's counting in bytes, so
we could do something like:

   return (void __user *)((u8*)regs->rsp - len);

so the arithmetic knows how to inc/dec for each unity...
I think the warning is correct and that void* arithmetic is undefined in C,
isn't it ?

TIA

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux 2.6.23-jam01 (gcc 4.2.2 20070909 (4.2.2-0.RC.1mdv2008.0)) SMP PREEMPT
09 F9 11 02 9D 74 E3 5B D8 41 56 C5 63 56 88 C0
