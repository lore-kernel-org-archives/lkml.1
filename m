Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840Ab0ALPvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab0ALPvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 10:51:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865Ab0ALPvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 10:51:10 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:36764 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab0ALPvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 10:51:08 -0500
Date: Tue, 12 Jan 2010 23:52:57 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: mojtaba <kernelppc@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: add a new system call
Message-ID: <20100112155257.GG3925@hack>
References: <1dec3f771001120553n61e281acjf82086f85e03425@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1dec3f771001120553n61e281acjf82086f85e03425@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 02:53:10PM +0100, mojtaba wrote:
>[please cc kernelppc@gmail.com  in your replies]
>
>Dear all,
>
>I need to add a new system call to the linux kernel.
>
>These are the linux information:
>Linux ubuntu-desktop 2.6.32.3 #5 SMP Mon Jan 11 16:56:27 CET 2010 i686
>GNU/Linux
>
>I am working on kernel 2.6.32.
>
>These are all the changes I did:
>
>1- adding "	.long sys_mycall" to the end of
>"arch/x86/kernel/syscall_table_32.S"
>
>2- adding
>Code:
>#define __NR_mycall 242
>__SYSCALL(__NR_mycall, sys_mycall)
>#undef __NR_syscalls
>#define __NR_syscalls 243
>to the "include/asm-generic/unistd.h"
>
>3- adding
>asmlinkage long sys_mycall(char * fname, void * params);
>to the end of "/include/linux/syscalls.h"
>
>4-modifying the linux Makefile
>core-y	 += kernel/ mm/ fs/ ipc/ security/ crypto/ block/ mycall/
>
>5- adding mycall folder to kernel source and mycall.c and the
>corresponding Makefile in it:
>Code:
>#include <linux/kernel.h>
>#include <linux/syscalls.h>
>SYSCALL_DEFINE2(mycall, char __user *, fname,void __user *,params)
>{
>printk("I am here !!";
>return 10;
>}


This is not what you did, you can't pass compiling here, since you are
missing ')'...

BTW, You can make a diff to show what you have changed.

>Now after building and installing the new kernel, I want to test the
>system call with this code:
>
>Code:
>#include<stdio.h>
>#include <errno.h>
>#include<linux/unistd.h>
>#include <sys/syscall.h>
>
>#define __NR_mycall 242
>
>long mycall(char * fname, void * params )
>{
>return syscall(__NR_mycall, fname, params);
>}
>
>int main(void)
>{
>int tmp=10;	
>int er=0;	
>char * chp= (char *) &tmp;
>void * vp= (void *) &tmp;
>printf("%d\n", er=mycall(chp,vp));
>if( er < 0 ) {
>printf( "Error: %d, %s\n", errno, strerror( errno ) );
>}
>}
>Unfortunately, the code prints this:
>-1
>Error: 3, No such process
>
>And I have no idea what the problem is!
>
>Is there any body who can help me?
>
>Thank you and best regards,
>Mojtaba
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 
