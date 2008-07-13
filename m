Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbYGMS7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbYGMS7Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 14:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbYGMS7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 14:59:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46961 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923AbYGMS7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 14:59:17 -0400
Message-ID: <487A5082.6050704@firstfloor.org>
Date: Sun, 13 Jul 2008 20:59:14 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Elias Oltmanns <eo@nebensachen.de>,
       =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86_64: fix delayed signals
References: <20080710215039.2A143154218@magilla.localdomain> <20080711054605.GA17851@elte.hu> <alpine.LFD.1.10.0807111031310.2936@woody.linux-foundation.org> <87mykn2sos.fsf@basil.nowhere.org> <alpine.LFD.1.10.0807121030260.2875@woody.linux-foundation.org> <4879CCFD.70208@firstfloor.org> <alpine.LFD.1.10.0807131017180.2959@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807131017180.2959@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sun, 13 Jul 2008, Andi Kleen wrote:
>> At least the original report was about Ctrl-C only versus Ctrl-Z.
> 
> Yes, and I explained why.
> 
>> I see the problem regularly myself that Ctrl-C doesn't work,
>> but Ctrl-Z+kill does (although I unfortunately cannot
>> reproduce it on demand).
> 
> There's no way you _can_ reproduce it.

That's not how I remember it from seeing it here, but ok it's possible my
memory is fuzzy and I'm misremembering. I'll continue to watch it.

While the bit about color ls (which I use here) catching signals was
also interesting I wouldn't expect the color ls to take longer to
process Ctrl-C even if it hits user space because it shouldn't
do anything block here (unless the terminal is in flow control,
but is unlikely)

> Two facts:
> 
>  - ^Z and ^C are both going to be equally fast if they aren't blocked.
> 
>    This is just how things are. They are handled by the same codepaths.

Yes I know that, that is why the behavior always puzzled me, because
it apparently contradicts that. I think I know reasonably well how
signals work, but cannot say the same about tty, so my guess was
in that area. But we'll see.

-Andi

