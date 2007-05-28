Return-Path: <linux-kernel-owner+w=401wt.eu-S932597AbXE1V4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597AbXE1V4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 17:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbXE1V4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 17:56:47 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750852AbXE1V4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 17:56:47 -0400
Date: Mon, 28 May 2007 14:56:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM/ARM26: Enable arbitary speed tty ioctls and split
 input/output speed
Message-Id: <20070528145632.7c0ec1c9.akpm@linux-foundation.org>
In-Reply-To: <20070528193658.GF5737@flint.arm.linux.org.uk>
References: <20070523172739.1d3a918c@the-village.bc.nu>
	<20070528193658.GF5737@flint.arm.linux.org.uk>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 May 2007 20:36:58 +0100 Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> On Wed, May 23, 2007 at 05:27:39PM +0100, Alan Cox wrote:
> > Add the ioctls and values needed for this to the ARM26/ARM32 ports. The
> > actual code has been in the base kernel for a while and automatically
> > turns on when a port sets the required defines.
> 
> Did you forget to provide a termios2 structure for ARM?  Hope you
> remembered for the other arches:
> 
> drivers/char/tty_ioctl.c: In function `set_termios':
> drivers/char/tty_ioctl.c:429: error: invalid application of `sizeof' to incomplete type `termios2'
> drivers/char/tty_ioctl.c: In function `n_tty_ioctl':
> drivers/char/tty_ioctl.c:732: error: invalid application of `sizeof' to incomplete type `termios2'
> 
> Will copy the i386 version into ARM's termbits.h
> 

I think Alan's per-arch patch was dependent upon an earlier patch.  He
fooled everyone by sending them out in random order, without sequence
nnumbers and without telling anyone the dependencies.  And the add-termios2
patch was a single megapatch whereas the enablement patches were a per-arch
sprinkle.


Here's tha arm bit of
lots-of-architectures-enable-arbitary-speed-tty-support.patch: 

diff -puN include/asm-arm/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support include/asm-arm/termbits.h
--- a/include/asm-arm/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support
+++ a/include/asm-arm/termbits.h
@@ -15,6 +15,17 @@ struct termios {
 	cc_t c_cc[NCCS];		/* control characters */
 };
 
+struct termios_2 {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
 struct ktermios {
 	tcflag_t c_iflag;		/* input mode flags */
 	tcflag_t c_oflag;		/* output mode flags */

Or you can just drop this patch and I'll resend it once
lots-of-architectures-enable-arbitary-speed-tty-support.patch is merged up.

