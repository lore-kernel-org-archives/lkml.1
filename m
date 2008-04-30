Return-Path: <linux-kernel-owner+w=401wt.eu-S1761386AbYD3Gfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761386AbYD3Gfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 02:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756411AbYD3GfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 02:35:21 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51337 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755907AbYD3GfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 02:35:19 -0400
Date: Wed, 30 Apr 2008 08:35:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andres Salomon <dilinger@queued.net>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@codemonkey.org.uk>,
       Roland McGrath <roland@redhat.com>
Subject: Re: Additional kconfig targets (cloneconfig, nonint_oldconfig etc)
Message-ID: <20080430063552.GA30509@uranus.ravnborg.org>
References: <20080429183531.GB19652@uranus.ravnborg.org> <20080429172402.14d7d40b@ephemeral>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429172402.14d7d40b@ephemeral>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The commands we have today for kconfig is:
> > 
> > # Command line variants
> > make oldconfig
> > make silentoldconfig
> > make defconfig
> > make XXX_defconfig
> > 
> > (The other frontends are left out on purpose).
> > The challenge here is to come up with a syntax that
> > allows us to select between the three behaviours,
> > while keeping backward compatibility.
> > 
> > The best suggestion I have so far is to say that:
> > a) if defconfig is specified then we use method 1)
> > b) if oldconfig is specified then we use method 2)
> > c) if newconfig is specified then we use method 3)
> > 
> 
> 'newconfig' sounds to me like you're creating a new config; the exact
> opposite of what it does.  I'd suggest 'listnewconfig' or some such thing.
listnewconfig is better - will use that.

> Then again, 'defconfig' and 'oldconfig' are primarily what I care about,
> as I haven't been in a situation where I would have found method 3) to
> be useful.
> 
> > And we add support for a new 'commandline' parameter
> > 'K' so I can say:
> > 
> > make K=/proc/config.gz defconfig
> > make K=i386_defconfig  defconfig
> > make K=i386_defconfig  oldconfig
> > make K=/proc/config.gz newconfig
> > 
> > So K is used to specify what config file we use
> > to start out from.
> 
> Sounds good, I highly prefer specifying the config via env variable
> rather than embedded in the target (ie, 'make olpc_defconfig').
I will try to come up with some simple algorithm to locate the file.
I guess something like:

a) Try in local dir with name supplied
b) If filname does not start with '/' try in arch/$ARCH/configs/*
c) If filname does not start with '/' try in arch/$ARCH/configs/*_defconfig

If filename is prefixed .gz unpack it

	Sam
