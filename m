Return-Path: <linux-kernel-owner+w=401wt.eu-S1757050AbXI1HcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbXI1HcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 03:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbXI1HcC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 03:32:02 -0400
Received: from mx2.go2.pl ([193.17.41.42]:34359 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751008AbXI1HcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 03:32:00 -0400
Date: Fri, 28 Sep 2007 09:34:23 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: akpm@linux-foundation.org, adobriyan@sw.ru, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm1 1/2] fixing idr_find() locking
Message-ID: <20070928073422.GA2418@ff.dom.local>
References: <20070927143354.663489000@bull.net> <20070927143458.674281000@bull.net> <20070928063144.GB1767@ff.dom.local> <46FCA87F.3000605@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FCA87F.3000605@bull.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 09:08:47AM +0200, Nadia Derbey wrote:
> Jarek Poplawski wrote:
> >On Thu, Sep 27, 2007 at 04:33:55PM +0200, Nadia.Derbey@bull.net wrote:
> >
> >>[PATCH 01/02]
> >>
> >>
> >>This is a patch that fixes the way idr_find() used to be called in 
> >>ipc_lock():
> >>in all the paths that don't imply an update of the ipcs idr, it was called
> >>without the idr tree being locked.
> >>
> >>The changes are:
> >> . in ipc_ids, the mutex has been changed into a reader/writer semaphore.
> >> . ipc_lock() now takes the mutex as a reader during the idr_find().
> >> . a new routine ipc_lock_down() has been defined: it doesn't take the
> >>   mutex, assuming that it is being held by the caller. This is the 
> >>   routine
> >>   that is now called in all the update paths.
> >>
> >>
> >>Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
> >
> >
> >Acked-by: Jarek Poplawski <jarkao2@o2.pl>
> >
> >PS: there is one big mistake around To/Cc ordering, so I doubt Andrew
> >will ever sign this...
> >
> >
> 
> Jarek,
> 
> I thought that since you were the one who pointed out the issue I had to 
> put you as the receiver.
> Next time I'll also add Andrew in the To list.
> Sorry for that.

It seems Andrew is generous (sometimes) and should forgive you (some
day...). And I'm perfectly happy. Of course, with Cc too. I'm only
a bit confused with this 2/2, which is of course OK, but it seems my
ack isn't needed there.

Thanks,
Jarek P.
