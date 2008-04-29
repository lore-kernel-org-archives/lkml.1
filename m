Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbYD2LHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbYD2LHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 07:07:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbYD2LGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 07:06:55 -0400
Received: from 1wt.eu ([62.212.114.60]:3533 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbYD2LGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 07:06:54 -0400
Date: Tue, 29 Apr 2008 13:06:38 +0200
From: Willy Tarreau <w@1wt.eu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Helge Hafting <helge.hafting@aitel.hist.no>,
       "H. Peter Anvin" <hpa@kernel.org>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
Message-ID: <20080429110638.GG1473@1wt.eu>
References: <20080428154023.GU2813@cs181133002.pp.htv.fi> <20080428230524.GK8474@1wt.eu> <48167A07.4000305@kernel.org> <20080429050605.GA27875@1wt.eu> <20080429072911.GA28059@cs181133002.pp.htv.fi> <20080429081423.GD30507@1wt.eu> <4816E4FD.5060605@aitel.hist.no> <20080429100934.GB1473@1wt.eu> <20080429104216.GC19269@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080429104216.GC19269@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 01:42:16PM +0300, Adrian Bunk wrote:
> On Tue, Apr 29, 2008 at 12:09:34PM +0200, Willy Tarreau wrote:
> > On Tue, Apr 29, 2008 at 11:06:05AM +0200, Helge Hafting wrote:
> > > >Well, I accidentally used a freshly installed laptop running mandriva 2008.
> > > >I was typing in a terminal inside KDE (I don't know the program name, sort
> > > >of an xterm, but with huge borders all around). I made a typo in a word and
> > > >typed in a "é" (e acute). Pressing backspace to fix it showed me that I
> > > >remove more chars than typed. I tried again. Pressing this letter 5 times,
> > > >then 10 times backspace. I removed 5 chars from the prompt. I suspect that
> > > >if I had used some chars with wider encoding (eg 4 bytes), I could have
> > > >removed as many... Clearly those tools are not ready.
> > > >  
> > > So don't use that particular tool
> > 
> > It was not my machine, and had you been there, you would have heard me call
> > it names !
> > 
> > > and/or file a bug with the maintainer. :-)
> > 
> > It's too easy to impose crappy designs to end-users and tell them that if
> > that does not work they have to file a bug. There are a minimal set of
> > things that must be tested before shipping. Seeing that the default
> > terminal emulator in KDE on Mandriva 2008 is configured in UTF-8 and does
> > not properly render it simply makes me sick. This is broken by design and
> > even distros trying to get it working for years still can't cope with it.
> > There must be a reason.
> 
> I can reproduce your problem in a plain xterm when setting LANG=en_US
> (most likely the same problem can occur with other non UTF-8 settings).

possibly they broke it when forcing support for variable length ?

> In this case I'm actually more surprised that the character is displayed 
> correctly than that you have to type backspace twice.

It's not that I *had* to type it twice. But I *could* type it twice, and
the first one removed the character, the second one the prompt.

> Any kind of charset mixing is highly problematic (which is also why my 
> patch was attached compressed), so if you disable UTF-8 anywhere in a 
> modern distribution problems are somehow expected (it could also be a 
> bug in Mandrivas default settings, but that would really surprise me).

No, it was not disabled at all. I had to type in a command for a
co-worker who just did a default install the day before, and typed a
typo which I wanted to fix.

> > Unicode yes, UTF-8 no. UTF-8 is a compressed encoding of unicode.
> > That's as silly as if you had to replace your terminals to read
> > native gzip, and expect them as well as all the tools to work
> > properly!
> 
> It's not a compressed encoding, it's a variable-length encoding.
> 
> Besides the size advantages one main advantage of UTF-8 is that ASCII is 
> valid UTF-8. This means that for the ASCII source code in the kernel it 
> doesn't matter whether it's treated as ASCII or UTF-8, and no conversion 
> was needed.
> 
> You can't get this property with a fixed-size Unicode encoding.

I don't agree. If you refuse character-set mixing, there's no problem.
Bit 7 of first char == 1 ? => full text is 32 bit.

Willy

