Return-Path: <linux-kernel-owner+w=401wt.eu-S1758542AbYDYGbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542AbYDYGbN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 02:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756804AbYDYGaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 02:30:55 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41708 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317AbYDYGay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 02:30:54 -0400
Date: Fri, 25 Apr 2008 09:30:52 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org, dsd@gentoo.org, linux-usb@vger.kernel.org,
       vegardno@ifi.uio.no, James.Bottomley@HansenPartnership.com,
       linux-scsi@vger.kernel.org
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting
 root
In-Reply-To: <20080424233048.GQ16272@one-eyed-alien.net>
Message-ID: <Pine.LNX.4.64.0804250921090.27978@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.44L0.0804241704220.14840-100000@iolanthe.rowland.org>
 <Pine.LNX.4.64.0804250022160.1209@sbz-30.cs.Helsinki.FI> <20080424225604.GA18737@kroah.com>
 <20080424233048.GQ16272@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2008, Matthew Dharm wrote:
> This also has all sorts of races between do_mounts 'waiting' and the actual
> USB device enumeration.  It's entirely possible that the kernel loads via
> BIOS, the USB drivers are loaded, that forces devices to disconnect/reset,
> and they take a while to re-enumerate.  During that delay, the kernel gets
> to do_mount; now, no devices show in this "waiting for scan" count.

So how does that happen? ->storage_probe fails and driver core calls it 
later at some point?

On Thu, 24 Apr 2008, Matthew Dharm wrote:
> The right way to do this is via initrd and something like devlabel to wait
> for a specific device to appear.  On some systems, you may want to wait for
> several devices to appear.

You should be able to boot from an external USB disk without initrd. 
That's why we have the current root_delay= hack.

		Pekka
