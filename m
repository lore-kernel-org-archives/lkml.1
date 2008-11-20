Return-Path: <linux-kernel-owner+w=401wt.eu-S1756435AbYKTQrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435AbYKTQrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 11:47:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbYKTQrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 11:47:39 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39126 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753456AbYKTQrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 11:47:39 -0500
Date: Thu, 20 Nov 2008 16:47:19 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thomas Pfaff <tpfaff@pcs.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question about TTY_DO_WRITE_WAKEUP
Message-ID: <20081120164719.13daa129@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0811201700320.1274@lxtpfaff.pcs.ditec.de>
References: <Pine.LNX.4.64.0811201007120.30713@lxtpfaff.pcs.ditec.de>
	<20081120131726.2636b559@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.64.0811201446380.21561@lxtpfaff.pcs.ditec.de>
	<20081120143147.5e8d6c20@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.64.0811201536150.23073@lxtpfaff.pcs.ditec.de>
	<20081120155502.608812d9@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.64.0811201700320.1274@lxtpfaff.pcs.ditec.de>
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

> > The base code should probably really use test_and_clear_bit() when
> > calling that method.
> 
> Why should you test it, clear it and set it again in n_tty_write_wakeup ?

Because it should only be set again if a wakeup is needed. If the fasync
list for the tty is now empty it should stay clear.

> IMHO a SIGIO on write possible should always be generated if the user wants it, 
> currently it is generated when the user wants it and the tty driver enables the 
> TTY_DO_WRITE_WAKEUP flag. Unfortunately most drivers don't set it.

It is nothing to do with the driver. The line discipline sets it - or
rather should set it. If you have a case where you get an EAGAIN or short
write and the line discipline is not setting it then that is what needs
fixing not the drivers.

> Once a write fails with EAGAIN a flag can be set and only in that case a SIGIO is 
> generated, afterwards the bit is cleared. Maybe that is what TTY_DO_WRITE_WAKEUP 
> was intended for. 

Correct.
