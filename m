Return-Path: <linux-kernel-owner+w=401wt.eu-S1755908AbXGRFMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbXGRFMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 01:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbXGRFMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 01:12:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36340 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751746AbXGRFMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 01:12:42 -0400
Date: Tue, 17 Jul 2007 22:12:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland Dreier <rdreier@cisco.com>
cc: Jeff Garzik <jeff@garzik.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       chas@cmf.nrl.navy.mil, rolandd@cisco.com, dwmw2@infradead.org,
       gregkh@suse.de
Subject: Re: [git patches 1/2] warnings: attack valid cases spotted by
 warnings
In-Reply-To: <adabqeamjjs.fsf@cisco.com>
Message-ID: <alpine.LFD.0.999.0707172205270.27353@woody.linux-foundation.org>
References: <20070717214239.GF28448@devserv.devel.redhat.com>
 <ada8x9epuip.fsf@cisco.com> <469D3E66.3010502@garzik.org> <adamyxuo2w6.fsf@cisco.com>
 <adair8io2de.fsf@cisco.com> <alpine.LFD.0.999.0707171957300.27353@woody.linux-foundation.org>
 <adabqeamjjs.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jul 2007, Roland Dreier wrote:
> 
>  > Anyway, here's a totally untested cleanup that compiles but probably 
>  > doesn't work, because I didn't check that I did the right thing with all 
>  > the pointer arithmetic (ie when I change "wqe" to a real structure pointer 
>  > instead of just a "void *", maybe I left some pointer arithmetic around 
>  > that expected it to work as a byte pointer, but now really works on the 
>  > whole structure size instead).
> 
> Given that you took the time to do this, I'll get the patch into a
> working state and apply it.  And maybe split it into reviewable chunks
> while I'm at it ;)

Hey, I appreciate it, but I really do have to warn you that I did this all 
blind, and just meant for it to be a "I think this kind of direction is 
more productive" thing. I'm not going to guarantee that it works at all.

I spent more time than I really wanted to on actually making sure the end 
result even compiles (quite often, I'm perfectly happy to just send out 
pseudo-code to indicate what I think should be done), but maybe I 
shouldn't have done that, just so that nobody thinks that the patch is 
necessarily going to *work*.

In other words, it's a totally mindless cleanup and re-factorization. It 
*may* work, but quite frankly, I did it just for that one email, and spent 
the absolutly minimum possible time thinking about it. As a result, I 
really think it needs some serious looking over.

I also think that my new "handle_raddr_seg()" function could itself be 
split up into subfunctions along the "switch()" subcases.

So not only wasn't it meant to be guaranteed correct, but it wasn't even 
meant to be seen as the best possible final situation: it could be - and 
should be - factored out even more (and the same goes for a lot of the 
other functions in that file that I didn't really look at, just glance and 
notice that they have some of the same problem patterns).

		Linus
