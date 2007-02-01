Return-Path: <linux-kernel-owner+w=401wt.eu-S1750886AbXBAViQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750886AbXBAViQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 16:38:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbXBAViQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 16:38:16 -0500
Received: from smtp.osdl.org ([65.172.181.24]:40171 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbXBAViO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 16:38:14 -0500
Date: Thu, 1 Feb 2007 13:37:44 -0800
From: Andrew Morton <akpm@osdl.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Soeren Sonnenburg <kernel@nn7.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] 2.6.20-rc6 SCSI error: I/O error - trouble
 with mass storage devices ?!
Message-Id: <20070201133744.1a548ad5.akpm@osdl.org>
In-Reply-To: <Pine.LNX.4.44L0.0701301300050.7522-100000@iolanthe.rowland.org>
References: <1169909796.2462.56.camel@localhost>
	<Pine.LNX.4.44L0.0701301300050.7522-100000@iolanthe.rowland.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007 13:08:19 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Sat, 27 Jan 2007, Soeren Sonnenburg wrote:
> 
> > Dear all,
> > 
> > I am trying to use a P990 phone in via mass storage under linux. I was
> > able to copy data to/from the phone without trouble under winxp but
> > receive millions of I/O errors (see below (*), basically on any sector).
> > As this was also happening on a casio camera (and working on winxp) I
> > tried a couple of things to nail this down:
> 
> ...
> 
> > 4) I enabled usb mass storage verbose debug output and collected 2 runs
> > of I/O once with the sandisk and one with the P990 (attached as sandisk
> > and p990)
> 
> ...
> 
> > Now I am clueless what could have gone wrong (as I *think* this was all
> > working at some point at least before firmware updates) and what the
> > difference between these mass storage devices is.
> 
> The log revealed that the phone's firmware returns garbage values in the 
> Residue field for some WRITEs.  This patch should take care of it.
> 
> Alan Stern
> 
> 
> 
> Index: usb-2.6/drivers/usb/storage/unusual_devs.h
> ===================================================================
> --- usb-2.6.orig/drivers/usb/storage/unusual_devs.h
> +++ usb-2.6/drivers/usb/storage/unusual_devs.h
> @@ -1318,12 +1318,13 @@ UNUSUAL_DEV(  0x0fce, 0xe031, 0x0000, 0x
>  		US_SC_DEVICE, US_PR_DEVICE, NULL,
>  		US_FL_FIX_CAPACITY ),
>  
> -/* Reported by Jan Mate <mate@fiit.stuba.sk> */
> +/* Reported by Jan Mate <mate@fiit.stuba.sk>
> + * and by Soeren Sonnenburg <kernel@nn7.de> */
>  UNUSUAL_DEV(  0x0fce, 0xe030, 0x0000, 0x0000,
>  		"Sony Ericsson",
>  		"P990i",
>  		US_SC_DEVICE, US_PR_DEVICE, NULL,
> -		US_FL_FIX_CAPACITY ),
> +		US_FL_FIX_CAPACITY | US_FL_IGNORE_RESIDUE ),
>  
>  /* Reported by Kevin Cernekee <kpc-usbdev@gelato.uiuc.edu>
>   * Tested on hardware version 1.10.

This fixes the phone, but what's the situation with that Casio camera?
