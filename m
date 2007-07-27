Return-Path: <linux-kernel-owner+w=401wt.eu-S1761767AbXG0CpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761767AbXG0CpP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 22:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbXG0CpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 22:45:04 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:26429 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbXG0CpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 22:45:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qRgsk2RYhh+PumXcGEHfMyszNIHHZIWuhRq3b3+jTFrNupMiCrxQanpZNTPz2Y5FXi4MQvMgwC0yuXnUigUdhWlmGj9TfiRnVaeH6Eg26MB9g07pPWA0J89TY4c1SZKkqkk0ELSQCvX91RNavAB0z2OjVTBeaxJntjhMdEZ90wM=
Message-ID: <824323160707261945n2e625beal486c7b1cfe91e01c@mail.gmail.com>
Date: Fri, 27 Jul 2007 10:45:00 +0800
From: "Jian-Xin Lai" <laijx03@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: wrong constraints "=g" at include/asm-i386/string.h, line 186?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46A8BBF2.5010406@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <824323160707260458h490e9ae5la44aabcfa413bba7@mail.gmail.com>
	 <46A8BBF2.5010406@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

But as we know, the kerword 'register' is only a suggestion. The
language specification does not force to put the 'register' variable
into a register.
Putting the variable onto stack does not violate anything, but the
assembler will fail.
I think the hack does not really work. THX.

2007/7/26, H. Peter Anvin <hpa@zytor.com>:
> Jian-Xin Lai wrote:
> > Hi,
> >
> > The kernel version is 2.6.20.7. In include/asm-i386/string.h, line 169~185:
> > static inline char * strrchr(const char * s, int c)
> > {
> > int d0, d1;
> > register char * __res;
> > __asm__ __volatile__(
> >        "movb %%al,%%ah\n"
> >        "1:\tlodsb\n\t"
> >        "cmpb %%ah,%%al\n\t"
> >        "jne 2f\n\t"
> >        "leal -1(%%esi),%0\n"                                    (*)
> >        "2:\ttestb %%al,%%al\n\t"
> >        "jne 1b"
> >        :"=g" (__res), "=&S" (d0), "=&a" (d1)               (**)
> >        :"0" (0),"1" (s),"2" (c)
> >        :"memory");
> > return __res;
> > }
> >
> > The 'lea' instruction needs a register here (*), but "g" (**) means
> > any registers, memory or immediate integer. Is it correct? If the
> > compiler do not place the __res into a register, the compilation will
> > fail. Should it be "r"?
> > Thank you very much.
> >
>
> Yes, it should be "r", and it looks like the author hacked around the
> fact they had the wrong constraints by using the "register" keyword on
> the variable declaration.
>
>        -hpa
>


-- 
Regards,
Lai Jian-Xin
