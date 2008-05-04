Return-Path: <linux-kernel-owner+w=401wt.eu-S1754949AbYEDI2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbYEDI2P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 04:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYEDI15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 04:27:57 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:40325 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbYEDI1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 04:27:54 -0400
Date: Sun, 4 May 2008 10:27:32 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Roman Zippel <zippel@linux-m68k.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kconfig - a suggestion how to fix the select issue
Message-ID: <20080504082732.GB17276@uranus.ravnborg.org>
References: <20080504071041.GA15315@uranus.ravnborg.org> <20080504081145.GG5838@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080504081145.GG5838@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2008 at 11:11:45AM +0300, Adrian Bunk wrote:
> On Sun, May 04, 2008 at 09:10:41AM +0200, Sam Ravnborg wrote:
> >...
> > 
> > config A
> >         bool "a"
> > 
> > config B
> >         bool "b"
> >         depends on A
> > 
> > config C
> >         bool "c"
> >         require B
> > 
> > The require dependency will have impact on visibility.
> > C shall only be visible if all symbols it require are
> > visible. Note that visible does not imply 'chosen'.
> > In this case C would be visible when A is chosen.
> > 
> > When the user then choose C and B is not chosen 
> > then the user is prompted to choose B.
> > 
> > So user has to chose B in order to have C chosen.
> >...
> > Comments?
> 
> 
> Given:
> 
> config A
> 	tristate "a"
> 
> config B
> 	tristate "b"
> 	depends on A
> 
> config C
> 	bool "c"
> 	require B
> 
> CONFIG_A=m
> 
> 
> Will C be visible?
If you followed my description then you would see
that the visibility of C are determineded by the dependencies
of C (none in this case) and the dependencies of the symbol
it requires. In this case B. B dpens on A and A equals m so B is
visible thus C is visible.

 
> The underlying problem is that we use bool for two different cases:
> - non-modular driver (answer would be "no")
> - enable feature in driver (answer would be "depends on the value of D")
Lets try to agree on the semantics with bools first please.
When we have that in place lets extend it to modular - OK?

	Sam
