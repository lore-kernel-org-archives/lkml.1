Return-Path: <linux-kernel-owner+w=401wt.eu-S1759353AbXETUu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353AbXETUu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 16:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756279AbXETUuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 16:50:19 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:55770 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756186AbXETUuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 16:50:18 -0400
Date: Sun, 20 May 2007 22:51:16 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Factor out common MODULE_INFO content from module*.h files.
Message-ID: <20070520205116.GB25339@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0705201502160.17519@localhost.localdomain> <20070520191552.GA25200@uranus.ravnborg.org> <Pine.LNX.4.64.0705201555470.18338@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705201555470.18338@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 at 04:06:40PM -0400, Robert P. J. Day wrote:
> On Sun, 20 May 2007, Sam Ravnborg wrote:
> 
> > On Sun, May 20, 2007 at 03:06:15PM -0400, Robert P. J. Day wrote:
> > >
> > > In order to eventually break the interdependency between the module.h
> > > and moduleparam.h header files, factor out the common MODULE_INFO
> > > content into a new header file.
> >
> > The moduleinfo.h file looks redundant at first look. Why not push
> > relevant parts from moduleparam.h (the MODULE_INFO bits) to module.h
> > and let go of the include of moduleparam.h in module.h (when you
> > have fixed the users)?
> >
> > In this way we do not add an extra .h file. And files that needs
> > moduleparam.h will anyway always need module.h. But not the other
> > way around.
> 
> crap, now i remember why i did it the way i did it.
> 
> yes, the way you describe it is a simpler solution, but it would break
> all of the files in the tree that use module parameters and have
> included *only* module.h, and have been getting away with it all this
> time only because module.h currently includes moduleparam.h.
> 
> based on a simple script i have, there are currently 583 files under
> the drivers/ directory *alone* that are like that.  that is, 583 files
> that would need to include moduleparam.h instead of module.h simply to
> continue to compile if the obvious header file fix were made.
The pain is too high for this.
Is seems worthwhile to make the change to module.h but
adding an additional include to > 500 drivers is not worth it.

	Sam
