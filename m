Return-Path: <linux-kernel-owner+w=401wt.eu-S1752885AbYKXOWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbYKXOWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 09:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbYKXOVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 09:21:49 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58309 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751643AbYKXOVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 09:21:48 -0500
Date: Mon, 24 Nov 2008 14:21:28 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thomas Pfaff <tpfaff@pcs.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: Fix async io write notifications
Message-ID: <20081124142128.11cb3d06@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0811241401280.8443@lxtpfaff.pcs.ditec.de>
References: <Pine.LNX.4.64.0811241401280.8443@lxtpfaff.pcs.ditec.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2008 14:40:15 +0100 (CET)
Thomas Pfaff <tpfaff@pcs.com> wrote:

> he N_TTY ldisc layer does not send SIGIO POLL_OUTs correctly when output is 
> possible due to flawed handling of the TTY_DO_WRITE_WAKEUP bit. It will either 
> send no SIGIOs at all or on every tty wakeup.
> 
> The fix is to set the bit when the tty driver write would block and test and 
> clear it on write wakeup.
> 
> Signed-off-by: Thomas Pfaff <tpfaff@pcs.com>

I had done a patch already but yours is somewhat nicer so I've merged
yours instead with some tweaks as it clashed with an existing N_TTY patch

I left the tty->fasync check in the if (in case the user clears async I/O
events) and I reversed the tests on the end of n_tty_write simply
because the compiler has the variables we need to check to hand but not
tty->fasync.

This all looks good to me. It breaks on ptys but that is another bug and
I'll merge a patch to fix the ptys next.

Alan
