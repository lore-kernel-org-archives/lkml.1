Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735AbYJOTUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbYJOTUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 15:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753565AbYJOTUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 15:20:04 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:35270 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752952AbYJOTUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 15:20:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=uwTBxWZF7iiduDnonXTl9FxnmjJcBhoJzn1BvG4iMfwImQxmjgNhRdql80w9hRlS0n7F4TQIICXsN2ucUYIDZg5tLC5+irywsWWEpq/W9BZRoAAAR65THS42lZU1IkrHXdCtx1pWkW2Zn2WYHU7J0dS8PdX5MdEFESWgFRl+ebU=  ;
X-YMail-OSG: SeWqoh4VM1mbS_hbhBLkms.KZmYPOmSPK3O9.yxACisBKYuArweXNd.z7BDa.v6Rjcjm8izC64NMh1wQlmMY0XKglolIm83S4m0hhlaOoOA6HIqy1KqsY.khfKXbdfYe0goho61Q950W.WBnTx6TiVBiSJ6xZW60.JGcmuS1
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc] SLOB memory ordering issue
Date: Thu, 16 Oct 2008 06:19:53 +1100
User-Agent: KMail/1.9.5
Cc: Matt Mackall <mpm@selenic.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <200810160334.13082.nickpiggin@yahoo.com.au> <200810160535.51586.nickpiggin@yahoo.com.au> <alpine.LFD.2.00.0810151139320.3288@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810151139320.3288@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810160619.53510.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 October 2008 05:43, Linus Torvalds wrote:
> On Thu, 16 Oct 2008, Nick Piggin wrote:
> > Actually, there are surprisingly huge number of them. What I would be
> > most comfortable doing, if I was making a kernel to run my life support
> > system on an SMP powerpc box, would be to spend zero time on all the
> > drivers and whacky things with ctors and just add smp_wmb() after them
> > if they are not _totally_ obvious.
>
> WHY?

I guess I wouldn't bother with your kernel. I was being hypothetical.
Can you _prove_ no code has a bug due specifically to this issue?


> THIS HAS NOTHING TO DO WITH CONSTRUCTORS!
>
> If the driver is using locking, there is no memory ordering issues
> what-so-ever.
>
> And if the driver isn't using locking, IT IS BROKEN.

Did you read the anon_vma example? It's broken if it assumes the objects
coming out of its slab are always "stable".


> It's that simple. Why do you keep bringing up non-issues?

Why are you being antagonistic and assuming I'm wrong instead of
considering you mistunderstand me, maybe I'm not a retard? I am bad
at explaining myself, but I'll try once more.


> What matters is not constructors. Never has been. Constructors are
> actually very rare, it's much more common to do
>
> 	ptr = kmalloc(..)
> 	.. initialize it by hand ..
>
> and why do you think constructors are somehow different? They're not.

I think they might be interpreted or viewed by the caller as giving
a "stable" object. It is rather more obvious to a caller that it has
previous unordered stores if it is doing this
 	ptr = kmalloc(..)
 	.. initialize it by hand ..

I haven't dealt much with constructors myself so I haven't really
had to think about it. But I'm sure I could have missed it and been
fooled.

If you still don't agree, then fine; if I find a bug I'll send a patch.
I don't want to keep arguing.


> What matter is how you look things up on the other CPU's. If you don't use
> locking, you use some lockless thing, and then you need to be careful
> about memory ordering.
>
> And quite frankly, if you're a driver, and you're trying to do lockless
> algorithms, you're just being crazy. You're going to have much worse bugs,
> and again, whether you use constructors or pink elephants is going to be
> totally irrelevant.
>
> So why do you bring up these totally pointless things? Why do you bring up
> drivers? Why do you bring up constructors? Why, why, why?

I'll try to keep them to myself in future.

Thanks,
Nick
