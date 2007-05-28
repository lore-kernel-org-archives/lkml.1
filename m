Return-Path: <linux-kernel-owner+w=401wt.eu-S932382AbXE1WBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382AbXE1WBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 18:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbXE1WBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 18:01:10 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4262 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbXE1WBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 18:01:09 -0400
Date: Mon, 28 May 2007 23:00:56 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM/ARM26: Enable arbitary speed tty ioctls and split input/output speed
Message-ID: <20070528220056.GH5737@flint.arm.linux.org.uk>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <20070523172739.1d3a918c@the-village.bc.nu> <20070528193658.GF5737@flint.arm.linux.org.uk> <20070528145632.7c0ec1c9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070528145632.7c0ec1c9.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 02:56:32PM -0700, Andrew Morton wrote:
> On Mon, 28 May 2007 20:36:58 +0100 Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> 
> > On Wed, May 23, 2007 at 05:27:39PM +0100, Alan Cox wrote:
> > > Add the ioctls and values needed for this to the ARM26/ARM32 ports. The
> > > actual code has been in the base kernel for a while and automatically
> > > turns on when a port sets the required defines.
> > 
> > Did you forget to provide a termios2 structure for ARM?  Hope you
> > remembered for the other arches:
> > 
> > drivers/char/tty_ioctl.c: In function `set_termios':
> > drivers/char/tty_ioctl.c:429: error: invalid application of `sizeof' to incomplete type `termios2'
> > drivers/char/tty_ioctl.c: In function `n_tty_ioctl':
> > drivers/char/tty_ioctl.c:732: error: invalid application of `sizeof' to incomplete type `termios2'
> > 
> > Will copy the i386 version into ARM's termbits.h
> > 
> 
> I think Alan's per-arch patch was dependent upon an earlier patch.  He
> fooled everyone by sending them out in random order, without sequence
> nnumbers and without telling anyone the dependencies.  And the add-termios2
> patch was a single megapatch whereas the enablement patches were a per-arch
> sprinkle.
> 
> 
> Here's tha arm bit of
> lots-of-architectures-enable-arbitary-speed-tty-support.patch: 

I hope that isn't because it's wrong.  It's "termios2" not "termios_2".

> Or you can just drop this patch and I'll resend it once
> lots-of-architectures-enable-arbitary-speed-tty-support.patch is merged up.

I think I'd prefer to commit my own version copied from x86, which at
least passes a build test.  Doing that now.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
