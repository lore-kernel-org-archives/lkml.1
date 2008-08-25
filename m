Return-Path: <linux-kernel-owner+w=401wt.eu-S1755748AbYHYMtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbYHYMtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 08:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbYHYMtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 08:49:03 -0400
Received: from ns2.suse.de ([195.135.220.15]:52512 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753566AbYHYMtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 08:49:03 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Power management for SCSI
Date: Mon, 25 Aug 2008 14:50:07 +0200
User-Agent: KMail/1.9.9
Cc: Pavel Machek <pavel@suse.cz>, linux-pm@lists.linux-foundation.org,
       James.Bottomley@hansenpartnership.com,
       "Linux-pm mailing list" <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, teheo@novell.com
References: <Pine.LNX.4.44L0.0808191108440.2669-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808191108440.2669-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808251450.09292.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 19 August 2008 17:28:28 schrieb Alan Stern:
> On Tue, 19 Aug 2008, Oliver Neukum wrote:
 
> > I suggest by talking to the HLDs.
> 
> Why would the HLD (= ULD?) know?
> 
> For example, consider a USB disk drive.  How is sd.c (the HLD) supposed 
> to know that it's not safe to suspend the USB link without spinning 
> down the drive?  Or consider a traditional SCSI parallel interface

The HLD is responsible for suspending the disk in case the system is
suspended. The HLD must know how to safely suspend a device. It may be
overcautious, but it'll work.

> > It seems to me that abstractly talking there are three criteria for suspension
> > 
> > - the cpu needs to talk to the device now
> 
> I.e., whether the idle timeout has expired, right?
> 
> > - the device may need to talk to the CPU at unpredictable times
> 
> I.e, whether remote wakeup needs to be enabled, right?

I am talking about correctness for controllers. So remote wakeup may or may not
be available. Likewise the bus may be able to predict how long it'll be idle.
 
> > - suspending has side effects
> 
> I'm not sure what you mean by that.  Suspension always has side effects 
> of one kind or another.

But not outside the controller. If you suspend the root hub of a usb bus,
you suspend everything on the bus. It's a feature of the hardware. Other
busses are different.


> There's nothing about my suspend framework to prevent a driver from 
> autosuspending its device while the children are still active.  
> Rather, the framework insists on notifications going the other way: 
> The driver has to be told whenever one of its device's children is 
> suspended or resumed.

That's the problem. You don't tell the children when the parent might want
to suspend.

	Regards
		Oliver
