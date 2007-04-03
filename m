Return-Path: <linux-kernel-owner+w=401wt.eu-S966212AbXDDAcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966212AbXDDAcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 20:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966213AbXDDAcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 20:32:14 -0400
Received: from adsl-216-102-214-42.dsl.snfc21.pacbell.net ([216.102.214.42]:51343
	"EHLO cynthia.pants.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966212AbXDDAcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 20:32:13 -0400
Date: Tue, 3 Apr 2007 14:29:28 -0700
From: Brad Boyer <flar@allandria.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
Message-ID: <20070403212928.GA12951@cynthia.pants.nu>
References: <1175610345.2665.15.camel@shinybook.infradead.org> <17938.57292.870224.132415@cargo.ozlabs.ibm.com> <1175642916.10567.24.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175642916.10567.24.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 07:28:36PM -0400, David Woodhouse wrote:
> I agree to a certain extent -- but then again, why should a user know or
> care about the name /dev/ttyS0 _either_? A GUI PPP dialer should be
> listing the available serial ports in the system whatever their names
> are.

The moment you do serial console, the user needs to know. I would hate
having to have console=ttyPZ0 in my kernel command line. Does that even
work? I didn't see a change to the console setup in your patch. Serial
is for much more than modems and PDA sync. In fact, I would think that
many more Linux systems these days use serial for console than for any
other purpose due to the use of such setups in large data centers and
the reduction in serial peripherals for desktop computers.

> And nobody _forces_ you to use the name ttyPZ0. If you really want, you
> can call it ttyS0.... just mknod /dev/ttyS0 204 192
> 
> You could even have udev rules which share the /dev/ttyS$N namespace
> between _all_ kinds of serial ports, if you really want to.
> 
> Abusing the 8250 device numbers prevents the 8250 module from being
> loaded at the same time as pmac_zilog, and means you can't have both
> internal port and PCMCIA or PCI 8250 ports active at the same time.

The TTY_MAJOR should have never belonged to 8250.c in the first place.
I know it's just my opinion, but I think this major device should be
owned by the serial core, and it shouldn't matter what chip drives each
individual port. Each hardware driver should just register with the
core how many ports it has and should be allocated from the same range.

This situation is purely a side-effect of the fact that all the
original Linux supported hardware used the 8250 driver and everyone
who didn't use 8250 was marginalized enough that they got ignored.

	Brad Boyer
	flar@allandria.com

