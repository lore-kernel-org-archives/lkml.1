Return-Path: <linux-kernel-owner+w=401wt.eu-S1755931AbZATF7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbZATF7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 00:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbZATF7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 00:59:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:31095 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbZATF7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 00:59:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GZLn9UgPvqBTOJntCn65QPY2zEnj105mOC1mjTuSRH8+/YRO1hwztDhVLcWenn80dS
         xGHzvaOYNtSUDNVBCGOcXuxmaLcOjlYM0ukmAL4htzVu+uRcPdxJgkZXhsHVc94N4xcx
         XQEmQ4RugmGw0yZWhGCPoxy0bqrbAxVJJCHbA=
Date: Tue, 20 Jan 2009 09:04:35 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: staging driver (epl)
Message-ID: <20090120060435.GA3421@x200.localdomain>
References: <20090119210315.GA3805@x200.localdomain> <20090119235910.GA7171@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090119235910.GA7171@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 03:59:10PM -0800, Greg KH wrote:
> On Tue, Jan 20, 2009 at 12:03:15AM +0300, Alexey Dobriyan wrote:
> > Greg, can I ssh to your box to do
> > 
> > 	git rm -rf drivers/staging/epl
> > 	sed -i -e '/epl/d' drivers/staging/Kconfig
> > 	sed -i -e '/CONFIG_EPL/d' drivers/staging/Makefile
> > 	git commit -a -m 'staging: remove epl driver'
> > 
> > ?
> 
> That might be tough for you to do, as it's in every 2.6.29-rc1 release
> out there.  That's a lot of ssh and sed commands needed for you to do :)
> 
> > This driver doesn't meet even _the_ basic requirements.
> 
> It meets the drivers/staging/ requirements of:
> 	- it builds
> 	- it is self-contained
> 	- someone is using it
> 
> Well, some of the stuff in drivers/staging/ don't even meet the first
> requirement, making this one of the better drivers :)
> 
> > It's _full_ of hungarian notation (iRet).
> > 
> > It's full of typedefs.
> > 
> > It's full of HAL (tEplApiInstance etc).
> > 
> > Filenames (!) are in CamelCase.
> > 
> > It creates sockets from kernel for something.
> > 
> > It tries to interact with devfs.
> > 
> > It may come as surprise but you also committed real Win32 code:
> > 
> > 	drivers/staging/epl/EplTimeruWin32.c
> > 	drivers/staging/epl/ShbIpc-Win32.c
> > 
> > Amazing, isn't it?
> 
> No, not at all, I commited the tarball I was given, after shoehorning it
> into the kernel build system.
> 
> > Do you accept _any_ code?
> 
> Yes.
> 
> > Exactly zero entry barrier?
> 
> Pretty much.  Know of any other drivers that should go into here that
> are floating around in the wild?
> 
> Is this a problem?

Well, yes.

Suppose someone cleanups issues mentioned and make it at least look like
usual Linux driver.

And then it likely will turn out that driver is so misdesigned that
it will be faster to just rewrite it.

I'm very certain this will happen because it's a Windows driver.

Now why waste time doing cleanups when the risk that cleanups will only help
to see it's misdesigned is so high? I can't think of a Linux person mentally
dragging himself through issues mentioned to see the end result, it's very hard
to read such code after reading much Linux code.

> Is the drivers/staging/ area just not properly documented for people to
> understand what is going on there and how it differs from the rest of
> the kernel?  Should I write up something a bit more "formal"?

No, too early to write policies.
