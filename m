Return-Path: <linux-kernel-owner+w=401wt.eu-S1760493AbYDYITX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760493AbYDYITX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 04:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbYDYITH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 04:19:07 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35053 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbYDYITF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 04:19:05 -0400
Date: Fri, 25 Apr 2008 11:19:02 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org, dsd@gentoo.org, linux-usb@vger.kernel.org,
       vegardno@ifi.uio.no, James.Bottomley@HansenPartnership.com,
       linux-scsi@vger.kernel.org
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting
 root
In-Reply-To: <20080425070439.GA18915@one-eyed-alien.net>
Message-ID: <Pine.LNX.4.64.0804251116000.758@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.44L0.0804241704220.14840-100000@iolanthe.rowland.org>
 <Pine.LNX.4.64.0804250022160.1209@sbz-30.cs.Helsinki.FI> <20080424225604.GA18737@kroah.com>
 <20080424233048.GQ16272@one-eyed-alien.net> <Pine.LNX.4.64.0804250921090.27978@sbz-30.cs.Helsinki.FI>
 <20080425070439.GA18915@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

On Thu, 24 Apr 2008, Matthew Dharm wrote:
> > > This also has all sorts of races between do_mounts 'waiting' and the actual
> > > USB device enumeration.  It's entirely possible that the kernel loads via
> > > BIOS, the USB drivers are loaded, that forces devices to disconnect/reset,
> > > and they take a while to re-enumerate.  During that delay, the kernel gets
> > > to do_mount; now, no devices show in this "waiting for scan" count.

On Fri, Apr 25, 2008 at 09:30:52AM +0300, Pekka J Enberg wrote:
> > So how does that happen? ->storage_probe fails and driver core calls it 
> > later at some point?

On Fri, 25 Apr 2008, Matthew Dharm wrote:
> There's no guarantee that storage_probe is going to get called in a timely
> manner.

How can we add such a guarantee? Don't we have this problem with any other 
storage devices?

			Pekka
