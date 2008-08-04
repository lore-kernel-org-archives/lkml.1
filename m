Return-Path: <linux-kernel-owner+w=401wt.eu-S1753860AbYHDKeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbYHDKeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 06:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752529AbYHDKeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 06:34:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:58142 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbYHDKeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 06:34:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kb1MrVn80W/FfO4rzG0mUeYjpenLOzYEt85ozXd5vrwwc93M8shdB9YZiJZ9PR3D9f
         rHIB/KuCRjZDFhuaHHBRHQg3SWa0sNfyQU7i9O/HIFFJssQYptuuwgWKIbctWMR7o/w+
         Os9lSlzpDWBEFFC/T3OBFgdl2/0DeGW3acBuA=
Message-ID: <cfd18e0f0808040334p67b2c9f8g586fa984f6c96e55@mail.gmail.com>
Date: Mon, 4 Aug 2008 12:34:14 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Maxin John" <maxin.john@gmail.com>
Subject: Re: regarding mprotect() implementation in 2.6.26 kernel
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       ak@muc.de, mtk.manpages@gmail.com, shields@tembel.org,
       hirofumi@mail.parknet.co.jp
In-Reply-To: <9debc4410808040319i3358a916v3b6cd534c0a0802c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9debc4410807310315n4da5beafh853a71f532420e9a@mail.gmail.com>
	 <9debc4410807310324m4a76aaf5s253242e5cc2bb130@mail.gmail.com>
	 <4891D58E.1070308@goop.org>
	 <9debc4410808040319i3358a916v3b6cd534c0a0802c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo Maxin,

On Mon, Aug 4, 2008 at 12:19 PM, Maxin John <maxin.john@gmail.com> wrote:
> Dear Jeremy,
>
>              Thank you very much for the information and I am sorry
> for my delayed reply.
>
>        As per the patch created by Mr. hirofumi for the 2.5.26 kernel
> which is described in
> http://www.kernel.org/pub/linux/kernel/v2.5/ChangeLog-2.5.26 ,
> and
> http://linux.bkbits.net:8080/linux-2.6/?PAGE=gnupatch&REV=1.403.147.22
> , the mprotect system call will set errno as ENOMEM instead of
> EFAULT.
>
> But the latest man page(man-pages-3.05) of mprotect still contains
> information regarding EFAULT.

Yes, that text looks to be in error.

> The SuSv3 specification of mprotect also
> doesn't say anything about EFAULT in the mprotect() details. The
> following patch removes the information regarding EFAULT from the
> mprotect man page.

Before I apply this...  Did you check what was the situation in 2.4 kernels?

Cheers,

Michael


> diff -Naur man-pages-3.05/man2/mprotect.2
> man-pages-3.05_modified/man2/mprotect.2
> --- man-pages-3.05/man2/mprotect.2      2008-07-23 19:42:13.000000000 +0530
> +++ man-pages-3.05_modified/man2/mprotect.2     2008-08-04
> 15:34:33.400869088 +0530
> @@ -87,9 +87,6 @@
>  to mark it
>  .BR PROT_WRITE .
>  .TP
> -.B EFAULT
> -The memory cannot be accessed.
> -.TP
>  .B EINVAL
>  \fIaddr\fP is not a valid pointer,
>  or not a multiple of the system page size.
> ~
>
>  Please advise me if this information is irrelevant or wrong.
>
> Thanks and Regards,
>
> Maxin B. John
> Bangalore, India.
>
>
> On Thu, Jul 31, 2008 at 8:39 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>> Maxin John wrote:
>>> Dear Christoph Hellwig,
>>>
>>> ( I guess you are the right person to ask this question ?)
>>>
>>> The POSIX.2 specification of mprotect() says:
>>>
>>> errorno should be set as ENOMEM if the addresses in the range [addr,
>>> (addr + len)] are invalid for the address space of a process, or
>>> specify one or more pages which are not mapped.
>>>
>>> However, in the mprotect implementation  (asmlinkage long
>>> sys_mprotect(unsigned long start, size_t len, unsigned long prot)) in
>>> linux/mm/mprotect.c file, if we call mprotect() with start as NULL and
>>> len as 0, mprotect() returns 0 and it is not setting the errono.The
>>> following code confirms this behaviour.
>>>
>>
>> Address 0 is a valid process address.  And you've set the length to
>> zero, so you technically haven't referred to any memory at all, so it
>> doesn't matter what the address is.
>>
>>    J
>>
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
