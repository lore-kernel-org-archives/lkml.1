Return-Path: <linux-kernel-owner+w=401wt.eu-S1760504AbXHQWqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760504AbXHQWqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 18:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbXHQWq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 18:46:29 -0400
Received: from smtp102.sbc.mail.re2.yahoo.com ([68.142.229.103]:25376 "HELO
	smtp102.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754478AbXHQWq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 18:46:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=IcRKmbYrog48JfFFpiL2PDLNOnIW4l1E+sjdKXJ+4DDSNZdYwPtcs2+X3GE0pR4HiAnSjbCE8JBQpEcX1vm866xOGECb614Lt2KWojh3YQG4GfOG5FqzweCchhVi5RMcp/Jw7GRpzgKE9Qad5BC3/jVGNJFUjMeoTboiRIDHOHg=  ;
X-YMail-OSG: a9Q.XLkVM1mdY7Da37RHq0gKuZj9aIJcmdatad_MKs8bvquqgN1ifvJjGoZgVdEJiQ8.K1UN_ypu8Tth8ZpHyctv2_gWym18hDQ.VCGhwhfhb3fgZwdOE5C_iqsuvEOeeMO.2nW6F5SrFbE-
From: David Brownell <david-b@pacbell.net>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Subject: Re: [PATCH 01/12] Blackfin arch: add peripheral resource allocation support
Date: Fri, 17 Aug 2007 15:46:24 -0700
User-Agent: KMail/1.9.6
Cc: "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       "Bryan Wu" <bryan.wu@analog.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <600D5CB4DFD93545BF61FF01473D11AC0D87BD9F@limkexm2.ad.analog.com> <200708171411.00145.david-b@pacbell.net> <200708171815.56323.rgetz@blackfin.uclinux.org>
In-Reply-To: <200708171815.56323.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708171546.25445.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 August 2007, Robin Getz wrote:
> On Fri 17 Aug 2007 17:10, David Brownell pondered:
> > On the other hand, maybe you want your "typical" customer to
> > be more of a systems integrator than anything else.
> 
> We are getting yelled at by our customers (I was on the phone yesterday), 
> because the kernel build environment we distribute (the default) was not 
> inside Eclipse, and someone couldn't push a button on a GUI rather than 
> typing "make".

Press the "enter" button after typing "make".  ;)


> While Linux and other open source software is free, for some taking advantage 
> of its benefits can require a significant investment in time. Linux is 
> powerful, rich, and flexible. It is these very characteristics that make 
> Linux so appealing that also create a significant level of complexity.

Yes.

 
> We are seeing more and more "first time buyers" jumping from bare metal - no 
> OS, to Linux. For them - the ease of not having to write configuration files 
> gives them a warm fuzzy feeling when they boot their board, and it 
> just "works".

There's certainly a lot to be said for having things
just work the first time when you're making such a big
transition in tools.  On the other hand, at some point
the training wheels need to come off!



> > > >That said, how you handle pinmux on Blackfin is your business.
> > > >
> > > >But you should know that this approach seems idiosyncratic and
> > > >more complex than needed:  when pin config is done early and as
> > > >part of board setup, drivers don't need to care about it or to
> > > >handle any pinmux errors.  And heck, products can sometimes be
> > > >shipped with the bootloader having done all pinmux setup, so
> > > >Linux won't need to worry about it at all.  That can help ship
> > > >multiple board revisions using the same kernel.
> > > 
> > > This works for fixed function boards.
> > 
> > That is, for typical products embedding Linux...
> 
> We have multiple customers shipping the same bootloader/kernel binary on 
> different products, and the only difference is the /etc/rc file - which 
> drivers they install, and a few things in userspace.

Be careful there.  Remember that the driver model is predicated
on knowing the devices first, and *then* matching drivers.  I
expect you *will* see problems if you get people thinking system
config comes from a "which driver" selection rather than "here's
the exact hardware that's available".  Maybe configfs should be
used for device config.


> Could this be smaller - sure - but NAND is cheap (according to them) compared 
> to the effort and cost of maintaining and testing multiple kernel versions 
> for every product.
>  
> Could this be faster - sure - but it is done at init - and then never again. 
> We have a ~2-3 second boot time - maybe we shave off a few ms - things go 
> pretty fast at 600MHz.

I'm more used to clock rates less than 1/3 that much.  :)

- Dave


