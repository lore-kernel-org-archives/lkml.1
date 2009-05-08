Return-Path: <linux-kernel-owner+w=401wt.eu-S1763733AbZEHOJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763733AbZEHOJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 10:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763373AbZEHOG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 10:06:27 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56692 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1763336AbZEHOG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 10:06:26 -0400
Date: Fri, 8 May 2009 10:06:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Pantelis Koukousoulas <pktoss@gmail.com>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: usbfs, claiming entire usb devices
In-Reply-To: <ac3eb2510905071612v61a27760hffc684ee87df9249@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0905081000140.3010-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 May 2009, Kay Sievers wrote:

> You mentioned earlier, that you would need to match the holder of the
> "lock" and the one that accesses the device?

Yes.  That is, a process shouldn't be allowed to access a locked device 
unless that process is the lock holder.

> Wouldn't it be sufficient already, if you can take a "lock" at the
> specific port, that prevents the kernel to access the device when it
> shows up?

I don't know how the people requesting this feature would feel about
that.  They seem to want to lock out other processes as well as locking
out the kernel.

> You thought of supporting a number of different users, with different
> uids, or would that be a root-only action?

A typical use case would be somebody running an emulator like QEMU.  In 
theory there could be multiple QEMU processes running concurrently, 
each owning a different set of ports.  The uids might be different or 
they might all be the same.

Setting the lock permissions would be up to userspace.

Alan Stern

