Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbZKTIpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbZKTIpH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 03:45:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbZKTIpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 03:45:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:37335 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbZKTIpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 03:45:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=jU54BWCBFgjI28ZlIn5Z17h2DjteH9rLY4XY+WKoNWe7swhkP2MtJc9fkQnZqfzycy
         UMBdjKyflTwsYl0J5PfNxNvd7UqO+vg+K/yQcYrvsEKOFPjXH5PPWjRwKONkhjJKJ1jh
         MPw/DbJNsEPxJuE7v5fxQ3CaEbhehuFeDzd1I=
Message-ID: <4B065712.4050202@gmail.com>
Date: Fri, 20 Nov 2009 09:45:06 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091117 SUSE/3.0.0-2.1 Thunderbird/3.0
MIME-Version: 1.0
To: Johnny Hung <johnny.hacking@gmail.com>
CC: kernelnewbies@nl.linux.org, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Subject: Re: How to move two valuables to x86 CPU register ebx, ecx by using
 AT&A 	inline asm.
References: <cb9ecdfa0911190150w4edbacdfp24a7069c618193f4@mail.gmail.com>
In-Reply-To: <cb9ecdfa0911190150w4edbacdfp24a7069c618193f4@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2009 10:50 AM, Johnny Hung wrote:
> Hi All:
>     I want to move two local valuables to x86 arch CPU ebx, ecx
> register and do outb cpu instruction by using AT&A inline asm in
> kernel driver.  The following code was I wrote but gcc report syntax
> error:
> ==
>     unsigned int val = 10;
>     unsigned int tmp = 5;
>     ....
>     __asm__ volatile ("movl %0, %%ebx"
>           "movl %1, %%ecx"
>           "outb $0x27, $0xb2"
>           :
>           :"r"(val), "r"(tmp)
>           :"%ebx", "%ecx"
>    );
> 
> Does anyone can point me out. Any reply is appreciated.

Why not just:
("outb $0x27, %%al" : : "a" (0xb2), "b"(val), "c" (tmp));
-- 
js
Faculty of Informatics, Masaryk University
Suse Labs, Novell
