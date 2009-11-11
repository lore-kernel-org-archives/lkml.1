Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbZKKJf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbZKKJf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 04:35:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbZKKJf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 04:35:57 -0500
Received: from 1wt.eu ([62.212.114.60]:51006 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbZKKJf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 04:35:56 -0500
Date: Wed, 11 Nov 2009 10:35:24 +0100
From: Willy Tarreau <w@1wt.eu>
To: Pavel Machek <pavel@ucw.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091111093524.GF560@1wt.eu>
References: <20091110105642.215804e0@lxorguk.ukuu.org.uk> <4AF99E04.8080704@zytor.com> <20091110172454.3c4481f2@lxorguk.ukuu.org.uk> <4AF9B5AB.5010800@zytor.com> <4AF9C3EF.6000705@redhat.com> <4AF9C6AB.8080006@zytor.com> <20091110201602.GA26633@1wt.eu> <20091110205445.GB1407@ucw.cz> <20091110211259.GD26633@1wt.eu> <20091111080313.GB24569@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091111080313.GB24569@elf.ucw.cz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 09:03:13AM +0100, Pavel Machek wrote:
> 
> > (...)
> > > > CMOV/NOPL are rarely used, thus have no reason to cause a massive
> > > > performance drop, but are frequent enough (at least cmov) for almost
> > > 
> > > *One* CMOV in the inner loop will make your performance go down 20x.
> > 
> > yes, just like with emulated FPU or trapped unaligned accesses. It's
> > just like flying fishes. They exist but they aren't the most common
> > ones. If people encounter these cases on a specific program, then
> > they just have to recompile it if it is a problem. At least they
> > don't rebuild the whole distro. And once again, I've been using
> > cmpxchg/bswap emulation for years on my i386 without feeling any
> > need for a rebuild, and CMOV emulation for years now on my mini-itx 
> 
> And did you set cpu family to 6 for your 386?

No, not at all !

> That's the part I was objecting most. Yes, you can emulate, but
> emulation is very bad for performance... so don't lie about cpu
> family.

That's the point I agree with you, I don't like this setting either.
I don't want to incite applications to use features that are emulated.
However I think that allowing applications run when they don't/can't
perform the check is useful.

> (Imagine application that has NOPL in inner loop, for performance
> reasons. You want to use version _without_ the NOPL on processors that
> lack it.)

Exactly. Same for MMX, 3DNOW, SSE* and such.

> So... I don't like instruction emulation, but can live with it. But
> don't lie about supported instructions in /proc as original patch did.

100% agreed !

Regards,
Willy

