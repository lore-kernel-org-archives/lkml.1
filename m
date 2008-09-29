Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbYI2Xrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbYI2Xrw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 19:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbYI2Xrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 19:47:40 -0400
Received: from senator.holtmann.net ([87.106.208.187]:55875 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbYI2Xrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 19:47:39 -0400
Subject: Re: BUG kmalloc-16: Object already free
From: Marcel Holtmann <marcel@holtmann.org>
To: Rabin Vincent <rabin@rab.in>
Cc: Justin Mattock <justinmattock@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-bluetooth@vger.kernel.org
In-Reply-To: <20080929181752.GA2027@debian>
References: <dd18b0c30809281554g11ac7275x819812935b6ac68f@mail.gmail.com>
	 <20080929181752.GA2027@debian>
Content-Type: text/plain
Date: Tue, 30 Sep 2008 01:47:39 +0200
Message-Id: <1222732059.1825.29.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rabin,

> > After frying my system, I'm finally up and
> > running. Not sure if this was due to a git-pull
> > (only be a few days since the last pull), or what:
> > when waking from suspend I see this
> > (I know it says tainted in it, so this will be the only noise you'll
> > here from me on this);
> > 
> > [  274.327003] =============================================================================
> > [  274.327528] BUG kmalloc-16: Object already free
> > [  274.327877] -----------------------------------------------------------------------------
> > [  274.327879]
> > [  274.327890] INFO: Allocated in btusb_open+0x82/0x16f [btusb] age=0
> > cpu=1 pid=3763
> > [  274.327899] INFO: Freed in btusb_open+0x13d/0x16f [btusb] age=0
> > cpu=1 pid=3763
> > [  274.327905] INFO: Slab 0xc139a100 objects=64 used=62 fp=0xdcd08100
> > flags=0x400000c3
> 
> There's a commit in the latest git which looks like it will solve the
> btusb suspend/resume issues: 5fbcd260.. ("[Bluetooth] Fix USB disconnect
> handling of btusb driver").
> 
> Marcel / linux-bluetooth, I think this double free is a separate issue
> with the error handling, and the following patch should fix it.
> 
> ---
> From: Rabin Vincent <rabin@rab.in>
> Subject: [PATCH] btusb, bpa10x: fix double frees on error paths
> 
> Justin Mattock reported this double free in btusb:
> 
>   BUG kmalloc-16: Object already free
>   -----------------------------------------------------------------------------
> 
>   INFO: Allocated in btusb_open+0x82/0x16f [btusb] age=3D0 cpu=3D1 pid=3D3763
>   INFO: Freed in btusb_open+0x13d/0x16f [btusb] age=3D0 cpu=3D1 pid=3D3763
> 
> This occurs because the urb's transfer buffer is being freed separately
> in the error path even though the URB_FREE_BUFFER transfer_flag is set
> on the urb.
> 
> There are similar cases elsewhere in btusb and in bpa10x.  Fix all of
> them by removing the additional kfree()'s.

I haven't verified it yet, but it looks like a good catch. Let me double
check this on my test machine. Weird that we never noticed this before
since I have been using the btusb driver for a very long time now.

Regards

Marcel


