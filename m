Return-Path: <linux-kernel-owner+w=401wt.eu-S1752098AbZAZL0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbZAZL0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 06:26:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbZAZLZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 06:25:57 -0500
Received: from styx.suse.cz ([82.119.242.94]:34768 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750923AbZAZLZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 06:25:57 -0500
Date: Mon, 26 Jan 2009 12:25:55 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg@redhat.com>, Samuel Ortiz <sameo@openedhand.com>
Subject: Re: since 2.6.29-rc: apple infrared keeps system awake?
In-Reply-To: <1232968513.20525.1.camel@johannes.local>
Message-ID: <alpine.LNX.1.10.0901261220150.5377@jikos.suse.cz>
References: <1232635779.4224.12.camel@johannes.local>  <alpine.LRH.1.10.0901261151320.26411@twin.jikos.cz> <1232968513.20525.1.camel@johannes.local>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2009, Johannes Berg wrote:

> > > Ever since 2.6.29-rc, I see this in powertop on my macbook5,1:
> > > Top causes for wakeups:
> > >   24.1% ( 27.8)   USB device usb1 : OHCI Host Controller (Linux 2.6.29-rc2-wl-di
> > >   21.5% ( 24.8)       <interrupt> : ohci_hcd:usb1 
> > >   14.5% ( 16.7)   USB device  1-5 : IR Receiver (Apple Computer, Inc.) 
> > > which is way way more than what it used to be, I never saw the IR 
> > > receiver before. I could bisect, but wondered if somebody had seen this 
> > 
> > What driver is bound to this device? (what is the product ID?).
> None, oddly, it seems. At least listing input devices doesn't seem to
> show it.
> Bus 003 Device 002: ID 05ac:8242 Apple, Inc. 

This should be driven by hid-apple/usbhid. Could you please look into 
/sys/bus/usb/devices for this device and check where does the 'driver' 
symlink point to?

Also, for this device, we force a creation of hiddev node, so it's 
possible (and, in fact, probable), that some lirc process has the node 
open and wakes it up periodically? (I think there is a macmini lirc 
userspace driver, please check whether it has the hiddev node open).

-- 
Jiri Kosina
SUSE Labs
