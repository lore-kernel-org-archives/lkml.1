Return-Path: <linux-kernel-owner+w=401wt.eu-S1758896AbXIJMYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896AbXIJMYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 08:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757468AbXIJMYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 08:24:46 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53779 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753137AbXIJMYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 08:24:45 -0400
Date: Mon, 10 Sep 2007 13:31:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       perex@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] unexport sys_{open,read}
Message-ID: <20070910133155.27aa8365@the-village.bc.nu>
In-Reply-To: <20070910022324.c69e1897.akpm@linux-foundation.org>
References: <20070909202527.GT3563@stusta.de>
	<20070909203920.GA11764@infradead.org>
	<20070909145940.0b41c8a5.akpm@linux-foundation.org>
	<20070910090808.GA31204@infradead.org>
	<20070910022324.c69e1897.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I would like to see "everyone" explain what we lose by giving developers a
> bit of warning before we break their stuff.

We lose the ability to get anything done on a timescale that makes it
happen. Instead we have this continual cycle of remove, akpm says no,
submitter forgets, 3 month pause, remove, akpm says no, ...

Adrian does now and then try and remove stuff its stupid to remove.
People NAK those quite promptly. We've been trying to deprecate sys_open
and the other related exports since 1.3.x or thereabouts.

There is almost no correct sane way to use these exports either, because
your fs struct may be shared so horrible things happen.

I'm (minus the language selection) with Christoph "Effing" Hellwig on this
one - for these symbols at least. When we break stuff people moan and we
can put them back, providing they go into the Linus tree fairly early in
the -rc sequence. In the cases we've inadvertently broken stuff before
people have moaned fairly quickly too - eg when the tty layer took some
inlines into _GPL exports by accident.

Alan
