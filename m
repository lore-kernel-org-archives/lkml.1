Return-Path: <linux-kernel-owner+w=401wt.eu-S1751460AbZKRLL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbZKRLL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 06:11:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbZKRLL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 06:11:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbZKRLL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 06:11:26 -0500
Subject: Re: [PATCH 06/12] writeback: remove unused nonblocking and
 congestion checks (gfs2)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091118100941.GA18726@localhost>
References: <20091118082648.140755818@intel.com>
	 <20091118082846.170413359@intel.com>
	 <1258538386.2904.7.camel@localhost.localdomain>
	 <20091118100941.GA18726@localhost>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Wed, 18 Nov 2009 11:13:41 +0000
Message-Id: <1258542821.2904.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2009-11-18 at 18:09 +0800, Wu Fengguang wrote:
> Hi Steven,
> 
> On Wed, Nov 18, 2009 at 05:59:46PM +0800, Steven Whitehouse wrote:
> > Hi,
> > 
> > That looks ok to me, modulo the warnings below. The only "non-obvious"
> > thing in this area which the GFS2 writepage[s] code relies upon is the
> > assumption that if we have a ->writepages() then ->writepage() will
> > never be called from a context which requires the fs to actually do a
> > write (i.e. the fs can refuse this if required). That is also only the
> > case for journaled data files - normal writes don't have that
> > requirement.
> 
> Thank you for the tips. I don't think pageout() or migration
> writeout() has that hard expectation for ->writepage() :)
> 
> >  CC [M]  fs/gfs2/aops.o
> > fs/gfs2/aops.c: In function ‘gfs2_write_jdata_pagevec’:
> > fs/gfs2/aops.c:272: warning: unused variable ‘bdi’
> > fs/gfs2/aops.c: In function ‘gfs2_write_cache_jdata’:
> > fs/gfs2/aops.c:336: warning: unused variable ‘bdi’
> 
> Ah sorry!
> 
> > Once the warnings are fixed:
> > 
> > Acked-by: Steven Whitehouse <swhiteho@redhat.com>
> > 
> > Do you want me to add this patch into my tree, or were you planning to
> > submit via a different tree?
> 
> Thanks, can you pull the updated patch directly to your tree?
> 
Yes, its in my -nmw tree now. Thanks,

Steve.


