Return-Path: <linux-kernel-owner+w=401wt.eu-S1752233AbXBFQx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbXBFQx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 11:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932085AbXBFQx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 11:53:59 -0500
Received: from smtp.osdl.org ([65.172.181.24]:40456 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbXBFQx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 11:53:58 -0500
Date: Tue, 6 Feb 2007 08:53:37 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
In-Reply-To: <1170755101.29759.960.camel@pmac.infradead.org>
Message-ID: <Pine.LNX.4.64.0702060841440.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org> 
 <20070205084523.GA21858@elte.hu>  <1170682488.29759.795.camel@pmac.infradead.org>
  <20070205155627.GA8354@elte.hu>  <1170692539.29759.856.camel@pmac.infradead.org>
  <20070205162635.GA755@elte.hu> <20070205163152.GA2464@elte.hu> 
 <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org> 
 <1170710272.29759.894.camel@pmac.infradead.org> 
 <Pine.LNX.4.64.0702051322580.8424@woody.linux-foundation.org> 
 <1170711587.29759.909.camel@pmac.infradead.org> 
 <Pine.LNX.4.64.0702051345380.8424@woody.linux-foundation.org> 
 <1170712393.29759.925.camel@pmac.infradead.org> 
 <Pine.LNX.4.64.0702051409110.8424@woody.linux-foundation.org> 
 <20070205143110.fca62b57.randy.dunlap@oracle.com> 
 <Pine.LNX.4.64.0702051502370.8424@woody.linux-foundation.org> 
 <1170717694.29759.941.camel@pmac.infradead.org> 
 <Pine.LNX.4.64.0702051525320.8424@woody.linux-foundation.org>
 <1170755101.29759.960.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Feb 2007, David Woodhouse wrote:
> 
> It's a bad example because it's not relevant to the 'select' question,
> and you're trying to use it as a straw man; assigning to me a belief I
> just don't have.

It *is* relevant.

Why are you ignoring the ATA example? Which is exactly the same thing? 
(And where we do the right thing - we just "select SCSI")

Why are you ignoring the USB example - which is exactly the same thing 
(and where we do the *wrong* thing: we "depend on SCSI" and then we have 
about 5 lines of warning both around USB and around SCSI and documentation 
just to say that USB needs it!)

> Perhaps I haven't spoken carefully enough. I mean to argue that being
> nice is good -- but that we shouldn't do so in a way which _costs_ those
> who use the system most.

It costs you nothing but arguing. 

> No, you really aren't paying attention. You CAN DO IT WITHOUT SELECT.

No, I was paying attention. You seem to just be obtuse on purpose.

WE WANT TO BE NICE.
 - the firewall example was not an example of 'select', but of the "we 
   want to be nice". But you simply DID NOT GET IT.
 - the USB and SATA examples are *also* examples of "we want to be nice", 
   and hell yeah, you need 'select' to do them. Claiming anything else is 
   just stupid.

So: are you stupid, or do you just refuse to even think about it?

> My point is not that we shouldn't be helpful. My point is that 'select'
> is the _wrong_ way to be 'helpful', because that's a PITA for other
> people.

It's a PITA just because you don't listen, and ignore everything I say.

In other words, the problem is *you*.

The problem is NOT "select".

People have even pointed out that you don't even have to create new tools. 
Use menuconfig and "?", which apparently already tells you what the 
dependencies are, and why you can't turn something off..

And yes, I just tried. I couldn't turn SCSI off in menuconfig, so I 
pressed '?', and at the end it does actually say:

	Selected by: ATA && BLOCK && (!M32R && !M68K || BROKEN) && (!SUN4 || BROKEN)

Not hugely readable, and I'm sure it could be improved a lot. 

And yes, I certainly think that it would be a good idea if there would be 
other tools that told you too.  The Kconfig engine *internally* already 
knows all this, of course, so all the hard work has already effectively 
been done, it's just not *shown*.

So you should just face it: the problem *really* isn't 'select'. 

		Linus
