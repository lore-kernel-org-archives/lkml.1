Return-Path: <linux-kernel-owner+w=401wt.eu-S1764175AbYF3Tfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764175AbYF3Tfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbYF3Tf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:35:27 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42814 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751673AbYF3Tf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:35:26 -0400
Date: Mon, 30 Jun 2008 15:35:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stefan Becker <Stefan.Becker@nokia.com>
cc: David Brownell <david-b@pacbell.net>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>,
       ext Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] USB: fix interrupt disabling for HCDs with shared
 interrupt handlers
In-Reply-To: <48692B9C.7090608@nokia.com>
Message-ID: <Pine.LNX.4.44L0.0806301532500.2138-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008, Stefan Becker wrote:

> Hi,
> 
> here is the proposed patch to fix the problem. I hope I used git 
> correctly to generate it...

> This patch doesn't modify the interface of usb_add_hcd(), i.e. HCD code
> can still use IRQF_DISABLED. It will now silently convert this into an
> internal HCD flag and clear IRQF_DISABLED before requesting the interrupt
> from the Linux core. usb_hcd_irq() will check this flag to disable/re-enable
> the interrupts on a case by case basis.

Don't bother with this extra stuff.  All USB host controller drivers
want to have interrupts disabled when their IRQ handlers run.

Alan Stern

