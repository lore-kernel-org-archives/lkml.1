Return-Path: <linux-kernel-owner+w=401wt.eu-S1764482AbYA2ONv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764482AbYA2ONv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 09:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763030AbYA2ONo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 09:13:44 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45482 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759486AbYA2ONn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 09:13:43 -0500
Date: Tue, 29 Jan 2008 14:09:36 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org
Subject: Heads Up: tty locking changes
Message-ID: <20080129140936.0350d685@core>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In the next few days I'll be submitting some further tty locking changes
to the kernel. Line discipline ->write and ->read methods will no longer
be covered by lock_kernel. For the moment tty->driver write methods won't
change (that is they will be either lock_kernel or in an IRQ but never
both). That is next on the hit list once the lock is driven out of the
tty ldisc layer.

If you have any out of tree ldiscs please be ready. If you maintain any
serial drivers still relying on lock_kernel for internal locking on the
read/write paths, now would be a good time to fix them before they break

Alan
