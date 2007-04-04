Return-Path: <linux-kernel-owner+w=401wt.eu-S2992723AbXDDHwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992723AbXDDHwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 03:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992721AbXDDHwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 03:52:54 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4546 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992723AbXDDHwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 03:52:53 -0400
Date: Wed, 4 Apr 2007 08:52:44 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: dwmw2@infradead.org, paulus@samba.org, alan@lxorguk.ukuu.org.uk,
       flar@allandria.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
Message-ID: <20070404075244.GB3440@flint.arm.linux.org.uk>
Mail-Followup-To: David Miller <davem@davemloft.net>, dwmw2@infradead.org,
	paulus@samba.org, alan@lxorguk.ukuu.org.uk, flar@allandria.com,
	linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <20070404022544.59b022a6@the-village.bc.nu> <17939.10130.687893.167511@cargo.ozlabs.ibm.com> <1175663999.2932.8.camel@shinybook.infradead.org> <20070403.225006.119275067.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070403.225006.119275067.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 10:50:06PM -0700, David Miller wrote:
> From: David Woodhouse <dwmw2@infradead.org>
> Date: Wed, 04 Apr 2007 01:19:59 -0400
> 
> > I don't see why that 'should' be the case. Certainly it _isn't_ the case
> > on most supported platforms -- we have separate device numbers, and
> > names, for most types of ports. There's only one or two drivers which
> > abuse ttySn for anything other than 8250 ports.
> 
> sunsu, sunzilog, pmac_zilog, sunsab, etc.
> 
> The list is longer than you think.  In fact the convention is
> very well established.

... and has never ever worked along side the existing 8250 (or serial)
driver - therefore it can also be viewed as a long standing BUG.

We're really in this mess because it was decided that 8250 was going
to be called "serial", thereby causing everyone to believe that they
should be using the allocations for that driver. ;(

Had the allocation been called "PC 8250-based serial" in LANANA and
elsewhere, it probably wouldn't have been re-used.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
