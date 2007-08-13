Return-Path: <linux-kernel-owner+w=401wt.eu-S972625AbXHMNWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S972625AbXHMNWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S942804AbXHMJNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 05:13:54 -0400
Received: from brick.kernel.dk ([87.55.233.238]:7050 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S942772AbXHMJNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 05:13:51 -0400
Date: Mon, 13 Aug 2007 11:13:49 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Daniel Phillips <phillips@phunq.net>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: Distributed storage.
Message-ID: <20070813091348.GJ23758@kernel.dk>
References: <20070731171347.GA14267@2ka.mipt.ru> <20070813072848.GC23758@kernel.dk> <20070813074530.GE23758@kernel.dk> <200708130208.57542.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708130208.57542.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13 2007, Daniel Phillips wrote:
> On Monday 13 August 2007 00:45, Jens Axboe wrote:
> > On Mon, Aug 13 2007, Jens Axboe wrote:
> > > > You did not comment on the one about putting the bio destructor
> > > > in the ->endio handler, which looks dead simple.  The majority of
> > > > cases just use the default endio handler and the default
> > > > destructor.  Of the remaining cases, where a specialized
> > > > destructor is needed, typically a specialized endio handler is
> > > > too, so combining is free.  There are few if any cases where a
> > > > new specialized endio handler would need to be written.
> > >
> > > We could do that without too much work, I agree.
> >
> > But that idea fails as well, since reference counts and IO completion
> > are two completely seperate entities. So unless end IO just happens
> > to be the last user holding a reference to the bio, you cannot free
> > it.
> 
> That is not a problem.  When bio_put hits zero it calls ->endio instead 
> of the destructor.  The ->endio sees that the count is zero and 
> destroys the bio.

You can't be serious? You'd stall end io completion notification because
someone holds a reference to a bio. Surely you jest.

Needless to say, that will never go in.

-- 
Jens Axboe

