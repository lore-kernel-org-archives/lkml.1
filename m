Return-Path: <linux-kernel-owner+w=401wt.eu-S1758482AbXETUMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482AbXETUMX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 16:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755962AbXETUMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 16:12:16 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:44269 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755929AbXETUMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 16:12:15 -0400
Date: Sun, 20 May 2007 22:13:12 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Factor out common MODULE_INFO content from module*.h files.
Message-ID: <20070520201312.GA25339@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0705201502160.17519@localhost.localdomain> <20070520191552.GA25200@uranus.ravnborg.org> <Pine.LNX.4.64.0705201538250.18011@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705201538250.18011@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 at 03:51:18PM -0400, Robert P. J. Day wrote:
> On Sun, 20 May 2007, Sam Ravnborg wrote:
> 
> > On Sun, May 20, 2007 at 03:06:15PM -0400, Robert P. J. Day wrote:
> > >
> > > In order to eventually break the interdependency between the module.h
> > > and moduleparam.h header files, factor out the common MODULE_INFO
> > > content into a new header file.
> >
> > The moduleinfo.h file looks redundant at first look.
> > Why not push relevant parts from moduleparam.h (the
> > MODULE_INFO bits) to module.h and let go of
> > the include of moduleparam.h in module.h (when you
> > have fixed the users)?
> >
> > In this way we do not add an extra .h file.
> > And files that needs moduleparam.h will anyway always need module.h.
> > But not the other way around.
> 
> no problem, i can go that way, too, but there's just one (admittedly
> picky) issue associated with that.
> 
> based on the above, we would have:
> 
> 1) module.h handling all generic module content, and
> 2) moduleparam.h would "#include" module.h and add the parameter
> stuff.
> 
> fair enough, but note that, with that, if you wanted parameter
> support, you would need to include *only* "moduleparam.h".  are you
> good with that?  (as i said, it's picky, but you'd probably still have
> a lot of people who, through force of habit, would still #include both
> just because they think it's necessary.  wouldn't hurt, of course,
> since module.h would be protected against multiple inclusion.)
> 
> so if you're good with all of the above, i can do that.

The above is fine and better than having an extra file.

	Sam
