Return-Path: <linux-kernel-owner+w=401wt.eu-S1764430AbZATAUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764430AbZATAUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761861AbZATAMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 19:12:21 -0500
Received: from ns.suse.de ([195.135.220.2]:42905 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762889AbZATAMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 19:12:19 -0500
Date: Mon, 19 Jan 2009 15:59:10 -0800
From: Greg KH <gregkh@suse.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: staging driver (epl)
Message-ID: <20090119235910.GA7171@suse.de>
References: <20090119210315.GA3805@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090119210315.GA3805@x200.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 12:03:15AM +0300, Alexey Dobriyan wrote:
> Greg, can I ssh to your box to do
> 
> 	git rm -rf drivers/staging/epl
> 	sed -i -e '/epl/d' drivers/staging/Kconfig
> 	sed -i -e '/CONFIG_EPL/d' drivers/staging/Makefile
> 	git commit -a -m 'staging: remove epl driver'
> 
> ?

That might be tough for you to do, as it's in every 2.6.29-rc1 release
out there.  That's a lot of ssh and sed commands needed for you to do :)

> This driver doesn't meet even _the_ basic requirements.

It meets the drivers/staging/ requirements of:
	- it builds
	- it is self-contained
	- someone is using it

Well, some of the stuff in drivers/staging/ don't even meet the first
requirement, making this one of the better drivers :)

> It's _full_ of hungarian notation (iRet).
> 
> It's full of typedefs.
> 
> It's full of HAL (tEplApiInstance etc).
> 
> Filenames (!) are in CamelCase.
> 
> It creates sockets from kernel for something.
> 
> It tries to interact with devfs.
> 
> It may come as surprise but you also committed real Win32 code:
> 
> 	drivers/staging/epl/EplTimeruWin32.c
> 	drivers/staging/epl/ShbIpc-Win32.c
> 
> Amazing, isn't it?

No, not at all, I commited the tarball I was given, after shoehorning it
into the kernel build system.

> Do you accept _any_ code?

Yes.

> Exactly zero entry barrier?

Pretty much.  Know of any other drivers that should go into here that
are floating around in the wild?

Is this a problem?

Is the drivers/staging/ area just not properly documented for people to
understand what is going on there and how it differs from the rest of
the kernel?  Should I write up something a bit more "formal"?

thanks,

greg k-h
