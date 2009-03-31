Return-Path: <linux-kernel-owner+w=401wt.eu-S1757936AbZCaGE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbZCaGE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 02:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbZCaGEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 02:04:16 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45438 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbZCaGEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 02:04:15 -0400
Date: Tue, 31 Mar 2009 08:04:13 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ric Wheeler <rwheeler@redhat.com>,
       Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, david@fromorbit.com, tj@kernel.org
Subject: Re: [PATCH 1/7] block: Add block_flush_device()
Message-ID: <20090331060412.GG5178@kernel.dk>
References: <49D0B687.1030407@oss.ntt.co.jp> <alpine.LFD.2.00.0903301028400.3948@localhost.localdomain> <20090330175544.GX5178@kernel.dk> <alpine.LFD.2.00.0903301120200.3948@localhost.localdomain> <20090330185414.GZ5178@kernel.dk> <alpine.LFD.2.00.0903301242040.4093@localhost.localdomain> <20090330201732.GB5178@kernel.dk> <alpine.LFD.2.00.0903301331320.4093@localhost.localdomain> <49D17CA2.5060105@redhat.com> <alpine.LFD.2.00.0903301931230.4093@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903301931230.4093@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30 2009, Linus Torvalds wrote:
> 
> 
> On Mon, 30 Mar 2009, Ric Wheeler wrote:
> > 
> > One thing the caller could do is to disable the write cache on the device.
> 
> First off, that's not the callers job. If the sysadmin enabled it, some 
> random filesystem shouldn't disable it.

Completely agree with that, that is why I want the error logged instead
of returned. The write cache MAY be involved, but it may also be
something entirely different. The cache may be perfectly fine and
ordered but just not supporting flush cache because it doesn't need to
(it has battery backing). The important bit is informing the admin of
the situation, then it's up to the admin to look into the storage stack
and determine if this is a real problem or not. There's nothing the
kernel can do about it.

-- 
Jens Axboe

