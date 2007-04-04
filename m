Return-Path: <linux-kernel-owner+w=401wt.eu-S1766915AbXDDT6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766915AbXDDT6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 15:58:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766916AbXDDT6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 15:58:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41464
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1766915AbXDDT6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 15:58:04 -0400
Date: Wed, 04 Apr 2007 12:58:03 -0700 (PDT)
Message-Id: <20070404.125803.35507943.davem@davemloft.net>
To: rmk+lkml@arm.linux.org.uk
Cc: dwmw2@infradead.org, paulus@samba.org, alan@lxorguk.ukuu.org.uk,
       flar@allandria.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070404090016.GC13134@flint.arm.linux.org.uk>
References: <20070404083803.GA13134@flint.arm.linux.org.uk>
	<20070404.014330.91315500.davem@davemloft.net>
	<20070404090016.GC13134@flint.arm.linux.org.uk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk+lkml@arm.linux.org.uk>
Date: Wed, 4 Apr 2007 10:00:16 +0100

> On Wed, Apr 04, 2007 at 01:43:30AM -0700, David Miller wrote:
> > Well the "bad hack" we use on sparc gives usable serial ports,
> > properly ordered and using /dev/ttyS0, with a proper matching
> > console selection.
> 
> Well yes, but it seems to have code in the architecture's early
> command line parsing to parse the "console=" argument to set this
> magical "serial_console" variable.
> 
> Is this an approach you recommend for all architectures?

The platform should use whatever is appropriate, and matches
firmware/bios/whatever conventions, to determine this stuff.

On Sparc you get an openfirmware environment variable called
"output-device" that can point to a framebuffer or serial
console device.

The user can override this on the kernel command line, of course, and
what they ask for will get translated properly.
