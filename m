Return-Path: <linux-kernel-owner+w=401wt.eu-S1759497AbXKAX6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497AbXKAX6E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 19:58:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbXKAX5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 19:57:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39981 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752876AbXKAX5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 19:57:53 -0400
Date: Thu, 1 Nov 2007 16:57:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
Cc: Emilian.Medve@freescale.com, linux-kernel@vger.kernel.org, hjlipp@web.de,
       tilman@imap.cc, gigaset307x-common@lists.sourceforge.net, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, mac@melware.de,
       linux-omap-open-source@linux.omap.com
Subject: Re: [PATCH resend] Make the dev_*() family of macros in
 device.hcomplete
Message-Id: <20071101165700.aa5167fb.akpm@linux-foundation.org>
In-Reply-To: <20071030154008.GA22809@suse.de>
References: <1193697795-7823-1-git-send-email-Emilian.Medve@Freescale.com>
	<20071030000054.GA19022@suse.de>
	<598D5675D34BE349929AF5EDE9B03E27016E5FCB@az33exm24.fsl.freescale.net>
	<20071030154008.GA22809@suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 08:40:08 -0700
Greg KH <gregkh@suse.de> wrote:

> On Tue, Oct 30, 2007 at 05:11:24AM -0700, Medve Emilian-EMMEDVE1 wrote:
> > Hi Greg K-H,
> > 
> > 
> > > > +#define dev_info(dev, format, arg...)		\
> > > > +	dev_printk(KERN_INFO, dev, format, ## arg)
> > > > +
> > > >  #ifdef DEBUG
> > > >  #define dev_dbg(dev, format, arg...)		\
> > > > -	dev_printk(KERN_DEBUG , dev , format , ## arg)
> > > > +	dev_printk(KERN_DEBUG, dev, format, ## arg)
> > > 
> > > Those extra spaces are there for a good reason, older versions of gcc
> > > are broken without it.  So please, put them all back...
> > 
> > You mean I should add spaces before commas only where they were
> > initially or to all new code and/or macros?
> 
> Put it back where it was, and do the same for all other macros.
> 
> > I've observed other kernel code and more often there are no spaces
> > before commas. I'm asking because the CodingStyle document is not very
> > explicit about this rule.
> 
> This is a gcc rule, for variable length macros, not a CodingStyle
> guideline.  It just will not work without it :)
> 

The space-before-a-comma requirement was for gcc-2.95, iirc.

It got to the stage where I was the only person testing with gcc-2.95 so I
spent inordinate amounts of time adding spaces before people's newly-added
commas.  Fortunately we abamdoned that gcc version so the space-before-a-comma
requirement no longer exists.

