Return-Path: <linux-kernel-owner+w=401wt.eu-S1758298AbZJGKWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298AbZJGKWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 06:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757923AbZJGKWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 06:22:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:42583 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754702AbZJGKWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 06:22:11 -0400
Date: Wed, 7 Oct 2009 12:21:30 +0200
From: Nick Piggin <npiggin@suse.de>
To: David Howells <dhowells@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Li Shaohua <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/45] writeback: quit on wrap for .range_cyclic (afs)
Message-ID: <20091007102130.GQ30316@wotan.suse.de>
References: <20091007074902.913463607@intel.com> <20091007073818.318088777@intel.com> <32495.1254910626@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32495.1254910626@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 11:17:06AM +0100, David Howells wrote:
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > Convert wbc.range_cyclic to new behavior: when past EOF, abort writeback
> > of the inode, which instructs writeback_single_inode() to delay it for
> > a while if necessary.
> > 
> > It removes one inefficient .range_cyclic IO pattern when writeback_index
> > wraps:
> > 	submit [10000-10100], (wrap), submit [0-100]
> > In which the submitted pages may be consisted of two distant ranges.
> > 
> > It also prevents submitting pointless IO for busy overwriters.
> > 
> > CC: David Howells <dhowells@redhat.com>
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> 
> Acked-by: David Howells <dhowells@redhat.com>

I don't see why. Then the inode is given less write bandwidth than
those which don't wrap (or wrap on "nice" boundaries).

