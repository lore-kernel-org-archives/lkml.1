Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbXKAPrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbXKAPrt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 11:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758699AbXKAPrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 11:47:18 -0400
Received: from [81.2.110.250] ([81.2.110.250]:39245 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757814AbXKAPrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 11:47:17 -0400
Date: Thu, 1 Nov 2007 15:48:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Char: tty, add tty_schedule_wakeup
Message-ID: <20071101154847.570d8e96@the-village.bc.nu>
In-Reply-To: <15530290543226725036.slaby@karneval.cz>
References: <14457172322573118772.slaby@karneval.cz>
	<15530290543226725036.slaby@karneval.cz>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  1 Nov 2007 11:55:56 +0100 (CET)
Jiri Slaby <jirislaby@gmail.com> wrote:

> tty, add tty_schedule_wakeup
> 
> Because several drivers schedule a workqueue only for tty_wakeup, move this
> functionality into tty layer and use newly added centralized work.

I've no idea why any drivers do this. A tty_wakeup is very fast and it
won't (when called from an IRQ) reschedule anything until the IRQ is over
(in the RT kernel case it might do stuff but thats *because* it should do
so).

I think just using tty_wakeup for this ought to be sufficient unless they
are using the work queue for some kind of serialization of events
