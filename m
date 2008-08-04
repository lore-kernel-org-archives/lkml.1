Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854AbYHDKTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbYHDKTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 06:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbYHDKTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 06:19:06 -0400
Received: from qb-out-0506.google.com ([72.14.204.237]:26630 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbYHDKTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 06:19:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UwS5l5xRe1suILiSael5JZHtHptjhYX0voOtEH0GjUB5OWradRJViRLalqkEaTL3cd
         oXN6Gp8Dvp/BgWVgTCKPYkYEb8rjcnjX1ssVXUuV3J9lNe0A5S+00/3ljNVf+LicnNUv
         vxB8aSpoi3f7CmtUkdJ6MOBANxkwpH9SffW8Y=
Message-ID: <9debc4410808040319i3358a916v3b6cd534c0a0802c@mail.gmail.com>
Date: Mon, 4 Aug 2008 15:49:01 +0530
From: "Maxin John" <maxin.john@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: regarding mprotect() implementation in 2.6.26 kernel
Cc: linux-kernel@vger.kernel.org, ak@muc.de, mtk.manpages@gmail.com,
       shields@tembel.org, hirofumi@mail.parknet.co.jp
In-Reply-To: <4891D58E.1070308@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9debc4410807310315n4da5beafh853a71f532420e9a@mail.gmail.com>
	 <9debc4410807310324m4a76aaf5s253242e5cc2bb130@mail.gmail.com>
	 <4891D58E.1070308@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jeremy,

              Thank you very much for the information and I am sorry
for my delayed reply.

        As per the patch created by Mr. hirofumi for the 2.5.26 kernel
which is described in
http://www.kernel.org/pub/linux/kernel/v2.5/ChangeLog-2.5.26 ,
and
http://linux.bkbits.net:8080/linux-2.6/?PAGE=gnupatch&REV=1.403.147.22
, the mprotect system call will set errno as ENOMEM instead of
EFAULT.

But the latest man page(man-pages-3.05) of mprotect still contains
information regarding EFAULT. The SuSv3 specification of mprotect also
doesn't say anything about EFAULT in the mprotect() details. The
following patch removes the information regarding EFAULT from the
mprotect man page.

diff -Naur man-pages-3.05/man2/mprotect.2
man-pages-3.05_modified/man2/mprotect.2
--- man-pages-3.05/man2/mprotect.2      2008-07-23 19:42:13.000000000 +0530
+++ man-pages-3.05_modified/man2/mprotect.2     2008-08-04
15:34:33.400869088 +0530
@@ -87,9 +87,6 @@
 to mark it
 .BR PROT_WRITE .
 .TP
-.B EFAULT
-The memory cannot be accessed.
-.TP
 .B EINVAL
 \fIaddr\fP is not a valid pointer,
 or not a multiple of the system page size.
~

  Please advise me if this information is irrelevant or wrong.

Thanks and Regards,

Maxin B. John
Bangalore, India.


On Thu, Jul 31, 2008 at 8:39 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Maxin John wrote:
>> Dear Christoph Hellwig,
>>
>> ( I guess you are the right person to ask this question ?)
>>
>> The POSIX.2 specification of mprotect() says:
>>
>> errorno should be set as ENOMEM if the addresses in the range [addr,
>> (addr + len)] are invalid for the address space of a process, or
>> specify one or more pages which are not mapped.
>>
>> However, in the mprotect implementation  (asmlinkage long
>> sys_mprotect(unsigned long start, size_t len, unsigned long prot)) in
>> linux/mm/mprotect.c file, if we call mprotect() with start as NULL and
>> len as 0, mprotect() returns 0 and it is not setting the errono.The
>> following code confirms this behaviour.
>>
>
> Address 0 is a valid process address.  And you've set the length to
> zero, so you technically haven't referred to any memory at all, so it
> doesn't matter what the address is.
>
>    J
>
