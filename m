Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbZCaRD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbZCaRD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 13:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbZCaRDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 13:03:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48141 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754785AbZCaRDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 13:03:17 -0400
Date: Tue, 31 Mar 2009 17:29:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ric Wheeler <rwheeler@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Fernando Luis =?ISO-8859-14?B?VuF6cXVleg==?= Cao 
	<fernando@oss.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, david@fromorbit.com, tj@kernel.org
Subject: Re: [PATCH 1/7] block: Add block_flush_device()
Message-ID: <20090331172911.1897d158@the-village.bc.nu>
In-Reply-To: <alpine.LFD.2.00.0903310846110.4093@localhost.localdomain>
References: <49D02328.7060108@oss.ntt.co.jp>
	<49D0258A.9020306@garzik.org>
	<49D03377.1040909@oss.ntt.co.jp>
	<49D0B535.2010106@oss.ntt.co.jp>
	<49D0B687.1030407@oss.ntt.co.jp>
	<alpine.LFD.2.00.0903301028400.3948@localhost.localdomain>
	<20090330175544.GX5178@kernel.dk>
	<alpine.LFD.2.00.0903301120200.3948@localhost.localdomain>
	<20090330185414.GZ5178@kernel.dk>
	<alpine.LFD.2.00.0903301242040.4093@localhost.localdomain>
	<20090330201732.GB5178@kernel.dk>
	<alpine.LFD.2.00.0903301331320.4093@localhost.localdomain>
	<49D17CA2.5060105@redhat.com>
	<alpine.LFD.2.00.0903301931230.4093@localhost.localdomain>
	<49D1FB64.8000505@redhat.com>
	<alpine.LFD.2.00.0903310746460.4093@localhost.localdomain>
	<alpine.LFD.2.00.0903310846110.4093@localhost.localdomain>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And the filesystem shouldn't know, and it most definitely mustr not act 
> any differently. Because that's behind the abstraction, and there's no 
> sane way to bring it _out_ of the abstraction that isn't fundamentally 
> flawed (like thinking that it's always a SATA-II drive).

How the file system responds has to depend upon what the users intents
are with regards to still having their data.

In a lot of cases "flush if you can" makes good sense. In higher
integrity cases you want a way to tell the device "flush if you can, do
whatever else is needed to fake a flush if not" and in some cases you
genuinely want to propogate errors back at mount time to say "sorry can't
do this"

Agreed entirely that this shouldn't be expressed down the stack in terms
of things like 'tags' or 'write with fua', but unless the different
versions of it can be expressed, or refused you can't build a good enough
abstraction. Throw and pray the block layer can fake it simply isn't a
valid model for serious enterprise computing, and if people understood
the worst cases, for a lot of non enterprise computing.

The second problem is who has sufficient information to efficiently
handle decisions around ordering/barriers/flushes/single outstanding
command and other strategies. I am skeptical that in the case where the
underlying block subsystem provides suboptimal ordering/barrier
facilities that it falling back to alternatives without letting the fs
also change strategies will be efficient.

Alan
