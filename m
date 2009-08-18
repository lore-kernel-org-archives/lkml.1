Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029AbZHRWi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbZHRWi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 18:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbZHRWi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 18:38:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:58082 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbZHRWi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 18:38:27 -0400
Date: Tue, 18 Aug 2009 15:36:48 -0700
From: Greg KH <gregkh@suse.de>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
Message-ID: <20090818223648.GA25659@suse.de>
References: <20090808194733.38406075@neptune.home>
 <Pine.LNX.4.44L0.0908101114320.3208-100000@iolanthe.rowland.org>
 <20090810154402.GA7701@kroah.com>
 <20090810191822.26370810@neptune.home>
 <20090810181306.GA24989@kroah.com>
 <20090810203501.4d57aa5b@neptune.home>
 <20090810205115.6871239d@neptune.home>
 <20090810192954.GA11651@suse.de>
 <20090818190016.73ce53de@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090818190016.73ce53de@neptune.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 07:00:16PM +0200, Bruno Prémont wrote:
> Hi Greg,
> 
> Were you able to reproduce this with a FTDI usbserial device?

No, I can't find one in my box.  I'll go dig in the attic next to try to
find on, I knew I had one before...

> I just had a short look with 2.6.31-rc6, it crashes harder... once
> kernel did panic with general protection fault after reporting
>   tty_port_close_start: count=-1
> The second time id started output of an Oops but only half of the first
> line ever showed up on screen (Intel KMS).
> 
> Note: this was with just usbserial.ko and ftdi_sio.ko rebuilt with
> CONFIG_DEBUG_INFO=y in the hope to find out what did access a bad
> pointer. (make CONFIG_DEBUG_INFO=y drivers/usb/serial/$module.ko)
> 
> Will retry now with a fresh compile with CONFIG_DEBUG_INFO enabled for
> whole kernel and see if I can get better information, eventually
> switching to vesa framebuffer in case the partial output happens again.
> 
> This pretty much looks like unbalanced ref-count...

Yeah, it sounds like it.  More info would be great to have if you can
get it.

thanks,

greg k-h
