Return-Path: <linux-kernel-owner+w=401wt.eu-S1031615AbXEAJ3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031615AbXEAJ3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 05:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031625AbXEAJ3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 05:29:44 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3925 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031608AbXEAJ3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 05:29:42 -0400
Date: Tue, 1 May 2007 10:29:33 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Corey Minyard <minyard@acm.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org
Subject: Re: Serial 8250: clear the lsr_break_flag at open
Message-ID: <20070501092933.GB18233@flint.arm.linux.org.uk>
Mail-Followup-To: Corey Minyard <minyard@acm.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-serial@vger.kernel.org
References: <20070430220858.GA28890@localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430220858.GA28890@localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 05:08:59PM -0500, Corey Minyard wrote:
> I think I've spotted a bug in the 8250 code, but I'm not really
> sure.

Yes, clearing lsr_break_flag prior to opening the port is probably a good
thing.

> I'm having a hard time understanding why the lsr_break_flag
> is necessary.

Merely reading the LSR clears status bits.  We read the LSR repeatedly
so that we can monitor the transmit FIFO when outputting serial console
messages.

This means that if you have a busy serial console, and you want to send
it a sysrq request, there's a chance that the break flag in the LSR will
be cleared by the transmit FIFO status polling code thereby being lost.

So, we need to remember that status, and we do this via the lsr_break_flag.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
