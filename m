Return-Path: <linux-kernel-owner+w=401wt.eu-S932657Ab0AFTId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657Ab0AFTId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 14:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934Ab0AFTIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 14:08:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:39068 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab0AFTIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 14:08:31 -0500
Subject: Re: [PATCH] improve the performance of large sequential write NFS
 workloads
From: Peter Zijlstra <peterz@infradead.org>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
       Steve Rago <sar@nec-labs.com>,
       "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jens.axboe" <jens.axboe@oracle.com>,
       Peter Staubach <staubach@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
In-Reply-To: <1262803927.4251.133.camel@localhost>
References: <20091222015907.GA6223@localhost>
	 <1261578107.2606.11.camel@localhost> <20091223180551.GD3159@quack.suse.cz>
	 <1261595574.6775.2.camel@localhost> <20091224025228.GA12477@localhost>
	 <1261656281.3596.1.camel@localhost> <20091225055617.GA8595@localhost>
	 <1262190168.7332.6.camel@localhost> <20091231050441.GB19627@localhost>
	 <1262286828.8151.113.camel@localhost>  <20100106030346.GA15962@localhost>
	 <1262796962.4251.91.camel@localhost>  <1262802387.4251.117.camel@localhost>
	 <1262803040.4049.62.camel@laptop>  <1262803927.4251.133.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jan 2010 20:07:56 +0100
Message-ID: <1262804876.4049.66.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-06 at 13:52 -0500, Trond Myklebust wrote:
> On Wed, 2010-01-06 at 19:37 +0100, Peter Zijlstra wrote: 
> > On Wed, 2010-01-06 at 13:26 -0500, Trond Myklebust wrote:
> > > OK. It looks as if the only key to finding out how many unstable writes
> > > we have is to use global_page_state(NR_UNSTABLE_NFS), so we can't
> > > specifically target our own backing-dev. 
> > 
> > Would be a simple matter of splitting BDI_UNSTABLE out from
> > BDI_RECLAIMABLE, no?
> > 
> > Something like
> 
> OK. How about if we also add in a bdi->capabilities flag to tell that we
> might have BDI_UNSTABLE? That would allow us to avoid the potentially
> expensive extra calls to bdi_stat() and bdi_stat_sum() for the non-nfs
> case?

The bdi_stat_sum() in the error limit is basically the only such
expensive op, but I suspect we might hit that more than enough. So sure
that sounds like a plan.

