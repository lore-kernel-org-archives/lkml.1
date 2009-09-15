Return-Path: <linux-kernel-owner+w=401wt.eu-S1751238AbZIOIyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238AbZIOIyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 04:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbZIOIyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 04:54:39 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60484 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbZIOIyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 04:54:38 -0400
Date: Tue, 15 Sep 2009 10:54:41 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: jkosina@suse.cz
Subject: BUG: sleeping function called from invalid context at
	mm/slub.c:1717
Message-ID: <20090915085441.GF23126@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is new with todays -git:

BUG: sleeping function called from invalid context at mm/slub.c:1717
in_atomic(): 1, irqs_disabled(): 1, pid: 0, name: swapper
Pid: 0, comm: swapper Not tainted 2.6.31 #206
Call Trace:
 <IRQ>  [<ffffffff8103eb23>] __might_sleep+0xf3/0x110
 [<ffffffff810e4d83>] kmem_cache_alloc+0x123/0x170
 [<ffffffff813306c9>] hid_input_report+0x89/0x3a0
 [<ffffffffa00cd5f4>] hid_ctrl+0xa4/0x1f0 [usbhid]
 [<ffffffff8108a4c7>] ? handle_IRQ_event+0xa7/0x1e0
 [<ffffffffa004da1f>] usb_hcd_giveback_urb+0x3f/0xa0 [usbcore]
 [<ffffffffa0074ab4>] uhci_giveback_urb+0xb4/0x240 [uhci_hcd]
 [<ffffffffa00750e7>] uhci_scan_schedule+0x357/0xab0 [uhci_hcd]
 [<ffffffffa0077a01>] uhci_irq+0x91/0x190 [uhci_hcd]
 [<ffffffffa004d44e>] usb_hcd_irq+0x2e/0x70 [usbcore]
 [<ffffffff8108a4c7>] handle_IRQ_event+0xa7/0x1e0
 [<ffffffff8108c58c>] handle_fasteoi_irq+0x7c/0xf0
 [<ffffffff8100f176>] handle_irq+0x46/0xa0
 [<ffffffff8100e49a>] do_IRQ+0x6a/0xf0
 [<ffffffff8100c853>] ret_from_intr+0x0/0xa

And I notice there's a HID merge from yesterday, Jiri CC'ed.

-- 
Jens Axboe

