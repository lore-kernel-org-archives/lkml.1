Return-Path: <linux-kernel-owner+w=401wt.eu-S936059AbXG2Ulf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936059AbXG2Ulf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 16:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933894AbXG2Ul2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 16:41:28 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43629 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760881AbXG2Ul1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 16:41:27 -0400
Date: Sun, 29 Jul 2007 21:41:10 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [BUG] undefined reference to `kobject_actions'
Message-ID: <20070729204110.GB18225@flint.arm.linux.org.uk>
References: <20070729193401.GA18225@flint.arm.linux.org.uk> <20070729193704.GA27994@flint.arm.linux.org.uk> <1185739145.2469.0.camel@lov.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185739145.2469.0.camel@lov.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 09:59:05PM +0200, Kay Sievers wrote:
> 
> On Sun, 2007-07-29 at 20:37 +0100, Russell King wrote:
> > On Sun, Jul 29, 2007 at 08:34:01PM +0100, Russell King wrote:
> > > Many ARM platforms fail to build with the following:
> > > 
> > > drivers/built-in.o: In function `store_uevent':
> > > hid-input.c:(.text+0x19c4c): undefined reference to `kobject_actions'
> > > 
> > > It appears that if hotplug is disabled, kobject_actions is ifdef'd
> > > away but hid-input still references it.
> > 
> > What I also meant to say is that it looks like it's caused by
> > commit 60a96a59569bab85571d0089682109bd3324e896.
> > 
> > Presumably if hotplug is disabled, we want store_uevent to be
> > removed as well?
> 
> Does this patch fix it?
>   http://lkml.org/lkml/2007/7/20/143

Yup, thanks.  Any idea when this fix will hit mainline?  Looks like
it's 9 days old, and it fixes real build errors.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
