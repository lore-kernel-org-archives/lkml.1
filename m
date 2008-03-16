Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbYCPUq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbYCPUq6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 16:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbYCPUqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 16:46:48 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41176 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752534AbYCPUqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 16:46:48 -0400
Date: Sun, 16 Mar 2008 20:31:09 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Anders Eriksson <aeriksson@fastmail.fm>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc4
Message-ID: <20080316203109.50e8c526@core>
In-Reply-To: <alpine.LFD.1.00.0803161238190.3020@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org>
	<20080316140118.891732DC044@tippex.mynet.homeunix.org>
	<alpine.LFD.1.00.0803160924580.3020@woody.linux-foundation.org>
	<200803161907.04581.bzolnier@gmail.com>
	<alpine.LFD.1.00.0803161111000.3020@woody.linux-foundation.org>
	<20080316185602.79064f7c@core>
	<alpine.LFD.1.00.0803161238190.3020@woody.linux-foundation.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Mar 2008 12:39:43 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Sun, 16 Mar 2008, Alan Cox wrote:
> > 
> > No it doesn't. DRQ simply means "drive has more data for the controller
> > if you want it". Interrupts are controlled via IEN and the interrupt line.
> 
> A _lot_ of chips require you to clear the DRQ by taking the data they 
> have.

Almost none and mostly very old ones. I'm not saying we shouldn't do it
(except where it hangs the hardware - hence the FIFO flag) but for the
traces presented and hardware reported it appears to be a bit of a red
herring.

> > If the drive wants to give us data and we end the transaction that is
> > fine. In practice a tiny few devices crap themselves if we don't.
> 
> More than a few tiny devices from what I remember. It tends to be the 
> other way around - most devices do *not* want to get new commands until 
> you've finished the previous one by draining the queues.

Not in my experience having maintained a lot of ATA drivers for a very
long time. In fact the changes for draining the DRQ went into libata only
very recently because it was only when we had a distro sized userbase
with PATA devices that it became apparent that a few corner case problems
remained.

Alan
