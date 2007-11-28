Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbXK1SAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbXK1SAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 13:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbXK1SA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 13:00:29 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41978 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbXK1SA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 13:00:28 -0500
Date: Wed, 28 Nov 2007 17:41:11 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Jean Delvare <khali@linux-fr.org>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Adrian Bunk <bunk@kernel.org>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org,
       Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [2.6 patch] some overdue I2C driver removal
Message-ID: <20071128174111.GA30084@flint.arm.linux.org.uk>
References: <20071024162528.GX30533@stusta.de> <20071024164347.GN4003@csclub.uwaterloo.ca> <20071128112357.3828d469@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128112357.3828d469@hyperion.delvare>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 11:23:57AM +0100, Jean Delvare wrote:
> There's no driver to write (i2c-gpio is the driver). Instead, the
> scx200 platform needs to implement the standard GPIO API. I don't think
> that it has happened yet, and last time this was discussed, someone
> (can't remember who, sorry), complained that the GPIO API "sucked" and
> that the scx200 platform would not be updated to use it. I didn't buy
> the claim due to a lack of argumentation and the fact that the GPIO
> infrastructure seems to work well enough for many other platforms.

There's actually a number of people who aren't thrilled by the concept
of a GPIO API.  The current API is quite limiting in that it isn't
actually a "generic" GPIO API - you can't address GPIOs on a GPIO
expander with it for instance.

Some of those issues are in the process of being resolved, but I
suspect that this is a classic case where you can not satisfy everyone.
There'll always be people who refuse to use whatever GPIO API.

> As far as I can see, the ixp2000 platform also doesn't implement the
> standard GPIO API yet, so of the 3 drivers that are about to be
> removed, only i2c-ixp4xx can be removed without functionality loss at
> the moment. Lennert, Russell, are there any plans to convert the
> ixp2000 platform to use the generic GPIO layer?

It's really for Lennert to comment on; while you may consider I'm the
overall ARM maintainer, that doesn't mean that I have access to the
entire set of ARM hardware.  Bit like expecting Linus to write working
drivers for SH4 without ever having had a SH4 platform... ;)

> Maybe I shouldn't have added this entry in feature-removal-schedule.txt
> in the first place: these drivers should ideally be dropped in favor of
> i2c-gpio, but it can only happen for platforms that implement the
> standard GPIO API.

... especially as those who need to comment on it don't get to see
Adrian's patches to remove them.

I think it's quite wrong to mark something "obsolete" and scheduling
it for removal unless there's an actual functioning replacement.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
