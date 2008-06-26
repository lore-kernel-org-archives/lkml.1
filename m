Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbYFZOZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbYFZOZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 10:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbYFZOZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 10:25:37 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40145 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751932AbYFZOZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 10:25:35 -0400
Date: Thu, 26 Jun 2008 10:25:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stefan Becker <Stefan.Becker@nokia.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: [REGRESSION] 2.6.24/25: random lockups when accessing external
 USB harddrive
In-Reply-To: <486337D4.1000904@nokia.com>
Message-ID: <Pine.LNX.4.44L0.0806261018340.2811-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008, Stefan Becker wrote:

> Hi,
> 
> ext Alan Stern wrote:
> > On Wed, 25 Jun 2008, Stefan Becker wrote:
> > 
> >> HCD URB list locked by usb_hcd_link_urb_to_ep!
> >>
> >> As far as I understand the matter this only can happen if 
> >> usb_hcd_link_urb_to_ep() gets interrupted while holding the spinlock. 
> >> But according to the contract at the header of the function it should be 
> >> called with interrupts disabled!
> > 
> > So it should.  Do you know how to test whether interrupts are enabled?  
> > There's a routine called raw_irqs_disabled() defined in 
> > include/asm/irqflags.h.  Stick it inside usb_hcd_link_urb_to_ep, and 
> > the first time it returns nonzero, do a dump_stack().

Typo: I should have said "the first time it returns zero..."

Do you have any of the RT patches installed?

> Tried both and got nothing. So either our reasoning is wrong or 
> something really weird is going on. I'll try to improve my debugging 
> code and use dump_stack() at the place where it locks up.

Well, it would be pretty surprising if spin_lock_irq or 
spin_lock_irqsave were misbehaving.

Something else you should try is clearing your "owner" string just
before the spinlock is released.  You could also add a check after the
release; if the spinlock can't be locked again immediately then
something is wrong.

Alan Stern

