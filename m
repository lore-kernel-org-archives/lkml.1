Return-Path: <linux-kernel-owner+w=401wt.eu-S1757086AbXH1NRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086AbXH1NRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 09:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbXH1NRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 09:17:32 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:24885 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbXH1NRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 09:17:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=gzhfmFqRY2j5JUkhdq4FEVshTYZU/so3ujuSUWQxy8tdNJf/e3B1BGLxNLCpC+mjhgbhS6jKvWb8VFYmjSPemOy8ZzpYnqbYjb3++Yo/lE6XoS8bTaw1faa0FdRhvz3DUbxdnYSJf6xAxJ21GMfD+jc2v7ZFrbEyTppG+Y7xoyE=
Message-ID: <46D42057.9090507@gmail.com>
Date: Tue, 28 Aug 2007 15:17:11 +0200
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: arch_align_stack() seems useless
References: <46D2DADF.8060505@gmail.com> <20070827071413.736e3dcb@laptopd505.fenrus.org>
In-Reply-To: <20070827071413.736e3dcb@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arjan,

Arjan van de Ven wrote:
> arch_align_stack aligns, on x86, within a 2 page range (this is for
> cache coloring).

OK, but for elf case this seems useless since the top of the stack is
already randomized.

It seems that the randomization stuff (top of the stack + stack
pointer inside a page) belongs to the elf binary format whereas it
could have been part of exec.c. Are there any reasons ?

> The other thing you missed is that arch_align_stack()
> is called in 2 locations, binfmt_elf.c is the primary location for
> inside-the-page randomization.
> 

Well not really because for mips case, we have:

	$ git grep ELF_PLATFORM include/asm-mips
	include/asm-mips/elf.h:#define ELF_PLATFORM  (NULL)

So on mips, the stack pointer won't get the inside the page
randomization. Is that correct ?

If so, I'm wondering why this randomization must depend on that string
to be defined. I must admit that I'm not sure how it's used. I guess
it's used by ld.so and it could be set to "mips" for now...

thanks
		Franck
