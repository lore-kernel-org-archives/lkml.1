Return-Path: <linux-kernel-owner+w=401wt.eu-S1423166AbXBUVWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423166AbXBUVWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 16:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423142AbXBUVWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 16:22:36 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:40888 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1423159AbXBUVWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 16:22:19 -0500
Date: Wed, 21 Feb 2007 16:22:17 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       <linux-usb-devel@lists.sourceforge.net>,
       Pete Zaitcev <zaitcev@redhat.com>, Greg KH <gregkh@suse.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] 2.6.20 kernel hang with USB drive and vfat
 doing ftruncate
In-Reply-To: <20070221125736.e5ff4206.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0702211621310.3435-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Feb 2007, Andrew Morton wrote:

> > > It seems like usb-storage and aio are completely off in the weeds.   
> > > Ideas?
> > 
> > It seems usb-storage should remove some kmalloc and use mempool() for
> > urb...  Is someone working on this? And idea?
> 
> I think Pete said that we're supposed to be using GFP_NOIO in there.

We _are_ using it.

> Not that it'll help much: the VM calls throttle_vm_writeout() for GFP_NOIO
> and GFP_NOFS allocations, which is a bug.  Because if the caller holds
> locks which prevent filesystem or IO progress, we deadlock.
> 
> I'll fix the VM if someone else fixes USB ;)

What else needs to be fixed?

Alan Stern

