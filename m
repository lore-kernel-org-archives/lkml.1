Return-Path: <linux-kernel-owner+w=401wt.eu-S1754805AbYGGFJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbYGGFJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 01:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750922AbYGGFJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 01:09:34 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:15455 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbYGGFJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 01:09:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=snTEJMSGsVsstqkJD0JuQ3eDqTzOgPIkI01pnMqh9urZkdOE5yjBDzP64y5IB93Xcx
         WSALtHjecvbN8tqWpo318nLLKb+TVukFcAR7+uEtqipnXiUPXyoEFgo4R01oDexBEHci
         gMo0h3pN+j2xNp3qXSPSUjKV835vIN2fpPpzk=
Message-ID: <fb82a8210807062209t6cfe3e46m50a11b577f0540e7@mail.gmail.com>
Date: Mon, 7 Jul 2008 01:09:30 -0400
From: "Jinkai Gao" <mickeygjk@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Suggestion: LKM should be able to add system call for itself
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LKM(loadable kernel module) was first introduced for drivers. Users
rarely need to talk to the modules directly. If does, several methods
are available now, such as /proc file, interruption, etc. However,
these interfaces are predefined, which makes the communication between
user space and kernel space quite restricted. Although we can manage
to deliver the information or commands between them, the
implementation tends to be ugly.

Of course, for driver modules, these mechanisms are enough. But as
long as it is called Loadable Kernel Module instead of Loadable Kernel
Driver, I think it should be able to do more than that. For example,
LSM(linux security module),most of which(selinux, apparmor, etc.) use
policy files as their core. Users write policy files, LSM make access
control decision based on the files. Seems like users don't need to
talk to LSM directly. But what if user want to temporarily disable a
role or capability he is holding ? Not much he can do, isn't
it(although nothing is impossible, making a new system call makes much
more sense).

Above is to demonstrate that LKM is extension to kernel, and the
system calls should be able to extend as long as the kernel is
extending. So The LKM should be able to define its own user interface
by adding new system call for itself. And actually,  it is not hard to
implement such kind of dynamic system call table as I thought it
through.

There was time when people can modify the sys_call_table[],which has
been forbidden since it was realized as extremly dangrous operation.
But thing can be implemented in a safe way. Kernel may provide
registration function like this:

typedef int (*syscall_func_t)(struct pt_regs regs);
int syscall_register(char* name, syscall_func_t sys_call);

So that modules can add their own system call without affect the
original sys_call_table[]. And since the system call number will be
unpredictable, either we let users know the number, or we generate the
corresponding library function to make users' life easier.

This is my personal opinion, any criticism or correction is welcomed.
Thanks

---
Syracuse University
Jinkai Gao
