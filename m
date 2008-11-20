Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbYKTPza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbYKTPza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbYKTPzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 10:55:22 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51282 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752662AbYKTPzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 10:55:22 -0500
Date: Thu, 20 Nov 2008 15:55:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thomas Pfaff <tpfaff@pcs.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question about TTY_DO_WRITE_WAKEUP
Message-ID: <20081120155502.608812d9@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0811201536150.23073@lxtpfaff.pcs.ditec.de>
References: <Pine.LNX.4.64.0811201007120.30713@lxtpfaff.pcs.ditec.de>
	<20081120131726.2636b559@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.64.0811201446380.21561@lxtpfaff.pcs.ditec.de>
	<20081120143147.5e8d6c20@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.64.0811201536150.23073@lxtpfaff.pcs.ditec.de>
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

> But n_tty_write_wakeup is only called from tty_wakeup when this bit is already 
> set, therefore it makes no sense to set this bit in n_tty_write_wakeup again.

The base code should probably really use test_and_clear_bit() when
calling that method.
> 
> The flow looks to me as
> 
> If the tty driver sets TTY_DO_WRITE_WAKEUP a SIGIO is generated on every 
> tty_wakeup.
> 
> If it is not set then n_tty_write_wakeup is never called and a SIGIO is not 
> generated.

Which isn't perfect (excess SIGIO cases) but doesn't seem incorrect. If
you've not blocked the tty output buffer then write() has not returned a
short write and no SIGIO is due.

Alan
