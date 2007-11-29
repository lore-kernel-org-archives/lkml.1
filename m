Return-Path: <linux-kernel-owner+w=401wt.eu-S933251AbXK2TsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933251AbXK2TsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 14:48:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933723AbXK2Tqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 14:46:46 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:49526 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933716AbXK2Tqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 14:46:45 -0500
Subject: Re: Out of tree module using LSM
From: Jon Masters <jonathan@jonmasters.org>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, tvrtko.ursulin@sophos.com,
       Al Viro <viro@ftp.linux.org.uk>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Valdis.Kletnieks@vt.edu
In-Reply-To: <2c0942db0711291111t16a4eb49h6b1e83ddf7bb4cf9@mail.gmail.com>
References: <20071128183040.GW8181@ftp.linux.org.uk>
	 <OF699E23DA.E36E712D-ON802573A2.00591FA8-802573A2.005A44A2@sophos.com>
	 <20071129173601.34273083@the-village.bc.nu>
	 <2c0942db0711291040j4ce48acagb753b64c4b8c1357@mail.gmail.com>
	 <1196362612.6473.98.camel@perihelion>
	 <2c0942db0711291111t16a4eb49h6b1e83ddf7bb4cf9@mail.gmail.com>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Thu, 29 Nov 2007 14:45:51 -0500
Message-Id: <1196365551.6473.103.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-11-29 at 11:11 -0800, Ray Lee wrote:
> On Nov 29, 2007 10:56 AM, Jon Masters <jonathan@jonmasters.org> wrote:
> > On Thu, 2007-11-29 at 10:40 -0800, Ray Lee wrote:
> > > On Nov 29, 2007 9:36 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > > > closed. But more importantly further access to it can be blocked until
> > > > > appropriate actions are taken which also applies with your example, no? Is
> > > >
> > > > That bit is hard- very hard.
> > >
> > > In some sense it seems like the same problem faced by dynamic
> > > translators such as Qemu. They really want to vet a dirtied or faulted
> > > page before allowing the app to run unhindered. It's be nice to have
> > > some way to do that without virtualizing the whole of userspace.
> >
> > Like I hinted at, you can't just "vet a page". Because a page alone is
> > meaningless garbage, unless it happens to be an extremely small program,
> > with headers, all nicely aligned. Most likely you don't know if a random
> > page of data is code from a COFF file, ELF file, or some random crap I
> > typed in at a terminal after having too much coffee.
> >
> > So. You'd need to scan *all the pages* of *the entire file*, every time
> > that you performed any type of operation.
> 
> *blink* Really?

Yeah, really.

> To lift Alan's example, a naive first implementation
> would be to create a suffix tree of all of ESR's works, then scan each
> page on fault to see if there are any partial matches in the tree.

Ah, but I could write a sequence of pages that on their own looked
garbage, but in reality, when executed would print out a copy of the
Jargon File in all its glory. And if you still think you could look for
patterns, how about executable code that self-modifies in random ways
but when executed as a whole actually has the functionality of fetchmail
embedded within it? How would you guard against that?

Jon.


