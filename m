Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbXGGVtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbXGGVtk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 17:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750814AbXGGVtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 17:49:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:50682 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbXGGVtc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 17:49:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [2.6 patch] re-add required code to include/asm-v850/unistd.h
Date: Sat, 7 Jul 2007 23:41:15 +0200
User-Agent: KMail/1.9.6
Cc: Miles Bader <miles@gnu.org>, linux-kernel@vger.kernel.org
References: <20070707211124.GN3492@stusta.de>
In-Reply-To: <20070707211124.GN3492@stusta.de>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707072341.16389.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+lWXId9WNR1zrVNO1a4MaZJ5a46mvQFv+zH9S
 6aWIEmv184z+spO3fBk1m/pdVbebAKM6iV23gZ8nlmpKqEqe90
 zD6NF5K4oMjrk654nJozA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 July 2007, Adrian Bunk wrote:
> 
> Commit f5738ceed46782aea7663d62cb6398eb05fc4ce0 removed a bit too much, 
> resulting in the following compile error:

Sorry about the trouble this has caused you.

>  #ifdef __KERNEL__
>  
> +/* Syscall protocol:
> +   Syscall number in r12, args in r6-r9, r13-r14
> +   Return value in r10
> +   Trap 0 for `short' syscalls, where all the args can fit in function
> +   call argument registers, and trap 1 when there are additional args in
> +   r13-r14.  */
> +
> +#define SYSCALL_NUM    "r12"
> +#define SYSCALL_ARG0   "r6"
> +#define SYSCALL_ARG1   "r7"
> +#define SYSCALL_ARG2   "r8"
> +#define SYSCALL_ARG3   "r9"
> +#define SYSCALL_ARG4   "r13"
> +#define SYSCALL_ARG5   "r14"
> +#define SYSCALL_RET    "r10"
> +
> +#define SYSCALL_SHORT_TRAP     "0"
> +#define SYSCALL_LONG_TRAP      "1"
> +
> +/* Registers clobbered by any syscall.  This _doesn't_ include the syscall
> +   number (r12) or the `extended arg' registers (r13, r14), even though
> +   they are actually clobbered too (this is because gcc's `asm' statement
> +   doesn't allow a clobber to be used as an input or output).  */
> +#define SYSCALL_CLOBBERS       "r1", "r5", "r11", "r15", "r16", \
> +                               "r17", "r18", "r19"
> +
> +/* Registers clobbered by a `short' syscall.  This includes all clobbers
> +   except the syscall number (r12).  */
> +#define SYSCALL_SHORT_CLOBBERS SYSCALL_CLOBBERS, "r13", "r14"
> +

Wouldn't it be more appropriate to just open-code the contents of these
macros in the place where they are used?

Even better probably would be to convert the v850 kernel_thread code
to call do_fork directly, like most other architectures do.

	Arnd <><
