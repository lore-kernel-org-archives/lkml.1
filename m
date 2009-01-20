Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbZATGSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbZATGSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 01:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbZATGSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 01:18:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41043 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbZATGSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 01:18:09 -0500
Date: Mon, 19 Jan 2009 22:10:55 -0800
From: Greg KH <gregkh@suse.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: staging driver (epl)
Message-ID: <20090120061055.GA4309@suse.de>
References: <20090119210315.GA3805@x200.localdomain> <20090119235910.GA7171@suse.de> <20090120060435.GA3421@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120060435.GA3421@x200.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 09:04:35AM +0300, Alexey Dobriyan wrote:
> On Mon, Jan 19, 2009 at 03:59:10PM -0800, Greg KH wrote:
> > On Tue, Jan 20, 2009 at 12:03:15AM +0300, Alexey Dobriyan wrote:
> > > Greg, can I ssh to your box to do
> > > 
> > > 	git rm -rf drivers/staging/epl
> > > 	sed -i -e '/epl/d' drivers/staging/Kconfig
> > > 	sed -i -e '/CONFIG_EPL/d' drivers/staging/Makefile
> > > 	git commit -a -m 'staging: remove epl driver'
> > > 
> > > ?
> > 
> > That might be tough for you to do, as it's in every 2.6.29-rc1 release
> > out there.  That's a lot of ssh and sed commands needed for you to do :)
> > 
> > > This driver doesn't meet even _the_ basic requirements.
> > 
> > It meets the drivers/staging/ requirements of:
> > 	- it builds
> > 	- it is self-contained
> > 	- someone is using it
> > 
> > Well, some of the stuff in drivers/staging/ don't even meet the first
> > requirement, making this one of the better drivers :)
> > 
> > > It's _full_ of hungarian notation (iRet).
> > > 
> > > It's full of typedefs.
> > > 
> > > It's full of HAL (tEplApiInstance etc).
> > > 
> > > Filenames (!) are in CamelCase.
> > > 
> > > It creates sockets from kernel for something.
> > > 
> > > It tries to interact with devfs.
> > > 
> > > It may come as surprise but you also committed real Win32 code:
> > > 
> > > 	drivers/staging/epl/EplTimeruWin32.c
> > > 	drivers/staging/epl/ShbIpc-Win32.c
> > > 
> > > Amazing, isn't it?
> > 
> > No, not at all, I commited the tarball I was given, after shoehorning it
> > into the kernel build system.
> > 
> > > Do you accept _any_ code?
> > 
> > Yes.
> > 
> > > Exactly zero entry barrier?
> > 
> > Pretty much.  Know of any other drivers that should go into here that
> > are floating around in the wild?
> > 
> > Is this a problem?
> 
> Well, yes.
> 
> Suppose someone cleanups issues mentioned and make it at least look like
> usual Linux driver.
> 
> And then it likely will turn out that driver is so misdesigned that
> it will be faster to just rewrite it.

That's fine, I have no objection to a total rewrite, that's happening
already to some drivers that are already in drivers/staging/.  When
those drivers then go into the main kernel tree, I'll instantly drop the
drivers/staging/ driver.

> Now why waste time doing cleanups when the risk that cleanups will only help
> to see it's misdesigned is so high? I can't think of a Linux person mentally
> dragging himself through issues mentioned to see the end result, it's very hard
> to read such code after reading much Linux code.

I agree, but there are companies already using this code today.  So why
not include it as it is useful to a very big group of users.  If we get
it cleaned up and working better, that even helps out more.

> > Is the drivers/staging/ area just not properly documented for people to
> > understand what is going on there and how it differs from the rest of
> > the kernel?  Should I write up something a bit more "formal"?
> 
> No, too early to write policies.

Heh, how about explainations :)

thanks,

greg k-h
