Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbZBCOvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbZBCOvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 09:51:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbZBCOvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 09:51:40 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52649 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbZBCOvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 09:51:40 -0500
Subject: Re: [stable]  A patch in 2.6.27.9 caused device names to change
From: Dan Williams <dcbw@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
In-Reply-To: <20090203000529.GC9467@kroah.com>
References: <20090202170238.348af36a@dhcp-100-2-144.bos.redhat.com>
	 <20090203000529.GC9467@kroah.com>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 09:50:11 -0500
Message-Id: <1233672611.11344.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 16:05 -0800, Greg KH wrote:
> On Mon, Feb 02, 2009 at 05:02:38PM -0500, Chuck Ebbert wrote:
> > This patch:
> > http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob_plain;f=releases/2.6.27.9/usb-option-add-pantech-cards.patch;hb=HEAD
> > 
> > replaced my wireless adapter's /dev/ttyACM0 interface with three interfaces:
> > /dev/ttyUSB[012]
> > 
> > That broke my ppp connection scripts. And I have to use /dev/ttyUSB1 to connect,
> > not USB0. Also it looks like Network Manager only knows how to use the first
> > interface in its auto-connect mode, so people using that also lost their
> > connections.
> 
> Ugh, that sucks.
> 
> That is what is also in upstream, so 2.6.29-rc also fails for you?
> 
> Dan, what's with replacing working devices with the cdc-acm driver with
> option device ids?  Is there some reason you did this?

For a long time we've been operating under the assumption that mobile
broadband devices should be driven by option and sierra, since those
drivers had the necessary buffering optimizations to support
higher-speed mobile broadband devices.  That was true at least up until
2.6.24.

Furthermore, up until this point, I have not seen mobile broadband
adapters (that aren't cellphones connected via USB) that *are* CDC-ACM
compliant.  Everything previously has advertised proprietary interfaces,
some of which are serial ports and some of which are not.

Most mobile broadband cards *do* have more than one TTY, the others are
used for additional control ports or proprietary access for stuff like
GPS and flashing the firmware.

Can we get the 'lsusb -v' output for this card?  I'm quite curious how
many endpoints and interfaces the device actually has.

Plus, are we expected to keep device names stable these days?  cdc-acm
is the catch-all driver, but if that driver is more "generic" and a
better driver is found, can we not update IDs just because the device
name may change?

Dan


