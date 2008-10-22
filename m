Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbYJVJMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbYJVJMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 05:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbYJVJMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 05:12:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60704 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753646AbYJVJMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 05:12:43 -0400
Date: Wed, 22 Oct 2008 10:11:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alex Howells <alex@bytemark.co.uk>
Cc: Valdis.Kletnieks@vt.edu, Greg KH <greg@kroah.com>,
       Alexandre Oliva <oliva@lsd.ic.unicamp.br>,
       "H. Peter Anvin" <hpa@kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081022101157.72ff575a@lxorguk.ukuu.org.uk>
In-Reply-To: <48FEEB1E.1030809@bytemark.co.uk>
References: <20081016153053.GJ5834@nostromo.devel.redhat.com>
	<20081016154726.GA6331@kroah.com>
	<20081016171626.GB22554@cs181140183.pp.htv.fi>
	<20081017040239.GB28188@kroah.com>
	<20081017103138.1ca68d17@lxorguk.ukuu.org.uk>
	<48F8C000.8030003@kernel.org>
	<20081017174226.GF2221@kroah.com>
	<48F98DE2.8030205@kernel.org>
	<ortzb89bak.fsf@oliva.athome.lsd.ic.unicamp.br>
	<48FCD421.2010208@bytemark.co.uk>
	<20081020202147.GA20788@kroah.com>
	<48FE32E2.5000601@bytemark.co.uk>
	<33098.1224636084@turing-police.cc.vt.edu>
	<48FEEB1E.1030809@bytemark.co.uk>
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

On Wed, 22 Oct 2008 09:58:06 +0100
Alex Howells <alex@bytemark.co.uk> wrote:

> > And you win the trifecta - I don't think we've *ever* shipped a Linux kernel
> > that worked reliably under the proper "beat on the scheduler/VM corner case"
> > load/stress testing.  Again, the best you can hope for is "doesn't fall over

Upstream kernels can be a bit iffy especially on 32bit boxes with lots
of RAM. The enterprise vendor kernels have had months of tuning on high
load tests and behave far better than upstream. If you are running 32bit
and > 2GB of RAM I wouldn't even bother with upstream kernels to be
honest - pick one of the enterprise distributions or free repackagings
thereof. Better yet go 64bit ;)

At minimum with 2.6.x under high load you also need Arjan van de Ven's
patches to fix the ioprio mess - and god knows why those haven't been
accepted upstream given they make a huge difference to performance and
load handling.

http://lkml.org/lkml/2008/10/2/297

> > under non-pathological non-corner-case loads when sufficient resources are
> > available so the kernel has a fighting chance".  Doing 'make -j100' on a
> > single Core2 Duo is gonna be painful, no matter what.

Turn on strict overcommit and the box will degrade sanely and then if
need be start erroring things with out of memory before it goes kersplat.
That was a feature added a long time ago by Red Hat and then merged
upstream because serious business users of Linux need better guarantees
than the base kernel defaults.

If you have a non AMD processor without an IOMMU and are doing high
amounts of I/O make sure your I/O devices are 64bit capable - particular
watch SATA as most ATA hardware that isn't AHCI is 32bit constrained.

Alan
