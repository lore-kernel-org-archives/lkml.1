Return-Path: <linux-kernel-owner+w=401wt.eu-S1759619AbYFSSys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619AbYFSSys (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 14:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbYFSSyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 14:54:37 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:59200 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbYFSSyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 14:54:36 -0400
Date: Thu, 19 Jun 2008 12:54:19 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       dsd@gentoo.org, mdharm-usb@one-eyed-alien.net,
       linux-usb@vger.kernel.org, vegardno@ifi.uio.no,
       James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting root
Message-ID: <20080619185419.GN4392@parisc-linux.org>
References: <Pine.LNX.4.44L0.0804241704220.14840-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0804250022160.1209@sbz-30.cs.Helsinki.FI> <48118DDD.8010507@s5r6.in-berlin.de> <Pine.LNX.4.64.0804251110400.758@sbz-30.cs.Helsinki.FI> <20080425091122.GA14990@parisc-linux.org> <20080619182310.GA30833@parisc-linux.org> <485AA7EA.6080105@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <485AA7EA.6080105@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2008 at 08:39:38PM +0200, Stefan Richter wrote:
> The problem is AFAIU not exactly how many Scsi_Host instances (initiator 
> port representations, or something remotely related to that) are 
> instantiated, but rather _when_ they are instantiated.  On multi 
> protocol buses or networks like USB and FireWire, it makes sense to 
> create the SCSI initiator port representation when we discovered that 
> there are actually SCSI targets on the bus or network.

I'm not convinced of that.  Why shouldn't we create one scsi host for
all USB scsi devices?  I know that today there's a certain amount of
per-device state stored in the scsi_host, but that should be fixable.

> scsi_scan's API is geared towards drivers which create one or more 
> initiator port representations right up front before going on target 
> discovery, right?

Today, yes.  The mail that I just pinged described a way to enhance the
API -- letting you tell scsi "I've started scanning, save me a place in
the queue" and "I've finished scanning, hook me up".

The advantage to this is that you can spend a lot more time waiting for
devices without increasing boot time significantly, since you wait while
the rest of the system initialises.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
