Return-Path: <linux-kernel-owner+w=401wt.eu-S933043AbXCUQvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043AbXCUQvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 12:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933059AbXCUQvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 12:51:47 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:60291 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933043AbXCUQvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 12:51:46 -0400
X-Greylist: delayed 893 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Mar 2007 12:51:46 EDT
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Keith Owens <kaos@ocs.com.au>
Subject: Re: PNPACPI probes serial twice, messes up serial console
Date: Wed, 21 Mar 2007 10:35:38 -0600
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>
References: <17887.1174373206@kao2.melbourne.sgi.com> <200703200832.24921.bjorn.helgaas@hp.com>
In-Reply-To: <200703200832.24921.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703211035.39340.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 March 2007 08:32, Bjorn Helgaas wrote:
> On Tuesday 20 March 2007 00:46, Keith Owens wrote:
> > Booting with 'console=tty console=ttyS0,9600'.  The serial console on
> > ttyS0 (0x3f8, irq 4) is probed twice, once from serial8250_init() and
> > again from serial_pnp_probe().
> 
> I played with this last summer, but was too timid to finish it
> and post it.  My plan was to remove the legacy SERIAL_PORT_DFNS,
> make platform devices for them, and only register the platform
> devices in the absence of PNP.
> 
> My motivation at the time was to prevent 8250 from claiming IRDA
> devices that happened to live at legacy UART addresses.  I also
> wanted to make IRDA (smsc-ircc2 in my case) smart enough to use
> PNP to locate its devices, since 8250 would no longer claim them.
> 
> Here's the dusty patch (against 2.6.18-rc1-mm2).  If it seems
> like a reasonable thing to do, I can update it, polish it up,
> add a changelog, and post it.

Keith, does this patch help?  Russell didn't complain about it, so
if it fixes your problem, maybe we could put it in -mm and see if
it breaks anything else.

Bjorn
