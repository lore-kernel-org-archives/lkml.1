Return-Path: <linux-kernel-owner+w=401wt.eu-S1756999AbZKKIDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbZKKIDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 03:03:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756904AbZKKIDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 03:03:15 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37332 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbZKKIDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 03:03:14 -0500
Date: Wed, 11 Nov 2009 09:03:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Willy Tarreau <w@1wt.eu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091111080313.GB24569@elf.ucw.cz>
References: <4AF9435F.2070103@redhat.com>
 <20091110105642.215804e0@lxorguk.ukuu.org.uk>
 <4AF99E04.8080704@zytor.com>
 <20091110172454.3c4481f2@lxorguk.ukuu.org.uk>
 <4AF9B5AB.5010800@zytor.com>
 <4AF9C3EF.6000705@redhat.com>
 <4AF9C6AB.8080006@zytor.com>
 <20091110201602.GA26633@1wt.eu>
 <20091110205445.GB1407@ucw.cz>
 <20091110211259.GD26633@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110211259.GD26633@1wt.eu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> (...)
> > > CMOV/NOPL are rarely used, thus have no reason to cause a massive
> > > performance drop, but are frequent enough (at least cmov) for almost
> > 
> > *One* CMOV in the inner loop will make your performance go down 20x.
> 
> yes, just like with emulated FPU or trapped unaligned accesses. It's
> just like flying fishes. They exist but they aren't the most common
> ones. If people encounter these cases on a specific program, then
> they just have to recompile it if it is a problem. At least they
> don't rebuild the whole distro. And once again, I've been using
> cmpxchg/bswap emulation for years on my i386 without feeling any
> need for a rebuild, and CMOV emulation for years now on my mini-itx 

And did you set cpu family to 6 for your 386?

That's the part I was objecting most. Yes, you can emulate, but
emulation is very bad for performance... so don't lie about cpu
family.

(Imagine application that has NOPL in inner loop, for performance
reasons. You want to use version _without_ the NOPL on processors that
lack it.)

So... I don't like instruction emulation, but can live with it. But
don't lie about supported instructions in /proc as original patch did.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
