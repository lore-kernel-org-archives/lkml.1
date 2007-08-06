Return-Path: <linux-kernel-owner+w=401wt.eu-S934017AbXHFTRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934017AbXHFTRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933848AbXHFTQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:16:27 -0400
Received: from 1wt.eu ([62.212.114.60]:1220 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760890AbXHFTQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:16:26 -0400
Date: Mon, 6 Aug 2007 21:13:32 +0200
From: Willy Tarreau <w@1wt.eu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Segher Boessenkool <segher@kernel.crashing.org>,
       Axel Reinhold <axel@freakout.de>, linux-kernel@vger.kernel.org
Subject: Re: Kernel Bug in 2.4.35 when compiled gcc>=4.2.0 and -march=c3
Message-ID: <20070806191332.GB12131@1wt.eu>
References: <200708050856.l758u4ou031651@bongo.freakout.de> <20070805154337.GA4716@1wt.eu> <44e819389656d1465e70ce2e99fb7640@kernel.crashing.org> <20070806132658.GE10999@1wt.eu> <46B75CD0.7080408@zytor.com> <20070806174536.GA12131@1wt.eu> <46B761EC.2050803@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B761EC.2050803@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2007 at 11:01:16AM -0700, H. Peter Anvin wrote:
> Willy Tarreau wrote:
> > 
> > I'm well aware of that, even in the example I wrote to reproduce the issue
> > and posted to gcc's bugzilla, I clearly have one function prototype and a
> > separate asm statement which contained a label with the function's name.
> > 
> > So in my opinion, the code above is not buggy. It's dirty (though I did
> > not find how to produce the equivalent in a different manner).
> > 
> 
> Well, top-level assembly is usually nasty.

That's what I noticed :-)
I did not even know that was supported!

> Setting the section in the assembly statement as you said is probably the
> only thing you *can* do.

What made me hesitate is that I'm not 100% sure that all those sections
are used only in .text everywhere they are used. Maybe some of them
sometimes appear in .text.init, so finally I preferred not to play
dangerous games with this. In fact, I prefer the risk to break gcc-4.2
to the risk of breaking everything.

> I don't think there is any requirement that top-level assembly
> statements get the section set to .text on their behalf.

I don't think either. Other people certainly rely on such a feature
to be able to switch their sections by hand using one asm statement.

At least my fix looks unintrusive enough for me and works, so I'll
stick to it for now. And if something finally breaks, it will only
be gcc 4, the last one supported, so the less likely to affect well
established toolchains.

Regards,
Willy

