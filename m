Return-Path: <linux-kernel-owner+w=401wt.eu-S1757063AbZIPGx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbZIPGx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 02:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756826AbZIPGx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 02:53:56 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44706 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbZIPGx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 02:53:56 -0400
Date: Wed, 16 Sep 2009 08:53:59 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG: sleeping function called from invalid context at
	mm/slub.c:1717
Message-ID: <20090916065359.GB23126@kernel.dk>
References: <20090915085441.GF23126@kernel.dk> <alpine.LNX.2.00.0909151202560.17028@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0909151202560.17028@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15 2009, Jiri Kosina wrote:
> On Tue, 15 Sep 2009, Jens Axboe wrote:
> 
> > This is new with todays -git:
> > 
> > BUG: sleeping function called from invalid context at mm/slub.c:1717
> > in_atomic(): 1, irqs_disabled(): 1, pid: 0, name: swapper
> > Pid: 0, comm: swapper Not tainted 2.6.31 #206
> > Call Trace:
> >  <IRQ>  [<ffffffff8103eb23>] __might_sleep+0xf3/0x110
> >  [<ffffffff810e4d83>] kmem_cache_alloc+0x123/0x170
> >  [<ffffffff813306c9>] hid_input_report+0x89/0x3a0
> >  [<ffffffffa00cd5f4>] hid_ctrl+0xa4/0x1f0 [usbhid]
> >  [<ffffffff8108a4c7>] ? handle_IRQ_event+0xa7/0x1e0
> >  [<ffffffffa004da1f>] usb_hcd_giveback_urb+0x3f/0xa0 [usbcore]
> >  [<ffffffffa0074ab4>] uhci_giveback_urb+0xb4/0x240 [uhci_hcd]
> >  [<ffffffffa00750e7>] uhci_scan_schedule+0x357/0xab0 [uhci_hcd]
> >  [<ffffffffa0077a01>] uhci_irq+0x91/0x190 [uhci_hcd]
> >  [<ffffffffa004d44e>] usb_hcd_irq+0x2e/0x70 [usbcore]
> >  [<ffffffff8108a4c7>] handle_IRQ_event+0xa7/0x1e0
> >  [<ffffffff8108c58c>] handle_fasteoi_irq+0x7c/0xf0
> >  [<ffffffff8100f176>] handle_irq+0x46/0xa0
> >  [<ffffffff8100e49a>] do_IRQ+0x6a/0xf0
> >  [<ffffffff8100c853>] ret_from_intr+0x0/0xa
> > 
> > And I notice there's a HID merge from yesterday, Jiri CC'ed.
> 
> Thanks for letting me know. The patch below should fix it.

Yes that works, thanks Jiri!

-- 
Jens Axboe

