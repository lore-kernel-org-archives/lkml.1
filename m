Return-Path: <linux-kernel-owner+w=401wt.eu-S933806AbXGZPVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933806AbXGZPVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 11:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758776AbXGZPV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 11:21:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59315 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757414AbXGZPV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 11:21:28 -0400
Message-ID: <46A8BBF2.5010406@zytor.com>
Date: Thu, 26 Jul 2007 08:21:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jian-Xin Lai <laijx03@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: wrong constraints "=g" at include/asm-i386/string.h, line 186?
References: <824323160707260458h490e9ae5la44aabcfa413bba7@mail.gmail.com>
In-Reply-To: <824323160707260458h490e9ae5la44aabcfa413bba7@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jian-Xin Lai wrote:
> Hi,
> 
> The kernel version is 2.6.20.7. In include/asm-i386/string.h, line 169~185:
> static inline char * strrchr(const char * s, int c)
> {
> int d0, d1;
> register char * __res;
> __asm__ __volatile__(
>        "movb %%al,%%ah\n"
>        "1:\tlodsb\n\t"
>        "cmpb %%ah,%%al\n\t"
>        "jne 2f\n\t"
>        "leal -1(%%esi),%0\n"                                    (*)
>        "2:\ttestb %%al,%%al\n\t"
>        "jne 1b"
>        :"=g" (__res), "=&S" (d0), "=&a" (d1)               (**)
>        :"0" (0),"1" (s),"2" (c)
>        :"memory");
> return __res;
> }
> 
> The 'lea' instruction needs a register here (*), but "g" (**) means
> any registers, memory or immediate integer. Is it correct? If the
> compiler do not place the __res into a register, the compilation will
> fail. Should it be "r"?
> Thank you very much.
> 

Yes, it should be "r", and it looks like the author hacked around the
fact they had the wrong constraints by using the "register" keyword on
the variable declaration.

	-hpa
