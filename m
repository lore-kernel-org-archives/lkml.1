Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbZKTGs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbZKTGs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 01:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbZKTGs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 01:48:27 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:43665 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbZKTGsW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 01:48:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aMzn8BsMPTKx9M9zOSIuSrKdkwUeKF4gJDvWUxB+NP5pM/AaYLy4TPRryT4tbYEo2w
         7GQ7hugfyMyJjk8qBgFXvw4E1rzNpsuj2Hzd9+9RSXTwZ/Y1pRBA5Ul9Z5O4Gnc74asr
         lOXXT66SIT8DElm0X3vv+Ktu7EvEK6Fz7x9aw=
MIME-Version: 1.0
In-Reply-To: <cb9ecdfa0911190150w4edbacdfp24a7069c618193f4@mail.gmail.com>
References: <cb9ecdfa0911190150w4edbacdfp24a7069c618193f4@mail.gmail.com>
Date: Fri, 20 Nov 2009 14:48:28 +0800
Message-ID: <2375c9f90911192248h368fa79di1761e7b4c479b25b@mail.gmail.com>
Subject: Re: How to move two valuables to x86 CPU register ebx, ecx by using 
	AT&A inline asm.
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Johnny Hung <johnny.hacking@gmail.com>
Cc: kernelnewbies@nl.linux.org, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 5:50 PM, Johnny Hung <johnny.hacking@gmail.com> wrote:
> Hi All:
>    I want to move two local valuables to x86 arch CPU ebx, ecx
> register and do outb cpu instruction by using AT&A inline asm in
> kernel driver.  The following code was I wrote but gcc report syntax
> error:

You must mean AT&T.

> ==
>    unsigned int val = 10;
>    unsigned int tmp = 5;
>    ....
>    __asm__ volatile ("movl %0, %%ebx"

You need to put "\n\t" in the end of each asm statement.

>          "movl %1, %%ecx"
>          "outb $0x27, $0xb2"


This is wrong, 'outb' instruction cann't accept both of
its operands as constants, IIRC.

>          :
>          :"r"(val), "r"(tmp)
>          :"%ebx", "%ecx"
>   );
>
> Does anyone can point me out. Any reply is appreciated.

Regards.
