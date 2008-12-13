Return-Path: <linux-kernel-owner+w=401wt.eu-S1757161AbYLMJva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161AbYLMJva (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 04:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755236AbYLMJvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 04:51:21 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:53616 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103AbYLMJvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 04:51:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FFdc7FRYGcVTimKpDnNEN9Z13LzM8wiUeYfgdCzrKdU6f66TaYq2jCfYoFxlMl1MFR
         zFliyF2JXXiE086+Z3yumO+ntLr1PlcvTLS0qAYKQj+qKrCc3zDtBfS9CSaSrP6m5R0F
         JP5SucWg9McYjxk8qn6GgoCQYSThcCDH4Ki1o=
Subject: Re: [PATCH] Fix genius pensketch 12x9 tablet
From: Matt Helsley <matt.helsley@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20081213085556.GB12194@kroah.com>
References: <1229150548.11171.6.camel@molly>
	 <20081213075342.GA11346@kroah.com> <1229155530.13862.9.camel@molly>
	 <20081213085556.GB12194@kroah.com>
Content-Type: text/plain
Date: Sat, 13 Dec 2008 01:51:13 -0800
Message-Id: <1229161873.11987.6.camel@molly>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-12-13 at 00:55 -0800, Greg KH wrote: 
> On Sat, Dec 13, 2008 at 12:05:30AM -0800, Matt Helsley wrote:
> > On Fri, 2008-12-12 at 23:53 -0800, Greg KH wrote:
> > > On Fri, Dec 12, 2008 at 10:42:28PM -0800, Matt Helsley wrote:
> > > > The Genius PenSketch 12x9 tablet has a puck (labeled a
> > > > "Tablet Mouse") in addition to a pen. Without registering a quirk
> > > > the tablet appears to be a single input device that reports the
> > > > wrong axis information in /proc/bus/input/devices, and sends
> > > > incorrect events (e.g. ABS_Z instead of ABS_Y). This information
> > > > confuses the X evdev driver and makes the device impossible to
> > > > use.
> > > > 
> > > > The quirk fixes events and splits the device into multiple input
> > > > event devices so that at least the puck is useful.
> > > > 
> > > > Signed-off-by: Matt Helsley <matt.helsley@gmail.com>
> > > > ---
> > > > NOTE: xinput lists the puck but not the pen. I've been using a
> > > > python script to verify the contents of the events independently
> > > > of X and, as far as I can tell, the remaining problems are in X
> > > > itself.
> > > 
> > > I have a tablet here that I'm having troubles getting to work.  Any
> > > chance I could get a copy of your python script so I can try to debug
> > > what is going wrong, and if it's a X problem or a kernel issue like you
> > > found for your device?
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Sure. Sometime around 2.6.24 I updated this script (originally by Micah
> > Dowty) to include more evdev #defines, work on 64-bit systems, and
> > decode some bitvectors into their C symbols.
> 
> Thanks, it has helped out, although it doesn't seem to "poll" the device
> properly for some reason to get any events from the device.  I wonder if
> X is grabbing it before this script has a chance to, I'll play around
> with that next...

I've seen that too. If X is running then it intercepts the events
somehow -- not sure if it's a grab or what. I can confirm this by
shutting down X and opening the device with the script from a VT.

Cheers,
	-Matt

