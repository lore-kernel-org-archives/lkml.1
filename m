Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178AbYANJRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbYANJRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 04:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbYANJRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 04:17:24 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:53085 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562AbYANJRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 04:17:23 -0500
Date: Mon, 14 Jan 2008 10:17:28 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] __cpuinitconst and __devinitconst
Message-ID: <20080114091728.GA6674@uranus.ravnborg.org>
References: <47873D11.76E4.0078.0@novell.com> <20080111194428.GB29189@uranus.ravnborg.org> <20080112205635.GA6059@uranus.ravnborg.org> <20080113073024.GA30120@uranus.ravnborg.org> <20080113214204.GB2205@uranus.ravnborg.org> <478B2C6F.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478B2C6F.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 08:33:35AM +0000, Jan Beulich wrote:
> >>> Sam Ravnborg <sam@ravnborg.org> 13.01.08 22:42 >>>
> >> And I found another small buglet too. I hope to post a complete
> >> solution later today.
> >
> >The modpost bits turned out to take longer than expected so 
> >they are not done yet. The problem was the modpost structure
> >were not prepared for adding such additional chacks.
> >So I reworked those bits and the patch has been sent out for review.
> >
> >What follows here is the changes for init.h + all linker scripts
> >to show the idea.
> >
> >Next step is to beat modpost in shape and to post this on linux-arch.
> >
> >Note - in -mm there are changes to init.h so the logic
> >to decide type of __meminit notation is much simpler.
> 
> Yes, I certainly like this concept. What I would have wanted in that patch,
> though, is that the read-only data would right away be included in
> RODATA() rather than being put in DATA_DATA.
Will fix that in next patch. My focus was on the concept when I did the
patch but it is dead easy to fix for ll archs at once.

> Also, to shorten the
> names a little, how about .{cpu,mem,dev}init.rodata?
Good suggestion - will use these.

> The one thing that I'm not sure is really consistent yet wrt. the
> constification is that now you need to write e.g.
> 
> static const char __cpuinitcdata example[];
> 
> and (accidentally) omitting the 'const' (as it's really an apparently
> redundant thing now) as in
> 
> static char __cpuinitcdata example[];
> 
> will cause section type conflicts (at the compiler or linker level). I
> therefore think that the 'const' should really be part of the
> __{cpu,mem,dev}cdata definitions (requiring the attribute to be
> placed properly, namely placement at the end of a declaration as
> is possible with __{cpu,mem,dev}initdata is then not an option here).

I need to play a little with this before I make up my mind.
I do not like the concpet of hiding the const too much - it will
be non-obvious why the compiler complains if the only thing that
distingush const from non-const is a small capital 'c' within
__cpucinitdata (versus __cpuinitdata).

It can always be an incremental patch as my concpet does not prevent
it and we have only a few const __initdata variables.

	Sam
