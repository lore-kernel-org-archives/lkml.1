Return-Path: <linux-kernel-owner+w=401wt.eu-S972773AbXHMNTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S972773AbXHMNTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970196AbXHMJJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 05:09:10 -0400
Received: from dsl081-085-152.lax1.dsl.speakeasy.net ([64.81.85.152]:53610
	"EHLO moonbase.phunq.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S966936AbXHMJJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 05:09:06 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Distributed storage.
Date: Mon, 13 Aug 2007 02:08:57 -0700
User-Agent: KMail/1.9.5
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
References: <20070731171347.GA14267@2ka.mipt.ru> <20070813072848.GC23758@kernel.dk> <20070813074530.GE23758@kernel.dk>
In-Reply-To: <20070813074530.GE23758@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708130208.57542.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 August 2007 00:45, Jens Axboe wrote:
> On Mon, Aug 13 2007, Jens Axboe wrote:
> > > You did not comment on the one about putting the bio destructor
> > > in the ->endio handler, which looks dead simple.  The majority of
> > > cases just use the default endio handler and the default
> > > destructor.  Of the remaining cases, where a specialized
> > > destructor is needed, typically a specialized endio handler is
> > > too, so combining is free.  There are few if any cases where a
> > > new specialized endio handler would need to be written.
> >
> > We could do that without too much work, I agree.
>
> But that idea fails as well, since reference counts and IO completion
> are two completely seperate entities. So unless end IO just happens
> to be the last user holding a reference to the bio, you cannot free
> it.

That is not a problem.  When bio_put hits zero it calls ->endio instead 
of the destructor.  The ->endio sees that the count is zero and 
destroys the bio.

Regards,

Daniel
