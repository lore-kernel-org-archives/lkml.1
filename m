Return-Path: <linux-kernel-owner+w=401wt.eu-S1755018AbZCYUJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbZCYUJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 16:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbZCYUJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 16:09:04 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:60523 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbZCYUJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 16:09:01 -0400
Subject: Re: [PATCH] writeback: reset inode dirty time when adding it back
 to empty s_dirty list
From: Chris Mason <chris.mason@oracle.com>
To: "hch@infradead.org" <hch@infradead.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Jeff Layton <jlayton@redhat.com>,
       Ian Kent <raven@themaw.net>, Dave Chinner <david@fromorbit.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>
In-Reply-To: <20090325165500.GA6047@infradead.org>
References: <1237840233-11045-1-git-send-email-jlayton@redhat.com>
	 <20090324135720.GA25314@localhost>
	 <20090324102806.4f38fd26@tleilax.poochiereds.net>
	 <20090324104657.6907b19e@tleilax.poochiereds.net>
	 <20090325012829.GA7506@localhost>
	 <20090324221528.2bb7c50b@tleilax.poochiereds.net>
	 <20090325025037.GA17374@localhost>
	 <20090325075110.028f0d1d@tleilax.poochiereds.net>
	 <20090325121742.GA22869@localhost>  <20090325165500.GA6047@infradead.org>
Content-Type: text/plain
Date: Wed, 25 Mar 2009 16:07:02 -0400
Message-Id: <1238011622.5676.3.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.49CA8EED.01FD:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 12:55 -0400, hch@infradead.org wrote:
> On Wed, Mar 25, 2009 at 08:17:43PM +0800, Wu Fengguang wrote:
> > Now there are now two possible solutions:
> > - unconditionally update dirtied_when in redirty_tail();
> > - keep dirtied_when and redirty inodes to a new dedicated queue.
> > The first one involves less code, the second one allows more flexible timing.
> > 
> > NFS/XFS could be a good starting point for discussing the
> > requirements, so that we can reach a suitable solution.
> 
> Note that the XFS requirement also applies to all filesystems that
> perform some sort of metadata updats on I/O completeion.  That includes
> at least ext4, btrfs and most likely the cluster filesystems too.

btrfs at least doesn't dirty the inode on I/O completion.  It just puts
the changes directly into the btree blocks.

-chris


