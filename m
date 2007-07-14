Return-Path: <linux-kernel-owner+w=401wt.eu-S932184AbXGNW7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184AbXGNW7q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 18:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765047AbXGNW7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 18:59:30 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:38616 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764820AbXGNW73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 18:59:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ukEb+ZjWmOCzZsHGc5dbgjLRlaHYcShCgjskHQCMQS5biQ3qkfHG1BuetzfkEuAe6loOaM2WP4347PU8EZR/vW5HnLBdv44znEGwIOyNqrdwbjwR6O5yeMhICOoO8tceqBtEbGZ4vpDHcg1c2WWwjEti2IDKBPonh7LG58vn9pk=
Message-ID: <8bd0f97a0707141559s4880c86dtf74dc6c73476ad5f@mail.gmail.com>
Date: Sat, 14 Jul 2007 18:59:28 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Olaf Hering" <olaf@aepfle.de>
Subject: Re: [PATCH] remove PAGE_SIZE from headers_install
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070714213412.GA10196@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070714205709.GA9478@aepfle.de> <46993C59.1030902@zytor.com>
	 <20070714213412.GA10196@aepfle.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/14/07, Olaf Hering <olaf@aepfle.de> wrote:
> On Sat, Jul 14, H. Peter Anvin wrote:
> > Olaf Hering wrote:
> > > Declare PAGE_SIZE as getpagesize() for userspace.
> > > PAGE_SIZE is used in resource.h and shm.h
> >
> > I would think it would be better to not define it at all.  Several
> > architectures already don't have PAGE_SIZE visible to userspace in any way.
>
> i386 has it, so everyone uses it.

not anymore ... it's broken too many other architectures so anything
that matters has switched off of it

> asm/user.h uses it for NBPG, which appears in gdb configure scripts.
> Maybe it doesnt trigger there because the sysconf SC_* macros match.

the sourceware tree (binutils/gdb/etc...) bend over backwards to get a
usable definition so not having NBPG available is fine ... there's one
thing left which needs fixing and i have a patch that i need to commit
for that

> other places where asm/page.h is used:
> util-linux configure scripts, strace, xorg-11, and alot more.
> Have to check if they really need it.

those three packages you quote here i know have been fixed in the
latest versions
-mike
