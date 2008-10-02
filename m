Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbYJBIrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbYJBIrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 04:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYJBIrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 04:47:10 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:50877 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbYJBIrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 04:47:09 -0400
Date: Thu, 2 Oct 2008 10:46:49 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20081002084649.GZ19428@kernel.dk>
References: <20081001200034.65eb67d6@infradead.org> <20081001215638.3a65134c.akpm@linux-foundation.org> <20081002062736.GR19428@kernel.dk> <20081001235501.2b7f50fe.akpm@linux-foundation.org> <20081002074523.GW19428@kernel.dk> <20081002010315.1cda8147.akpm@linux-foundation.org> <20081002082212.GY19428@kernel.dk> <20081002014332.7d04bddc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081002014332.7d04bddc.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02 2008, Andrew Morton wrote:
> On Thu, 2 Oct 2008 10:22:13 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Thu, Oct 02 2008, Andrew Morton wrote:
> > > On Thu, 2 Oct 2008 09:45:24 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
> > > 
> > > > > So.  Where are these atime updaters getting blocked?
> > > > 
> > > > Behind other IO activity I suppose, since it's marked async. A more
> > > > appropriate fix may be to mark atime updates as sync IO.
> > > 
> > > No, they might be getting blocked at a higher level.
> > > 
> > > An async atime update gets recorded into the current transaction. 
> > > kjournald is working on the committing transaction.  We try to keep
> > > those separated, to prevent user processes from getting blocked behind
> > > kjournald activity.
> > > 
> > > But sometimes that doesn't work (including the place where I knowingly
> > > broke it).  If we can find and fix the offending piece of jbd logic (a
> > > big if) then all is peachy.
> > > 
> > > If the above theory turns out to be true then diddling IO priorities
> > > is but a workaround.
> > 
> > If diddling with io priorities makes a big difference (and Arjan said it
> > does), it's clearly stuck inside the io scheduler waiting to be
> > dispatched. If it was marked sync, it would be going through much
> > faster. As async, it'll get mixed in with other async writeout and that
> > doesn't get a lot of attention in case of sync activity.
> > 
> 
> Maybe.  And maybe marking all journal writeout and all commit activity
> as sync would have the same effect with less downside.
> 
> But it'd be better to not wait on this IO at all, if poss..

Agree, would be much better...

-- 
Jens Axboe

