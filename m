Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbZEYTDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbZEYTDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 15:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbZEYTDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 15:03:13 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:50898 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbZEYTDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 15:03:12 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Date: Mon, 25 May 2009 14:03:09 -0500
User-Agent: KMail/1.9.9
Cc: Harald Welte <HaraldWelte@viatech.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200905221139.26941.lkml@morethan.org> <200905241332.39946.lkml@morethan.org> <4A1995F0.6040602@zytor.com>
In-Reply-To: <4A1995F0.6040602@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905251403.11786.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun May 24 2009, H. Peter Anvin wrote:
> Michael S. Zick wrote:
> > 
> > Note: I have seem to recall that newer gcc's optimizer presume 
> > that the flags register is preserved across asm - 
> > It didn't use to do that - but there is now a "cc" to deal with
> > that - Have not yet audited for that, but it is high on my list.
> > 
> 
> I am pretty sure that's false... if it was true we'd have failures all
> over the kernel.
> 

No information on the above (yet) - but you gotta love this one: ;)

Programmer authors code specifying that the subtraction be done
prior to the addition to avoid over-flow conditions;

GCC's optimizer, in its great wisdom, codes in the overflow case:
( the case of finding the characters used/free in a ring buffer )

extern int diff_umask(int mask, int *cnt1, int *cnt2) 
{ return (((mask - *cnt1) + *cnt2) & mask); }

/**
 * gcc -O2 -S -fomit-frame-pointer difftest.c
 *
         .file   "difftest.c"
        .text
        .p2align 4,,15
.globl diff_umask
        .type   diff_umask, @function
diff_umask:
        movl    12(%esp), %eax
        movl    4(%esp), %ecx
        movl    (%eax), %edx
        leal    (%ecx,%edx), %eax
        movl    8(%esp), %edx
        subl    (%edx), %eax
        andl    %ecx, %eax
        ret
        .size   diff_umask, .-diff_umask
        .ident  "GCC: (Debian 4.3.2-1.1) 4.3.2"
        .section        .note.GNU-stack,"",@progbits
*/

Note: That is not the compiler version I am building my kernels with.

Don't blame me, I didn't write the compiler. ;)

Mike
> 	-hpa
> 


