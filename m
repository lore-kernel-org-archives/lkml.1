Return-Path: <linux-kernel-owner+w=401wt.eu-S2993098AbXCIKAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993098AbXCIKAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 05:00:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767143AbXCIKAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 05:00:21 -0500
Received: from mail11.syd.optusnet.com.au ([211.29.132.192]:54418 "EHLO
	mail11.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993099AbXCIKAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 05:00:19 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: 2.6.21-rc3: /proc broken
Date: Fri, 9 Mar 2007 20:59:54 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070307201915.4d579113.akpm@linux-foundation.org> <200703090856.45386.kernel@kolivas.org> <20070309085355.GB29959@flint.arm.linux.org.uk>
In-Reply-To: <20070309085355.GB29959@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703092059.54653.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 March 2007 19:53, Russell King wrote:
> On Fri, Mar 09, 2007 at 08:56:44AM +1100, Con Kolivas wrote:
> > I did make oldconfig from http://userweb.kernel.org/~akpm/ck/config.txt
> > and chose all the defaults. Then building your fat config with -rc3, 'ps'
> > hangs on qemu for almost 30 seconds and then at last produces a broken
> > output
>
> Let me guess - you have either a serial console or something like that
> and you're running these commands over said serial console?
>
> Or you have console directed to both a serial port and the VT and you're
> capturing this off the VT using gpm.
>
> Either way, "serial8250: too much work for irq4" is a printk which will
> be displayed by the kernel when it's unable to clear down work for the
> serial port within 256 loops or so of the interrupt handler; it's a
> protection against the box locking up.
>
> It not actually contained in any of the files.

Thank you very much for taking the time to explain it to me and I apologise 
for the false positive. It's very much due to running qemu directing 
everything to the serial console which is just as you say. Allowing qemu to 
output to graphic fixes the error. Unfortunately that also makes akpm's oops 
go away so I can't really reproduce it now. Perhaps the bug occurs due to 
interrupts being disabled for an extended time; it gives me something to look 
at now.

Thanks!

-- 
-ck
