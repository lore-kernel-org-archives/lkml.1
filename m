Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbYJBHzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbYJBHzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 03:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbYJBHzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 03:55:31 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:49762 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbYJBHzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 03:55:31 -0400
Date: Thu, 2 Oct 2008 09:55:11 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20081002075511.GX19428@kernel.dk>
References: <20081001200034.65eb67d6@infradead.org> <20081001215638.3a65134c.akpm@linux-foundation.org> <87fxnfpjqj.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fxnfpjqj.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02 2008, Andi Kleen wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > On Wed, 1 Oct 2008 20:00:34 -0700 Arjan van de Ven <arjan@infradead.org> wrote:
> >
> >> Subject: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
> >
> > You proposed this a while back and it didn't happen and I forget
> > why and the changelog doesn't mention any of that?
> 
> XFS tried this some time ago too.
> 
> I think the issue was that real user supplied RT applications don't want to 
> compete with a "pseudo RT" kjournald.
> 
> So it would really need a new priority class between RT and normal priority.

Good point. I think we should mark the IO as sync, and maintain the same
priority level. Any IO that ends up being waited on is sync by
definition, we just need to expand the coverage a bit.

-- 
Jens Axboe

