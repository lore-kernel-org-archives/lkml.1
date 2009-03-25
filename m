Return-Path: <linux-kernel-owner+w=401wt.eu-S1762896AbZCYQzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762896AbZCYQzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 12:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755865AbZCYQzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 12:55:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39595 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbZCYQzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 12:55:15 -0400
Date: Wed, 25 Mar 2009 12:55:00 -0400
From: "hch@infradead.org" <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jeff Layton <jlayton@redhat.com>, Ian Kent <raven@themaw.net>,
       Dave Chinner <david@fromorbit.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "hch@infradead.org" <hch@infradead.org>,
       "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH] writeback: reset inode dirty time when adding it back
	to empty s_dirty list
Message-ID: <20090325165500.GA6047@infradead.org>
References: <1237840233-11045-1-git-send-email-jlayton@redhat.com> <20090324135720.GA25314@localhost> <20090324102806.4f38fd26@tleilax.poochiereds.net> <20090324104657.6907b19e@tleilax.poochiereds.net> <20090325012829.GA7506@localhost> <20090324221528.2bb7c50b@tleilax.poochiereds.net> <20090325025037.GA17374@localhost> <20090325075110.028f0d1d@tleilax.poochiereds.net> <20090325121742.GA22869@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325121742.GA22869@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 08:17:43PM +0800, Wu Fengguang wrote:
> Now there are now two possible solutions:
> - unconditionally update dirtied_when in redirty_tail();
> - keep dirtied_when and redirty inodes to a new dedicated queue.
> The first one involves less code, the second one allows more flexible timing.
> 
> NFS/XFS could be a good starting point for discussing the
> requirements, so that we can reach a suitable solution.

Note that the XFS requirement also applies to all filesystems that
perform some sort of metadata updats on I/O completeion.  That includes
at least ext4, btrfs and most likely the cluster filesystems too.
