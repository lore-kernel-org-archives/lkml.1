Return-Path: <linux-kernel-owner+w=401wt.eu-S1754366AbYGGOBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbYGGOBG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 10:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbYGGOAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 10:00:55 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:53404 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbYGGOAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 10:00:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eUfZaISJeSB75R5+EYVqX2Xqh5B+YvAhM97I3TzjaKNLw7R4CZkRLbTE2m3ju0dtKa
         eNzCWR2rTn/ls9ELv14JNsjbGRm+Jk/EhUhcWZNwTIjJ+joPanSWCC0HXnzQAUZyuaXi
         VNpo/YZNm6CFQv1cMLkGEEu7KgTCCuH4bhDcs=
Message-ID: <fb82a8210807070700u4f191bfaq57df57c293567e4c@mail.gmail.com>
Date: Mon, 7 Jul 2008 10:00:50 -0400
From: "Jinkai Gao" <mickeygjk@gmail.com>
To: "Jan Engelhardt" <jengelh@medozas.de>
Subject: Re: Suggestion: LKM should be able to add system call for itself
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.1.10.0807071131010.8248@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fb82a8210807062209t6cfe3e46m50a11b577f0540e7@mail.gmail.com>
	 <alpine.LNX.1.10.0807071131010.8248@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2008 at 5:35 AM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> On Monday 2008-07-07 07:09, Jinkai Gao wrote:
>
>>LKM(loadable kernel module) was first introduced for drivers. Users
>>rarely need to talk to the modules directly. If does, several methods
>>are available now, such as /proc file, interruption, etc. However,
>>these interfaces are predefined, which makes the communication between
>>user space and kernel space quite restricted.
>
> And that is good -- I certainly do not want something to step out of
> bounds by accident or intention.
>
>>Of course, for driver modules, these mechanisms are enough. But as
>>long as it is called Loadable Kernel Module instead of Loadable Kernel
>>Driver, I think it should be able to do more than that. For example,
>>LSM(linux security module),most of which(selinux, apparmor, etc.) use
>>policy files as their core. Users write policy files, LSM make access
>>control decision based on the files. Seems like users don't need to
>>talk to LSM directly. But what if user want to temporarily disable a
>>role or capability he is holding ? Not much he can do, isn't
>>it(although nothing is impossible, making a new system call makes much
>>more sense).
>
> I do not see what a syscall will buy over a "switch file" in procfs or
> sysfs.
>
>>So The LKM should be able to define its own user interface
>>by adding new system call for itself.
>
> And the point is? Why cannot it use, say, a character device?

Please refer to my reply to Bart.

>>And actually,  it is not hard to
>>implement such kind of dynamic system call table as I thought it
>>through.
>
> It is. You do not know what number your syscall will get. And if
> you knew, it might just happen that this specific number is taken
> in the next iteration in the Linux kernel.

You are right. So we can use ascii name instead of number to identify
the system call. Kernel will match the function with the name.To have
backward compatibility, number should still be supported. Yes, it is
not as easy as I thought, but as long as it is valuable and doable, we
should have a try, right?

>>There was time when people can modify the sys_call_table[],which has
>>been forbidden since it was realized as extremly dangrous operation.
>>But thing can be implemented in a safe way. Kernel may provide
>>registration function like this:
>>
>>typedef int (*syscall_func_t)(struct pt_regs regs);
>>int syscall_register(char* name, syscall_func_t sys_call);
>>
>>So that modules can add their own system call without affect the
>>original sys_call_table[]. And since the system call number will be
>>unpredictable, either we let users know the number,
>
> Letting the user know does not help you. Binaries are already compiled
> with the syscall numbers in, and recompiling is not feasible even
> if you could.

I was wrong, number is useless here.

> It is pointless.
>



-- 
Syracuse University
Jinkai Gao
