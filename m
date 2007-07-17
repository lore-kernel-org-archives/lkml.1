Return-Path: <linux-kernel-owner+w=401wt.eu-S934354AbXGQWom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934354AbXGQWom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 18:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757308AbXGQWof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 18:44:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48788 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756370AbXGQWoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 18:44:34 -0400
Date: Tue, 17 Jul 2007 15:38:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Giacomo Catenazzi <cate@cateee.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, akpm@linux-foundation.org
Subject: Re: regression: disk error loop (panic?) ide_do_rw_disk-bad:
In-Reply-To: <200707180045.03352.bzolnier@gmail.com>
Message-ID: <alpine.LFD.0.999.0707171535170.27353@woody.linux-foundation.org>
References: <469D1D5E.8050609@cateee.net> <200707172320.12141.bzolnier@gmail.com>
 <alpine.LFD.0.999.0707171417560.27353@woody.linux-foundation.org>
 <200707180045.03352.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Jul 2007, Bartlomiej Zolnierkiewicz wrote:
> 
> The new generic SG layer is CONFIG_SCSI=y "generic" in the current tree.

Yeah. I know, I already talked to Jens about it - in order to be generic, 
the BSG stuff really does end up having to be able to stand on its own, 
since not everybody wants/needs the whole SCSI layer.

> > obviously the older SCSI-ioctl layer) it should "just work".
> 
> Agreed but IDE driver has never claimed to have full SAT layer and
> full SCSI-ioctl layer support has been provided only for ide-cd.

I agree, and understand why it happened, but hope that maybe it can be 
improved in the future, or at least the error returned earlier so that the 
request will never even hit the ATA device at all if the IDE layer cannot 
then handle it.

> For now it should be sufficient to revert ide.c chunks of
> 
> commit 3d6392cfbd7dc11f23058e3493683afab4ac13a3

Jens?

		Linus
