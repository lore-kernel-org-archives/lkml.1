Return-Path: <linux-kernel-owner+w=401wt.eu-S1946170AbXBIHgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946170AbXBIHgz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 02:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946175AbXBIHgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 02:36:55 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2917 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946170AbXBIHgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 02:36:54 -0500
Date: Fri, 9 Feb 2007 07:36:40 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: David Gibson <david@gibson.dropbear.id.au>,
       Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: genirq: Add a set_irq_handler_locked() function
Message-ID: <20070209073640.GA29988@flint.arm.linux.org.uk>
Mail-Followup-To: David Gibson <david@gibson.dropbear.id.au>,
	Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
References: <20070207023353.GC23870@localhost.localdomain> <1170940949.3646.1.camel@chaos> <20070209034842.GF3489@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070209034842.GF3489@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 09, 2007 at 02:48:42PM +1100, David Gibson wrote:
> At present set_irq_handler() and all the existing variants take the
> desc->lock for the irq in question before adjusting the irq's flow
> handler.  This can cause problems for irq chips for which a given
> interrupt can be either level or edge depending on what's attached.

Are you sure you need to change the flow handler depending on how
you program the device?

Since the outset of this design, I've had what are essentially edge
based interrupt sources using the "level" handlers because they haven't
had a "broken" edge implementation.  By that, I mean that the masking
is done in such a way that you miss edges when the source is masked.

If you do not miss edges while the source is masked, there's no point
in having the complexity of the "edge" based handler in the path - it
buys you nothing.  Just use the "level" handler instead.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
