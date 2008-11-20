Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbYKTOcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbYKTOcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbYKTOcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:32:07 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56225 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754758AbYKTOcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:32:06 -0500
Date: Thu, 20 Nov 2008 14:31:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thomas Pfaff <tpfaff@pcs.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question about TTY_DO_WRITE_WAKEUP
Message-ID: <20081120143147.5e8d6c20@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0811201446380.21561@lxtpfaff.pcs.ditec.de>
References: <Pine.LNX.4.64.0811201007120.30713@lxtpfaff.pcs.ditec.de>
	<20081120131726.2636b559@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.64.0811201446380.21561@lxtpfaff.pcs.ditec.de>
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

> Is the TTY_DO_WRITE_WAKEUP bit some kind of cruft that can be removed entirely 
> or should i generate a patch for serial devices only ?

It shouldn't happen at the serial level. The line discipline sets the
flag as and when it has data for the process above.

The expected flow in normal use is

	app writes to tty
		data goes to n_tty ldisc
			goes to tty
		n_tty ldisc seems tty blocked
		n_tty ldisc sets DO_WRITE_WAKEUP

	tty gets ucongested
		calls n_tty write_wakeup
			SIGIO sent
			Flag set again

The important part of the logic is in n_tty.c and tty_io.c

Alan
