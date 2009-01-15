Return-Path: <linux-kernel-owner+w=401wt.eu-S1756934AbZAOPNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934AbZAOPNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 10:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbZAOPNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 10:13:39 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:47671 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753272AbZAOPNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 10:13:38 -0500
Date: Thu, 15 Jan 2009 10:13:37 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: ozan@pardus.org.tr, Iwo Mergler <iwo@call-direct.com.au>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: A really interesting mass-storage BUG introduced after 2.6.18
In-Reply-To: <496EC614.4040307@call-direct.com.au>
Message-ID: <Pine.LNX.4.44L0.0901151010110.2490-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009, Iwo Mergler wrote:

> > 
> > This shows the computer sending a TEST UNIT READY command to the drive, 
> > and the drive reporting Unit Attention: Media not present.  So of 
> > course Linux believes there is no media loaded in the drive and doesn't 
> > try to read the partition table or anything else.
> > 
> > Presumably if the drive is plugged in during bootup then the BIOS does 
> > something to make this error status go away.  It's hard to guess what 
> > that would be, however.
> > 
> 
> It could be a matter of timing. Some badly designed USB devices have a
> dead time between power-up and being ready, but show up on the bus as
> if they where. The "Media not present" thing could be a symptom of this.

Good point.

> To verify it, try inserting the device slowly. The power contacts in
> the USB connector are longer than the data contacts and the device gets
> more time to boot.

Another timing-sensitive values you can set is the delay_use module
parameter for usb-storage.  It defaults to 5 seconds but perhaps you
need a longer delay.

Alan Stern

