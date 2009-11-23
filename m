Return-Path: <linux-kernel-owner+w=401wt.eu-S1751523AbZKWFno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbZKWFno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 00:43:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbZKWFnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 00:43:43 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:46947 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbZKWFnn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 00:43:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UnV/akFvva7BsdWKdtUCCxTXVqEGGunC1L0IwUEqd105S9KdiI8Tmz4hAZFC0BM2VQ
         cLhLsdvJyrO2dsfMubwKJy9K23tODke9fDwY2owo86hoWa3Q/c0O8Ue3myISeeXb6pgN
         q6CzK44tQ88oaXW9rG9/VXyXrwlPWfA5R7PeY=
MIME-Version: 1.0
In-Reply-To: <cb9ecdfa0911221914t78f7849h9f00c68420f63d14@mail.gmail.com>
References: <cb9ecdfa0911190150w4edbacdfp24a7069c618193f4@mail.gmail.com>
	 <4B065712.4050202@gmail.com>
	 <cb9ecdfa0911221914t78f7849h9f00c68420f63d14@mail.gmail.com>
Date: Mon, 23 Nov 2009 00:43:47 -0500
Message-ID: <73c1f2160911222143j196fac7cqf0464c4ad9c35cfc@mail.gmail.com>
Subject: Re: How to move two valuables to x86 CPU register ebx, ecx by using 
	AT&A inline asm.
From: Brian Gerst <brgerst@gmail.com>
To: Johnny Hung <johnny.hacking@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, kernelnewbies@nl.linux.org,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 22, 2009 at 10:14 PM, Johnny Hung <johnny.hacking@gmail.com> wrote:
> After testing:
>
> # gcc inlineasm.c
> inlineasm.c: Assembler messages:
> inlineasm.c:7: Error: suffix or operands invalid for `out'
> [root@debian-johnny] ~/workspace/test
>
> # cat inlineasm.c
> #include <stdio.h>
>
> int main ()
> {
>    unsigned int val = 5, tmp = 10;
>    asm volatile ("outb $0x27, %%al"
>     :
>     : "a" (0xb2), "b"(val), "c" (tmp)
>    );
> }
>
>    It seems the source of outb instruction cannot be a constant. Is
> there a AT&T instructions document for x86?

In AT&T syntax, the source register comes first.  So it should be
"outb %%al, $0x27", assuming that 0x27 is the port number you are
trying to write to.

--
Brian Gerst
