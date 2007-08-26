Return-Path: <linux-kernel-owner+w=401wt.eu-S934863AbXHZBx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934863AbXHZBx5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 21:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933724AbXHZBxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 21:53:48 -0400
Received: from smtpout.mac.com ([17.250.248.176]:50142 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933670AbXHZBxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 21:53:47 -0400
In-Reply-To: <9a8748490708251736k5b751998yee72abdc8c4c1b53@mail.gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com> <5ebfb93eca0dd43cf17876e643079cbcfeb3111c.1187912217.git.jesper.juhl@gmail.com> <200708241141.06358.vda.linux@googlemail.com> <Pine.LNX.4.64.0708240642500.18301@localhost.localdomain> <9a8748490708251527n26cc2065n5b8716bd7f65e252@mail.gmail.com> <Pine.LNX.4.64.0708251956380.29507@localhost.localdomain> <9a8748490708251728h51d51092r11a3562ceb63b2f9@mail.gmail.com> <Pine.LNX.4.64.0708252021070.8721@localhost.localdomain> <9a8748490708251736k5b751998yee72abdc8c4c1b53@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <51189954-4301-4C83-91F2-26B376D0DDD7@mac.com>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH 09/30] mtd: Don't cast kmalloc() return value in drivers/mtd/maps/pmcmsp-flash.c
Date: Sat, 25 Aug 2007 21:52:51 -0400
To: Jesper Juhl <jesper.juhl@gmail.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 25, 2007, at 20:36:32, Jesper Juhl wrote:
> On 26/08/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
>> technically, nothing.  but if you're not going to use kcalloc()  
>> when you're explicitly allocating an array of identical objects  
>> (that you want zero-filled, as a bonus), then what's the point of  
>> ever having defined a kcalloc() routine in the first place?
>>
> I wonder a bit about that myself...
>
> I have found some other issues in that function that I want to fix,  
> so I'll be respinning the patch as a patch series instead - and why  
> not; I'll just go with kcalloc() and see what the maintainers have  
> to say, it's not like I personally care much one way or the other.

I think the original reasoning behind kcalloc() was that it did some  
extra input checking, so that if the product of the two numbers  
overflowed, it would fail with NULL instead of allocating  
insufficient space.  In the kernel it doesn't matter in practice  
since you MUST have additional checking on the size of allocated  
memory anyways, not even considering the fact that >PAGE_SIZE  
allocations are probably going to fail with decent frequency regardless.

Cheers,
Kyle Moffett


