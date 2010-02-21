Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab0BUWvM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 17:51:12 -0500
Received: from mail-px0-f184.google.com ([209.85.216.184]:39615 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab0BUWvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 17:51:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=c6l6tIZ9p+YH4OGfYGO92zeoucrkcb2vnvewQU8Bii1KBT2C7gN7XDoZj6gzt3KVaz
         Ie8ZZ1/0huHplvRVz/dXyZQicXGg5ZqgY33CWM02+fmQvj4iJtqAhdgMigXActW15YzT
         +Eo3o7KDai3+/zuklCzcZ+Q69bTd8VRZJqKmU=
MIME-Version: 1.0
In-Reply-To: <4B80CA55.3040402@zytor.com>
References: <4B80946D.1030503@gmail.com> <4B80C892.9000303@zytor.com>
	 <4B80CA55.3040402@zytor.com>
Date: Mon, 22 Feb 2010 09:51:09 +1100
Message-ID: <d66caabb1002211451s5a68565fue6096e17b99402f7@mail.gmail.com>
Subject: Re: x86 embedded - Problem getting past 'move compressed kernel 
	before decompression'
From: Graeme Russ <graeme.russ@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 21, 2010 at 4:53 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/20/2010 09:45 PM, H. Peter Anvin wrote:
>
> Make that:
>
>        asm volatile(
>                "movl   %2, %%ds\n" \
>                "movl   %2, %%es\n" \
>                "movl   %2, %%fs\n" \
>                "movl   %2, %%gs\n" \
>                "movl   %2, %%ss\n" \
>                "xorl   %ebp, %ebp\n" \
>                "xorl   %ebx, %ebx\n" \
>                "ljmpl  $0x10,$0x100000"
>         : : "S" (&boot_params), "D" (0), "r" (0x18));
>

Thanks Peter - I gave that a try but no luck. I am in the process of
writing some routines which will dump the contents of the registers
upon entering startup_32 and the relocation jump address prior to
the jump.

My assembler is a bit rusty, so it is taking a bit of time

What other information should I dump?

Regards,

Graeme
