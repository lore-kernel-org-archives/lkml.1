Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbZKWDOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbZKWDOh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 22:14:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756157AbZKWDOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 22:14:37 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:56268 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbZKWDOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 22:14:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Z+TVH8h3s4v1wTxRFzEm6WpnM+lysSLXR9tQSm1yw3BqiCJ/Wyghe8/1T0/e4m9rs4
         zG8lvoD11EXuwy177spFPXjNK8QRESrilKlWFS4QqgTc9TZWmYMhzJJZMexXGm/vBqVG
         Oh61gQN4MQR05yQJi7xWGi8BCYn/aXs93eadk=
MIME-Version: 1.0
In-Reply-To: <4B065712.4050202@gmail.com>
References: <cb9ecdfa0911190150w4edbacdfp24a7069c618193f4@mail.gmail.com>
	 <4B065712.4050202@gmail.com>
Date: Mon, 23 Nov 2009 11:14:42 +0800
Message-ID: <cb9ecdfa0911221914t78f7849h9f00c68420f63d14@mail.gmail.com>
Subject: Re: How to move two valuables to x86 CPU register ebx, ecx by using 
	AT&A inline asm.
From: Johnny Hung <johnny.hacking@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: kernelnewbies@nl.linux.org, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After testing:

# gcc inlineasm.c
inlineasm.c: Assembler messages:
inlineasm.c:7: Error: suffix or operands invalid for `out'
[root@debian-johnny] ~/workspace/test

# cat inlineasm.c
#include <stdio.h>

int main ()
{
    unsigned int val = 5, tmp = 10;
    asm volatile ("outb $0x27, %%al"
     :
     : "a" (0xb2), "b"(val), "c" (tmp)
    );
}

    It seems the source of outb instruction cannot be a constant. Is
there a AT&T instructions document for x86?

BRs, H. Johnny
> Why not just:
> ("outb $0x27, %%al" : : "a" (0xb2), "b"(val), "c" (tmp));
> --
> js
> Faculty of Informatics, Masaryk University
> Suse Labs, Novell
>
