Return-Path: <linux-kernel-owner+w=401wt.eu-S1764388AbYETJ1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764388AbYETJ1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 05:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759742AbYETJ1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 05:27:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38105 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752466AbYETJ1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 05:27:03 -0400
Date: Tue, 20 May 2008 10:08:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH 2/3, RFC] watchdog dev BKL pushdown
Message-ID: <20080520100815.3010688b@core>
In-Reply-To: <20080520062056.GA5292@infradead.org>
References: <13762.1211142411@vena.lwn.net>
	<200805200107.51659.arnd@arndb.de>
	<200805200111.47275.arnd@arndb.de>
	<200805200114.24819.arnd@arndb.de>
	<20080520062056.GA5292@infradead.org>
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

On Tue, 20 May 2008 02:20:56 -0400
Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, May 20, 2008 at 01:14:23AM +0200, Arnd Bergmann wrote:
> > The Big Kernel Lock has been pushed down from chardev_open
> > to misc_open, this change moves it to the individual watchdog
> > driver open functions.
> > 
> > As before, the change was purely mechanical, most drivers
> > should actually not need the BKL.
> 
> Actually I'd prefer to fix this for real.  This single open stuff aswell
> as same set of ioctls are duplicated all over the watchdog drivers.  We'd
> be much better off introducing a simple watchdog layer that handles this
> plus proper locking and convert drivers over to it gradually.

In progress in two ways

- Wim was (is ?) working on a proper device layer

- I've cleaned up all the drivers and am now testing a watchdog
driver supporting library which is taking about 50% of the code out of
each driver I convert.

Alan
