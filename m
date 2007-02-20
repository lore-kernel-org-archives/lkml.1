Return-Path: <linux-kernel-owner+w=401wt.eu-S964837AbXBTMDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964837AbXBTMDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 07:03:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964853AbXBTMDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 07:03:33 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44442 "EHLO
	localhost.localdomain" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S964837AbXBTMDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 07:03:22 -0500
Date: Tue, 20 Feb 2007 13:07:01 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: Andrew Morton <akpm@osdl.org>, <linux-kernel@vger.kernel.org>,
       <rmk@arm.linux.org.uk>, <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH 1/2] Define FIXED_PORT flag for serial_core
Message-ID: <20070220130701.00503673@localhost.localdomain>
In-Reply-To: <20070220031951.56492DDD09@ozlabs.org>
References: <20070220031717.GI17818@localhost.localdomain>
	<20070220031951.56492DDD09@ozlabs.org>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007 14:19:51 +1100 (EST)
David Gibson <david@gibson.dropbear.id.au> wrote:

> At present, the serial core always allows setserial in userspace to
> change the port address, irq and base clock of any serial port.  That
> makes sense for legacy ISA ports, but not for (say) embedded ns16550
> compatible serial ports at peculiar addresses.  In these cases, the
> kernel code configuring the ports must know exactly where they are,
> and their clocking arrangements (which can be unusual on embedded
> boards).  It doesn't make sense for userspace to change these
> settings.
> 
> Therefore, this patch defines a UPF_FIXED_PORT flag for the uart_port
> structure.  If this flag is set when the serial port is configured,
> any attempts to alter the port's type, io address, irq or base clock
> with setserial are ignored.
> 
> In addition this patch uses the new flag for on-chip serial ports
> probed in arch/powerpc/kernel/legacy_serial.c, and for other
> hard-wired serial ports probed by drivers/serial/of_serial.c.
> 
> Signed-off-by: David Gibson <dwg@au1.ibm.com>
>
Acked-by: Alan Cox <alan@redhat.com>
