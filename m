Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbXCIIyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbXCIIyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 03:54:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbXCIIyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 03:54:10 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3115 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbXCIIyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 03:54:08 -0500
Date: Fri, 9 Mar 2007 08:53:56 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Con Kolivas <kernel@kolivas.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc3: /proc broken
Message-ID: <20070309085355.GB29959@flint.arm.linux.org.uk>
Mail-Followup-To: Con Kolivas <kernel@kolivas.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070307201915.4d579113.akpm@linux-foundation.org> <200703090152.49253.kernel@kolivas.org> <200703090856.45386.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703090856.45386.kernel@kolivas.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 08:56:44AM +1100, Con Kolivas wrote:
> I did make oldconfig from http://userweb.kernel.org/~akpm/ck/config.txt and 
> chose all the defaults. Then building your fat config with -rc3, 'ps' hangs 
> on qemu for almost 30 seconds and then at last produces a broken output

Let me guess - you have either a serial console or something like that
and you're running these commands over said serial console?

Or you have console directed to both a serial port and the VT and you're
capturing this off the VT using gpm.

Either way, "serial8250: too much work for irq4" is a printk which will
be displayed by the kernel when it's unable to clear down work for the
serial port within 256 loops or so of the interrupt handler; it's a
protection against the box locking up.

It not actually contained in any of the files.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
