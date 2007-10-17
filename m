Return-Path: <linux-kernel-owner+w=401wt.eu-S933724AbXJQUcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933724AbXJQUcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933357AbXJQUbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:31:48 -0400
Received: from brick.kernel.dk ([87.55.233.238]:20375 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760919AbXJQUbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:31:46 -0400
Date: Wed, 17 Oct 2007 22:31:41 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071017203140.GF15552@kernel.dk>
References: <20071017174503.GA4622@elte.hu> <20071017175337.GN15552@kernel.dk> <20071017183716.GU15552@kernel.dk> <20071017190901.GA13780@elte.hu> <alpine.LFD.0.999.0710171217160.26902@woody.linux-foundation.org> <20071017193542.GA15552@kernel.dk> <alpine.LFD.0.999.0710171244330.26902@woody.linux-foundation.org> <20071017195659.GD15552@kernel.dk> <20071017200638.GE15552@kernel.dk> <alpine.LFD.0.999.0710171321400.26902@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710171321400.26902@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17 2007, Linus Torvalds wrote:
> 
> 
> On Wed, 17 Oct 2007, Jens Axboe wrote:
> > 
> > So until that is fixed up, how about this? Should cover all block
> > devices, and I don't think sg_next()/for_each_sg() has spread outside of
> > that yet.
> 
> Heh. Not good. There are drivers that set max phys segmsnts to 1. Either 
> through some host-specific setting (MMC), or explicitly (eg a grep shows 
> viodasd uses just a constant 1 there).

That would hurt... Care to commit your for_each_sg() uglification fixup
for now then? Or disable the allocation debug config entry, so that the
sg+1 deref wont crash? Whichever your prefer, just don't want to cause
crash pains for the unfortunate souls that happen to run into this
before the real fix is done.

-- 
Jens Axboe

