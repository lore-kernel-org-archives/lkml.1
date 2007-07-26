Return-Path: <linux-kernel-owner+w=401wt.eu-S1759717AbXGZL7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759717AbXGZL7K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 07:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbXGZL7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 07:59:00 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:10925 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbXGZL67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 07:58:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ku/nP8EHMF0M79BuJQrOxYom2DH4kWJgV8+oT3eh7R8/e63s7BPPwNGT6+mHPZHiUTQ9BEf08nwYkDjRu568IoDGLxXnLIqnTypGmnk4C67rO+kkM8eCgvII0Lt8k0MTx/8GAnS3D1o0d5i/GzpWfrI3vvglUwa+DFJzZn67VOQ=
Message-ID: <824323160707260458h490e9ae5la44aabcfa413bba7@mail.gmail.com>
Date: Thu, 26 Jul 2007 19:58:58 +0800
From: "Jian-Xin Lai" <laijx03@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: wrong constraints "=g" at include/asm-i386/string.h, line 186?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The kernel version is 2.6.20.7. In include/asm-i386/string.h, line 169~185:
static inline char * strrchr(const char * s, int c)
{
int d0, d1;
register char * __res;
__asm__ __volatile__(
        "movb %%al,%%ah\n"
        "1:\tlodsb\n\t"
        "cmpb %%ah,%%al\n\t"
        "jne 2f\n\t"
        "leal -1(%%esi),%0\n"                                    (*)
        "2:\ttestb %%al,%%al\n\t"
        "jne 1b"
        :"=g" (__res), "=&S" (d0), "=&a" (d1)               (**)
        :"0" (0),"1" (s),"2" (c)
        :"memory");
return __res;
}

The 'lea' instruction needs a register here (*), but "g" (**) means
any registers, memory or immediate integer. Is it correct? If the
compiler do not place the __res into a register, the compilation will
fail. Should it be "r"?
Thank you very much.

-- 
Regards,
Lai Jian-Xin
