Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbYGGJfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbYGGJfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 05:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbYGGJfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 05:35:21 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:50638 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbYGGJfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 05:35:19 -0400
Date: Mon, 7 Jul 2008 11:35:18 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Jinkai Gao <mickeygjk@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Suggestion: LKM should be able to add system call for itself
In-Reply-To: <fb82a8210807062209t6cfe3e46m50a11b577f0540e7@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0807071131010.8248@fbirervta.pbzchgretzou.qr>
References: <fb82a8210807062209t6cfe3e46m50a11b577f0540e7@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2008-07-07 07:09, Jinkai Gao wrote:

>LKM(loadable kernel module) was first introduced for drivers. Users
>rarely need to talk to the modules directly. If does, several methods
>are available now, such as /proc file, interruption, etc. However,
>these interfaces are predefined, which makes the communication between
>user space and kernel space quite restricted.

And that is good -- I certainly do not want something to step out of
bounds by accident or intention.

>Of course, for driver modules, these mechanisms are enough. But as
>long as it is called Loadable Kernel Module instead of Loadable Kernel
>Driver, I think it should be able to do more than that. For example,
>LSM(linux security module),most of which(selinux, apparmor, etc.) use
>policy files as their core. Users write policy files, LSM make access
>control decision based on the files. Seems like users don't need to
>talk to LSM directly. But what if user want to temporarily disable a
>role or capability he is holding ? Not much he can do, isn't
>it(although nothing is impossible, making a new system call makes much
>more sense).

I do not see what a syscall will buy over a "switch file" in procfs or
sysfs.

>So The LKM should be able to define its own user interface
>by adding new system call for itself.

And the point is? Why cannot it use, say, a character device?

>And actually,  it is not hard to
>implement such kind of dynamic system call table as I thought it
>through.

It is. You do not know what number your syscall will get. And if
you knew, it might just happen that this specific number is taken
in the next iteration in the Linux kernel.

>There was time when people can modify the sys_call_table[],which has
>been forbidden since it was realized as extremly dangrous operation.
>But thing can be implemented in a safe way. Kernel may provide
>registration function like this:
>
>typedef int (*syscall_func_t)(struct pt_regs regs);
>int syscall_register(char* name, syscall_func_t sys_call);
>
>So that modules can add their own system call without affect the
>original sys_call_table[]. And since the system call number will be
>unpredictable, either we let users know the number,

Letting the user know does not help you. Binaries are already compiled
with the syscall numbers in, and recompiling is not feasible even
if you could.

It is pointless.
