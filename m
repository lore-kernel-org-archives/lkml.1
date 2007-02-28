Return-Path: <linux-kernel-owner+w=401wt.eu-S932562AbXB1W0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562AbXB1W0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 17:26:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932561AbXB1W0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 17:26:46 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3493 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932562AbXB1W0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 17:26:45 -0500
Date: Wed, 28 Feb 2007 22:26:30 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/2] Define FIXED_PORT flag for serial_core
Message-ID: <20070228222630.GA11999@flint.arm.linux.org.uk>
Mail-Followup-To: David Gibson <david@gibson.dropbear.id.au>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
	linuxppc-dev@ozlabs.org
References: <20070220031717.GI17818@localhost.localdomain> <20070220031951.56492DDD09@ozlabs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070220031951.56492DDD09@ozlabs.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 02:19:51PM +1100, David Gibson wrote:
> Therefore, this patch defines a UPF_FIXED_PORT flag for the uart_port
> structure.  If this flag is set when the serial port is configured,
> any attempts to alter the port's type, io address, irq or base clock
> with setserial are ignored.

I've been wondering about this, and it is questionable whether we
should allow any serial port which isn't owned by the legacy platform
device (the one called "serial8250", iow by the 8250 driver itself)
to have the base addresses and interrupts changed.

IOW, we apply this "fixed port" to any port registered by probe
modules external to the 8250 driver itself, such as PCI, PNP, etc.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
