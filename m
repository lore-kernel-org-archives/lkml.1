Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699AbZD2Dba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbZD2Dba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 23:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbZD2DbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 23:31:20 -0400
Received: from kroah.org ([198.145.64.141]:38403 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbZD2DbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 23:31:19 -0400
Date: Tue, 28 Apr 2009 20:24:46 -0700
From: Greg KH <greg@kroah.com>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.30-rc3] platform_bus:  remove "which
	platform_data?" confusion
Message-ID: <20090429032446.GC23062@kroah.com>
References: <200904271943.40588.david-b@pacbell.net> <20090428050742.GB17432@kroah.com> <200904280228.07346.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200904280228.07346.david-b@pacbell.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 02:28:07AM -0700, David Brownell wrote:
> No comment on the bugfix part of $SUBJECT patch?

Well, no, I'm assuming it is correct :)

Should I just revert the original change, if the fact that busses are
using the platform_data field?

> On Monday 27 April 2009, Greg KH wrote:
> > 
> > > Those patches seem to support what I think is a misguided
> > > notion:  that somehow device.platform_data might move into
> > > the platform_device.  The problem with that idea is that it's
> > > a general purpose hook, and is used by other busses to provide
> > > board-specific configuration data ... not just for platform_bus.
> > 
> > It is?  What other busses do this?
> 
> SPI and I2C come quickly to mind...
> 
> Basically, *any* bus that could ever be used on an embedded
> system may need platform_data to explain how each discrete
> chip has been wired up on that particular board.  Very few
> such busses can self-enumerate like PCI or USB.  And most of
> the chips sitting on such busses expect to interface to fairly
> random external hardware.
> 
> And come to think of it, I've seen cases with PCI and USB
> where board-specific config data is needed.  PCI doesn't
> always wrap it up in some ACPI bytecode, and sometimes USB
> devices use "transceiverless link" hookup, so the board
> can just hook up using a differential pair.
> 
> SDIO/MMC doesn't tend to need it though, even for SDIO
> WLAN or MMC/SD storage links (eMMC, CE-ATA, etc).
> 
> 
> > And why, can't they use their own bus private data pointers?
> 
> ENOPATCH.  ;)
> 
> Though ... since devices on *any* bus may need this, I
> don't much see the point of modifying every bus like that.

Fair enough, no objection from me.

thanks,

greg k-h
