Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbYLMI5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbYLMI5F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 03:57:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754463AbYLMI4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 03:56:52 -0500
Received: from kroah.org ([198.145.64.141]:54375 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754374AbYLMI4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 03:56:51 -0500
Date: Sat, 13 Dec 2008 00:55:56 -0800
From: Greg KH <greg@kroah.com>
To: Matt Helsley <matt.helsley@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix genius pensketch 12x9 tablet
Message-ID: <20081213085556.GB12194@kroah.com>
References: <1229150548.11171.6.camel@molly> <20081213075342.GA11346@kroah.com> <1229155530.13862.9.camel@molly>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229155530.13862.9.camel@molly>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2008 at 12:05:30AM -0800, Matt Helsley wrote:
> On Fri, 2008-12-12 at 23:53 -0800, Greg KH wrote:
> > On Fri, Dec 12, 2008 at 10:42:28PM -0800, Matt Helsley wrote:
> > > The Genius PenSketch 12x9 tablet has a puck (labeled a
> > > "Tablet Mouse") in addition to a pen. Without registering a quirk
> > > the tablet appears to be a single input device that reports the
> > > wrong axis information in /proc/bus/input/devices, and sends
> > > incorrect events (e.g. ABS_Z instead of ABS_Y). This information
> > > confuses the X evdev driver and makes the device impossible to
> > > use.
> > > 
> > > The quirk fixes events and splits the device into multiple input
> > > event devices so that at least the puck is useful.
> > > 
> > > Signed-off-by: Matt Helsley <matt.helsley@gmail.com>
> > > ---
> > > NOTE: xinput lists the puck but not the pen. I've been using a
> > > python script to verify the contents of the events independently
> > > of X and, as far as I can tell, the remaining problems are in X
> > > itself.
> > 
> > I have a tablet here that I'm having troubles getting to work.  Any
> > chance I could get a copy of your python script so I can try to debug
> > what is going wrong, and if it's a X problem or a kernel issue like you
> > found for your device?
> > 
> > thanks,
> > 
> > greg k-h
> 
> Sure. Sometime around 2.6.24 I updated this script (originally by Micah
> Dowty) to include more evdev #defines, work on 64-bit systems, and
> decode some bitvectors into their C symbols.

Thanks, it has helped out, although it doesn't seem to "poll" the device
properly for some reason to get any events from the device.  I wonder if
X is grabbing it before this script has a chance to, I'll play around
with that next...

greg k-h
