Return-Path: <linux-kernel-owner+w=401wt.eu-S1753669Ab0ALNyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab0ALNyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 08:54:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895Ab0ALNyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 08:54:05 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:59891 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab0ALNyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 08:54:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=LRqKkOjhyvizRXzbIRqgpCooWnN9b0PTuaHMfOKY0mJn75iramtA5rIzTQruk8xr+Q
         KuzSJyd+sh93+PqqgsJjXekqwsIDji3TRUj9cSF1LTNOSRrKEvp8LWHxsMBpDr4WDQeR
         sR4z6ri6s08xqt4twNEIKHUg8dQj19jUvkSwI=
MIME-Version: 1.0
Date: Tue, 12 Jan 2010 14:53:10 +0100
Message-ID: <1dec3f771001120553n61e281acjf82086f85e03425@mail.gmail.com>
Subject: add a new system call
From: mojtaba <kernelppc@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[please cc kernelppc@gmail.com  in your replies]

Dear all,

I need to add a new system call to the linux kernel.

These are the linux information:
Linux ubuntu-desktop 2.6.32.3 #5 SMP Mon Jan 11 16:56:27 CET 2010 i686
GNU/Linux

I am working on kernel 2.6.32.

These are all the changes I did:

1- adding "	.long sys_mycall" to the end of
"arch/x86/kernel/syscall_table_32.S"

2- adding
Code:
#define __NR_mycall 242
__SYSCALL(__NR_mycall, sys_mycall)
#undef __NR_syscalls
#define __NR_syscalls 243
to the "include/asm-generic/unistd.h"

3- adding
asmlinkage long sys_mycall(char * fname, void * params);
to the end of "/include/linux/syscalls.h"

4-modifying the linux Makefile
core-y	 += kernel/ mm/ fs/ ipc/ security/ crypto/ block/ mycall/

5- adding mycall folder to kernel source and mycall.c and the
corresponding Makefile in it:
Code:
#include <linux/kernel.h>
#include <linux/syscalls.h>
SYSCALL_DEFINE2(mycall, char __user *, fname,void __user *,params)
{
printk("I am here !!";
return 10;
}
Now after building and installing the new kernel, I want to test the
system call with this code:

Code:
#include<stdio.h>
#include <errno.h>
#include<linux/unistd.h>
#include <sys/syscall.h>

#define __NR_mycall 242

long mycall(char * fname, void * params )
{
return syscall(__NR_mycall, fname, params);
}

int main(void)
{
int tmp=10;	
int er=0;	
char * chp= (char *) &tmp;
void * vp= (void *) &tmp;
printf("%d\n", er=mycall(chp,vp));
if( er < 0 ) {
printf( "Error: %d, %s\n", errno, strerror( errno ) );
}
}
Unfortunately, the code prints this:
-1
Error: 3, No such process

And I have no idea what the problem is!

Is there any body who can help me?

Thank you and best regards,
Mojtaba
