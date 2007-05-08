Return-Path: <linux-kernel-owner+w=401wt.eu-S968313AbXEHPtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968313AbXEHPtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 11:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966829AbXEHPtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 11:49:19 -0400
Received: from twin.jikos.cz ([213.151.79.26]:53630 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965880AbXEHPtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 11:49:16 -0400
Date: Tue, 8 May 2007 17:49:00 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Satyam Sharma <satyam.sharma@gmail.com>
cc: chris@pcburn.com, linux-kernel@vger.kernel.org,
       Marcel Holtmann <marcel@holtmann.org>,
       bluez-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: Getting make net/built-in.o Error with 2.6.21.1 Build
In-Reply-To: <a781481a0705071725i1d802dfejbcdaca4ab0a1ff55@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705081740550.16923@twin.jikos.cz>
References: <463FB6B0.3070005@pcburn.com> <a781481a0705071725i1d802dfejbcdaca4ab0a1ff55@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Satyam Sharma wrote:

> >   CC      init/version.o
> >   LD      init/built-in.o
> >   LD      .tmp_vmlinux1
> > net/built-in.o: In function `hidp_add_connection':
> > (.text+0x8bb08): undefined reference to `hid_ff_init'
> > make: *** [.tmp_vmlinux1] Error 1
> You've got CONFIG_BT_HIDP=y there but CONFIG_USB_HID=m. The trivial 
> patch below solves it. To test, you can just "make oldconfig" on the 
> same .config that broke above and then proceed to make bzImage.

I'd say we need a different fix here. First, the question is whether there 
are any force-feedback devices, supported by USBHID force-feedback layer, 
which have a bluetooth version?

If there are none of them, we could just drop the FF initialization 
completely for now. 

On the other hand if there are such devices, just calling hid_ff_init() is 
presently not enough anyway, as the force feedback drivers for HID devices 
are currently USB-transport specific.

-- 
Jiri Kosina
