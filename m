Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbXFYM2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbXFYM2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 08:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbXFYM2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 08:28:22 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:50960 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbXFYM2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 08:28:21 -0400
Date: Mon, 25 Jun 2007 08:25:21 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Nick Piggin <npiggin@suse.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC] fsblock
Message-ID: <20070625122521.GA12446@think.oraclecorp.com>
References: <20070624014528.GA17609@wotan.suse.de> <467DE00A.9080700@garzik.org> <20070624034755.GA3292@wotan.suse.de> <20070624135126.GA10077@think.oraclecorp.com> <467F67A8.3030408@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <467F67A8.3030408@yahoo.com.au>
User-Agent: Mutt/1.5.12-2006-07-14
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 04:58:48PM +1000, Nick Piggin wrote:
> 
> >Using buffer heads instead allows the FS to send file data down inside
> >the transaction code, without taking the page lock.  So, locking wrt
> >data=ordered is definitely going to be tricky.
> >
> >The best long term option may be making the locking order
> >transaction -> page lock, and change writepage to punt to some other
> >queue when it needs to start a transaction.
> 
> Yeah, that's what I would like, and I think it would come naturally
> if we move away from these "pass down a single, locked page APIs"
> in the VM, and let the filesystem do the locking and potentially
> batching of larger ranges.

Definitely.

> 
> write_begin/write_end is a step in that direction (and it helps
> OCFS and GFS quite a bit). I think there is also not much reason
> for writepage sites to require the page to lock the page and clear
> the dirty bit themselves (which has seems ugly to me).

If we keep the page mapping information with the page all the time (ie
writepage doesn't have to call get_block ever), it may be possible to
avoid sending down a locked page.  But, I don't know the delayed
allocation internals well enough to say for sure if that is true.

Either way, writepage is the easiest of the bunch because it can be
deferred.

-chris
