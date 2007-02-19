Return-Path: <linux-kernel-owner+w=401wt.eu-S932650AbXBSUwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650AbXBSUwG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 15:52:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932652AbXBSUwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 15:52:06 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4581 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932650AbXBSUwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 15:52:04 -0500
Date: Mon, 19 Feb 2007 20:51:53 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: Jose Goncalves <jose.goncalves@inov.pt>,
       Frederik Deweerdt <deweerdt@free.fr>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Serial related oops
Message-ID: <20070219205153.GH27370@flint.arm.linux.org.uk>
Mail-Followup-To: "Michael K. Edwards" <medwards.linux@gmail.com>,
	Jose Goncalves <jose.goncalves@inov.pt>,
	Frederik Deweerdt <deweerdt@free.fr>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <20070220132909.GD566@slug> <20070219134539.GA27370@flint.arm.linux.org.uk> <20070220142442.GF566@slug> <20070219143520.GB27370@flint.arm.linux.org.uk> <20070220144814.GJ566@slug> <20070219150508.GD27370@flint.arm.linux.org.uk> <45D9D073.7020701@inov.pt> <20070219164200.GF27370@flint.arm.linux.org.uk> <45D9E46C.4030408@inov.pt> <f2b55d220702191237o2e6c4211u58a77deae1febe70@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2b55d220702191237o2e6c4211u58a77deae1febe70@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 19, 2007 at 12:37:00PM -0800, Michael K. Edwards wrote:
> What we've seen on our embedded ARM is that enabling an interrupt that
> is shared between multiple UARTs, at a stage when you have not set up
> all the data structures touched by the ISR and softirq, can have
> horrible consequences, including soft lockups and fandangos on core.

Incorrect.  We have:

1. registered an interrupt handler at this point.
2. disabled interrupts (we're under the spin lock)

So, no interrupt will be seen by the CPU since the interrupt is masked.

The test is intentionally designed to be safe from the interrupt
generation point of view.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
