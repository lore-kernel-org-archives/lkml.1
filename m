Return-Path: <linux-kernel-owner+w=401wt.eu-S1762164AbZDHOBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762164AbZDHOBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757609AbZDHOBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:01:36 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:52065 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbZDHOBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:01:35 -0400
Date: Wed, 8 Apr 2009 16:00:04 +0200
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Claudio Scordino <claudio@evidence.eu.com>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Hinko Kocevar <hinko.kocevar@cetrtapot.si>,
       Janez Cufer <janez.cufer@cetrtapot.si>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       dev-etrax <dev-etrax@axis.com>
Subject: Re: [PATCH] Fix broken compilation of Cris serial driver
Message-ID: <20090408140003.GK8115@axis.com>
References: <49DC7754.4030404@evidence.eu.com> <20090408105701.GH8115@axis.com> <20090408125122.GA2814@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408125122.GA2814@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 02:51:22PM +0200, Alexey Dobriyan wrote:
> On Wed, Apr 08, 2009 at 12:57:01PM +0200, Jesper Nilsson wrote:
> > On Wed, Apr 08, 2009 at 12:07:16PM +0200, Claudio Scordino wrote:
> > >     compilation of cris serial driver on 2.6.30-rc1 is broken since 
> > > commit number 0f043a81ebe84be3576667f04fdda481609e3816 removed the 
> > > read_proc field from the tty_driver structure.
> > > 
> > > The patch in attachment may fix the problem. Please check it very 
> > > carefully: I don't have hardware to make any test.
> 
> > > -	.read_proc = rs_read_proc,
> > >  	.tiocmget = rs_tiocmget,
> > >  	.tiocmset = rs_tiocmset
> > >  };
> > > @@ -4490,6 +4490,7 @@ rs_init(void)
> > >  	if (tty_register_driver(driver))
> > >  		panic("Couldn't register serial driver\n");
> > >  	/* do some initializing for the separate ports */
> > > +	driver->proc_entry->read_proc = rs_read_proc;
> > 
> > Is this the recommended way to convert proc handling?
> 
> No.

Ok, that's what I thought.

> > I find no other serial driver that does it this way...
> 
> ->read_proc effectively went away.

...so what do we use as a replacement, is it .proc_fops
or anything else?

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
