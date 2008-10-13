Return-Path: <linux-kernel-owner+w=401wt.eu-S1759916AbYJMXSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916AbYJMXSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 19:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754602AbYJMXRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 19:17:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50641 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750979AbYJMXRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 19:17:53 -0400
Date: Tue, 14 Oct 2008 00:16:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Cox <alan@redhat.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Resend][2.6.27-git-a447c093244] BUG: spinlock bad magic on
 CPU#0, setserial/3527
Message-ID: <20081014001657.13e40477@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0810131538210.3288@nehalem.linux-foundation.org>
References: <200810140010.31141.rjw@sisk.pl>
	<alpine.LFD.2.00.0810131538210.3288@nehalem.linux-foundation.org>
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

On Mon, 13 Oct 2008 16:10:14 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> If this started today, then the most likely culprit is Alan's series of 80 
> serial patches.
> 
> Alan? I can only assume it's one of the
> 
> 	spin_lock_irq(&up->port.lock);
> 
> in serial8250_startup() (or quite likely in one of the functions it calls 
> that get inlined by the compiler, like enable_rsa()).
> 
> And it sounds like it didn't get initialized.

Yeah I know whats going on I think. When I dropped out the NR_IRQ changes
I didn't drop back in the spin lock init. Will sort it tomorrow (actually
'later today' as its midnight here)

Alan
