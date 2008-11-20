Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbYKTQ7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbYKTQ7P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 11:59:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbYKTQ67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 11:58:59 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50774 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752142AbYKTQ67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 11:58:59 -0500
Date: Thu, 20 Nov 2008 16:58:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thomas Pfaff <tpfaff@pcs.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question about TTY_DO_WRITE_WAKEUP
Message-ID: <20081120165839.49169a79@lxorguk.ukuu.org.uk>
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

A quick further look suggests you need to add

	if (tty->fasync && (b - buf) != nr)
		set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);

at the bottom of n_tty_write just before the return statement.

Alan
