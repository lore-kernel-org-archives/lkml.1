Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbXDXF5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbXDXF5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 01:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbXDXF5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 01:57:08 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:32885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753255AbXDXF5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 01:57:07 -0400
Date: Mon, 23 Apr 2007 22:56:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: William Heimbigner <icxcnika@mar.tar.cc>
Cc: linux-kernel@vger.kernel.org, Peter Osterlund <petero2@telia.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: BUG: Null pointer dereference in fs/open.c
Message-Id: <20070423225627.9be84143.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704240527030.25153@server.thyself>
References: <Pine.LNX.4.64.0704222310030.25153@server.thyself>
	<20070423010032.c89e8d32.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704231356480.25153@server.thyself>
	<Pine.LNX.4.64.0704231633210.25153@server.thyself>
	<Pine.LNX.4.64.0704240347470.25153@server.thyself>
	<20070423215810.5a24ed9a.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704240507110.25153@server.thyself>
	<20070423221726.ccfa982c.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704240527030.25153@server.thyself>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007 05:44:42 +0000 (GMT) William Heimbigner <icxcnika@mar.tar.cc> wrote:

> On Mon, 23 Apr 2007, Andrew Morton wrote:
> > On Tue, 24 Apr 2007 05:10:04 +0000 (GMT) William Heimbigner <icxcnika@mar.tar.cc> wrote:
> >
> >>> --- a/drivers/block/pktcdvd.c~packet-fix-error-handling
> >>> +++ a/drivers/block/pktcdvd.c
> >>> @@ -777,7 +777,8 @@ static int pkt_generic_packet(struct pkt
> >>> 		rq->cmd_flags |= REQ_QUIET;
> >>>
> >>> 	blk_execute_rq(rq->q, pd->bdev->bd_disk, rq, 0);
> >>> -	ret = rq->errors;
> >>> +	if (rq->errors)
> >>> +		ret = -EIO;
> >>> out:
> >>> 	blk_put_request(rq);
> >>> 	return ret;
> >>> _
> >>
> >> This patch fixes (or conceals?) the oops.
> >>
> >
> > Fixes.  But does the packet driver actually work OK for you?  Writes
> > files and stuff like that?
> >
> Short answer, no.
> 
> Long answer:
> # pktsetup 0 /dev/hdc
>
> ...
>
> [11508.520800] pktcdvd: pkt_get_last_written failed
> 
> # mkudffs /dev/pktcdvd/0
> [11539.953560] pktcdvd: pkt_get_last_written failed
> trying to change type of multiple extents
> 
> I get the same error with /dev/hdd as well (hdc and hdd are both dvd 
> burners, hdd has a cd-rw and hdc had a dvd-rw)

Yes, I get the same on a sata (piix) dvd burner.

We need to work out who is setting rq->errors and why - should be pretty
simple.  I'll take a look at that after I've nailed one of these other bugs
over here.

