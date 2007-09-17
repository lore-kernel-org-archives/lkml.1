Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbXIQHbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbXIQHbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 03:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbXIQHa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 03:30:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:14236 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbXIQHa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 03:30:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RnkuwfZHyGGYXbLUA0GmOBcr6h45wcEKfm2T/S/zvUl80e/xnlibPkQnhm4wN0L5fPKg5k+Nf421R8Lhemane4wNMI7S8UwnP4MJbQl3C/YOUuc8YlQ1Vo3ouh7HQdUBbI4aDUoqv1/x7cQeEpm2wzF0WLXMywIxS9YEhErD/xA=
Message-ID: <38b2ab8a0709170030k2b5dad5dja31edebf12ad9626@mail.gmail.com>
Date: Mon, 17 Sep 2007 09:30:54 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Ulrich Drepper" <drepper@gmail.com>
Subject: Re: x86_64: vsyscall vs vdso
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <a36005b50709161346t544d3927mfbca537c869c3c58@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0709161324p6841c1f9h6f9422b0e6c4b5cd@mail.gmail.com>
	 <a36005b50709161346t544d3927mfbca537c869c3c58@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ulrich,

Thanks for taking time to respond !

On 9/16/07, Ulrich Drepper <drepper@gmail.com> wrote:
> On 9/16/07, Francis Moreau <francis.moro@gmail.com> wrote:
>> I'm a bit puzzled because vdso doesn't seem to be used on my fedora 7:
>> I just compiled a trivial program which just call gettimeofday() and
>> ld.so resolves this call with vsyscall's gettimeofday.
>>
>> Now I'm wondering when vdso is used, could anybody give me a clue ?
>
> F7 was released before the vdso for x86_64 was upstream so you should
> not expect anything else.  F8 will use the available vdso.  This
> doesn't just happen magically, changes to libc are needed.
>

You're right. I don't know why I thought vdso was older...

>
>> Another question: is vdso going to replace vsyscall at all ? If so how
>> are statically programs going to be handled ?
>
> Unfortunately the vsyscalls cannot ever go completely away.
> Statically linked apps, the bane of progress, will need them.  There
> are also people updating kernels but not the user userland code.
>

Does that mean we'll need to keep 3 different implementations of gtod
in the kernel forever ?

> What we will have to do in future is to make vsyscalls configurable.
> Both a compile time option and a runtime option (perhaps also under
> control of SELinux) are likely needed.

I think signal trampolines will still need them too. So making
vsyscalls configurable doesn't seem to work, does it ?

I took a look to glibc-2.4 and it doesn't seem to use
__kernel_vsyscall vsyscall. Am I wrong ? If so could you point me
where it's used in the code ?

Another not so related question, hope you don't mind :)
I'm having hard time to understand how ld.so is working, specially the
dynamic symbol resolution after looking at the glibc code and reading
the ELF specification.
Do you know any others documents that could help ?

Thanks a lot.
-- 
Francis
