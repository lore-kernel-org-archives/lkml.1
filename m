Return-Path: <linux-kernel-owner+w=401wt.eu-S1753596AbZHaSO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbZHaSO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 14:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbZHaSO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 14:14:58 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:35530 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbZHaSO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 14:14:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=aewj8ObqmxdZlWwN5i5iTQevtlKdgKFGoAt14jV3qFndcx08K6caWaneybgkZAF9Fe
         evTCdgadbEvLWwWhgRhlwf9pdpmi/ttxfhh4ExExpR89r1znuHEwzyzA1fr7lNZ9UcTB
         MY3DRuXNqsIjNqT3+hnY8nxRdPglj8S5OgB9g=
MIME-Version: 1.0
In-Reply-To: <20090831123010.GA2368@infradead.org>
References: <4A9B759B.7020401@msgid.tls.msk.ru>
	 <20090831123010.GA2368@infradead.org>
Date: Mon, 31 Aug 2009 20:14:58 +0200
Message-ID: <64bb37e0908311114t4a3cefc3v8ea5092e1558c578@mail.gmail.com>
Subject: Re: xfs compat_ioctl?
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Michael Tokarev <mjt@tls.msk.ru>,
       Linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 2:30 PM, Christoph Hellwig<hch@infradead.org> wrote:
> On Mon, Aug 31, 2009 at 11:02:51AM +0400, Michael Tokarev wrote:
>> Hello!
>>
>> I tried to resize an xfs filesystem on 64bit 2.6.30 kernel
>> using 32bit userland, and that does not work, in dmesg I see:
>>
>> ioctl32(xfs_growfs:24426): Unknown cmd fd(3) cmd(400c586e){t:'X';sz:12} arg(ffa56df4) on /mnt
>> ioctl32(xfs_growfs:24427): Unknown cmd fd(3) cmd(400c586e){t:'X';sz:12} arg(ff991254) on /mnt
>>
>> so apparently there's no compat_ioctl layer for these ioctls.
>>
>> Are there any plans to add these? :)
>
> Are you sure you're testing 2.6.30?  The copat ioctls were added in
> 2.6.28.

On a slightly related note: I also have a system with a 32bit userland
and a 64bit kernel.
After switching to the 64bit kernel, xfs_fsr was no longer working,
but that was caused by the then still missing compat ioctls.

Today I retried it, but it still fails:
XFS_IOC_SWAPEXT failed: ino=<number>: Invalid argument

Looking at the compat code SWAPEXT looks somewhat suspicious:

fs/xfs/linux-2.6/xfs_ioctl32.h defines XFS_IOC_SWAPEXT_32, but I can't
find a single place where this is used.
And in the big switch of xfs_compat_ioctl() the value XFS_IOC_SWAPEXT
is surrounded by contants that all end in 32.

I don't have any experience with the linux ioctl code, I only read
fs/xfs/linux-2.6/xfs_ioctl32.c, but for my untrained eye it looks like
there is a _32 missing.

Or am I misreading this completely?

Torsten
