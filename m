Return-Path: <linux-kernel-owner+w=401wt.eu-S1764301AbZDHMvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764301AbZDHMvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbZDHMvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:51:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:51055 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbZDHMvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:51:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=C3I4Zn6tIPgMU3C5fKNkeMun0eOzfBO+FCRhw4rfNKLpk86Mgw/J+z7Y3XgSxosyLd
         75Bj1Qw5g14tEjVl5j/ozfLJ2M16718wXzGt4cs3FSuoj8AOIiN6GPCENlYsr/9848uF
         OqZ/AlAmtYLI4qNUUR4Q/3NffFBlhRbCgD3do=
Date: Wed, 8 Apr 2009 16:51:22 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jesper Nilsson <Jesper.Nilsson@axis.com>
Cc: Claudio Scordino <claudio@evidence.eu.com>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Hinko Kocevar <hinko.kocevar@cetrtapot.si>,
       Janez Cufer <janez.cufer@cetrtapot.si>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       dev-etrax <dev-etrax@axis.com>
Subject: Re: [PATCH] Fix broken compilation of Cris serial driver
Message-ID: <20090408125122.GA2814@x200.localdomain>
References: <49DC7754.4030404@evidence.eu.com> <20090408105701.GH8115@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408105701.GH8115@axis.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 12:57:01PM +0200, Jesper Nilsson wrote:
> On Wed, Apr 08, 2009 at 12:07:16PM +0200, Claudio Scordino wrote:
> >     compilation of cris serial driver on 2.6.30-rc1 is broken since 
> > commit number 0f043a81ebe84be3576667f04fdda481609e3816 removed the 
> > read_proc field from the tty_driver structure.
> > 
> > The patch in attachment may fix the problem. Please check it very 
> > carefully: I don't have hardware to make any test.

> > -	.read_proc = rs_read_proc,
> >  	.tiocmget = rs_tiocmget,
> >  	.tiocmset = rs_tiocmset
> >  };
> > @@ -4490,6 +4490,7 @@ rs_init(void)
> >  	if (tty_register_driver(driver))
> >  		panic("Couldn't register serial driver\n");
> >  	/* do some initializing for the separate ports */
> > +	driver->proc_entry->read_proc = rs_read_proc;
> 
> Is this the recommended way to convert proc handling?

No.

> I find no other serial driver that does it this way...

->read_proc effectively went away.

> I was looking at using the proc_fops instead, but that is a
> much larger change.
> 
> I will try to test your patch and if it works I'll push it
> through the CRIS tree.

It shouldn't work, ->read_proc won't even be called.
