Return-Path: <linux-kernel-owner+w=401wt.eu-S1161800AbXDYSLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161800AbXDYSLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 14:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161864AbXDYSLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 14:11:46 -0400
Received: from brick.kernel.dk ([80.160.20.94]:16834 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161800AbXDYSLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 14:11:46 -0400
Date: Wed, 25 Apr 2007 20:08:13 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alan.Brunelle@pobox.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/15] cfq-iosched: speed up rbtree handling
Message-ID: <20070425180813.GI4730@kernel.dk>
References: <11774025432481-git-send-email-jens.axboe@oracle.com> <11774025432403-git-send-email-jens.axboe@oracle.com> <462F7AD9.8020300@hp.com> <20070425171539.GE4730@kernel.dk> <20070425175047.GF4730@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425175047.GF4730@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25 2007, Jens Axboe wrote:
> On Wed, Apr 25 2007, Jens Axboe wrote:
> > On Wed, Apr 25 2007, Alan D. Brunelle wrote:
> > > Hi Jens -
> > > 
> > > The attached patch speeds it up even more - I'm finding a >9% reduction 
> > > in %system with no loss in IO performance. This just sets the cached 
> > > element when the first is looked for.
> > 
> > Interesting, good thinking. It should not change the IO pattern, as the
> > end result should be the same. Thanks Alan, will commit!
> > 
> > I'll give elevator.c the same treatment, should be even more beneficial.
> > Stay tuned for a test patch.
> 
> Something like this, totally untested (it compiles). I initially wanted
> to fold the cfq addon into the elevator.h provided implementation, but
> that requires more extensive changes. Given how little code it is, I
> think I'll keep them seperate.

Booted, seems to work fine for me. In a null ended IO test, I get about
a 1-2% speedup for a single queue of depth 64 using libaio. So it's
definitely worth it, will commit.

-- 
Jens Axboe

