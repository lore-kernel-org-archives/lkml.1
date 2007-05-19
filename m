Return-Path: <linux-kernel-owner+w=401wt.eu-S1763830AbXESLz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763830AbXESLz0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 07:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758209AbXESLzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 07:55:15 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:2271 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757846AbXESLzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 07:55:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=apSBjqR48lzmjDOPWjV+5XMzQl5sKNt6oMq4Qren8X2OiXL1LXP/qHV5YACAr0RX72DA1EnYaEzvKkrnA27AV1Vs8lVnLRHyDioegYZfID1J1vVwS2838PF2BaOW2WJbAD5M+R/D3dDpGk1UZIEEoJoZpIbpN2AUiQdBmvwmy24=
Message-ID: <f69849430705190455m4d62835fx9aed5a17df69c805@mail.gmail.com>
Date: Sat, 19 May 2007 04:55:12 -0700
From: "kernel coder" <lhrkernelcoder@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: system call implementation for x86_64
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I'm trying to implement a system call for x86_64. Mine processor is
dual core opetron.There is very little material on web for
implementing system calls for x86_64 processor for 2.6 series kernel.I
tried to implement a new system call by observing the existing
implementation but to no success.Following are files names and changes
made.

//////////////////////////////////////////////////
file-> include/asm-x86_64/unistd.h

#define __NR_newcall        273
__SYSCALL(__NR_newcall, sys_newcall)

#define __NR_syscall_max __NR_newcall

//////////////////////////////////////////////////
file-> include/linux/syscalls.h

asmlinkage unsigned long sys_newcall(char __user *buf);

/////////////////////////////////////////////
file--> fs/read_write.c

asmlinkage unsigned long sys_newcall(char __user * buf){

     printk("new system call \n");
     ret 0;
}

EXPORT_SYMBOL_GPL(sys_write)


Please let me know where i'm doing wrong .Following is program which
is calling mine system call


#include <stdlib.h>
#include <stdio.h>
#include <sys/unistd.h>
#include <sys/syscall.h>

  long int ret;
   int num = 243;
  char  buffer=[20];

int main() {


  asm ("syscall;"
       : "=a" (ret)
       : "0" (num),
         "D" (buffer),
      );
 return ret;
}

When i call this ,nothing gets printed in file /var/log/messages.Am i
missing something ?

Actually i wana pass a pointer to kernel from user space.Later on data
will be copied to that memory location .i am thinking of using
copy_to_user for copying data.Buffer passed through system call will
be used by kernel function as circular ring.And portions of this ring
will get updated frequently even after system call has returned.

Is there any better way to do this?
