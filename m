Return-Path: <linux-kernel-owner+w=401wt.eu-S1752265AbXJ1IEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbXJ1IEo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 04:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbXJ1IEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 04:04:30 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:25528 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbXJ1IE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 04:04:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Vnm00qU3lpfxoYtywpyLFDXfQ6mSQJOheJd3lkQaNfgO6bbCP9D2uvYQJ8XCirTYquIEbH9hln1jXmQCzLt38yFckOh5QspUAyUbbO9fyE3Z4w0/zlM70dje3Se3nvcIgeU6a10lVud2xHaSBWDQGHN7tfzVzbZqMGs3o9xqmU0=
Message-ID: <8bd0f97a0710280104k4784c7afo11b9d803e963ed13@mail.gmail.com>
Date: Sun, 28 Oct 2007 03:04:27 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: struct user . u_ar0
Cc: linux-arch@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <4723DDDD.8050900@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4723DDDD.8050900@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/07, H. Peter Anvin <hpa@zytor.com> wrote:
> I recently noticed that all architectures appear to have an entry n
> struct user called u_ar0:
>
>    struct user_pt_regs * u_ar0;  /* Used by gdb to help find the values
> for */
>                                  /* the registers. */
>
> In all cases, u_ar0 is a pointer type, although the type of pointer
> varies with the architecture.
>
> However, under no conditions does this field ever contain a pointer
> value!  It is set by the a.out code and its derivatives as an offset,
> not a pointer value (there are a total of four references in the kernel,
> in arch/{m68k,blackfin}/kernel/process.c, arch/x86/ia32/ia32_aout.c and
> fs/binfmt_aout.c -- they are all functionally identical and write-only):
>
> dump.u_ar0 = (void *)(((unsigned long)(&dump.regs)) - ((unsigned
> long)(&dump)));
>
> Any reason to *NOT* change this field to "unsigned long"?  <asm/user.h>,
> where struct user is defined, is not exported to userspace in any
> architecture as far as I can tell, although <linux/user.h>, which just
> contains #include <asm/user.h>, *is* exported (clearly a bug.)

Blackfin doesnt support a.out, so it may be easier to just change it
to "reserved2" (assuming this structure is part of our ABI), or delete
it (assuming the structure is internal to the kernel only).
-mike
