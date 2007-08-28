Return-Path: <linux-kernel-owner+w=401wt.eu-S1758305AbXH1Q6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305AbXH1Q6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 12:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbXH1Q6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 12:58:40 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:53553 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbXH1Q6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 12:58:39 -0400
Date: Tue, 28 Aug 2007 12:57:53 -0400
From: Chris Mason <chris.mason@oracle.com>
To: David Chinner <dgc@sgi.com>
Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>, Andrew Morton <akpm@osdl.org>,
       Ken Chen <kenchen@google.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/6] writeback time order/delay fixes take 3
Message-ID: <20070828125753.391a8fa7@think.oraclecorp.com>
In-Reply-To: <20070828163308.GE61154114@sgi.com>
References: <386910467.21100@ustc.edu.cn>
	<20070821202314.335e86ec@think.oraclecorp.com>
	<20070822011841.GA8090@mail.ustc.edu.cn>
	<20070823023306.GM61154114@sgi.com>
	<20070824135504.GA9029@mail.ustc.edu.cn>
	<20070828145530.GD61154114@sgi.com>
	<20070828110820.542bbd67@think.oraclecorp.com>
	<20070828163308.GE61154114@sgi.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Aug 2007 02:33:08 +1000
David Chinner <dgc@sgi.com> wrote:

> On Tue, Aug 28, 2007 at 11:08:20AM -0400, Chris Mason wrote:
> > > > 
> > > > I wonder if XFS can benefit any more from the general writeback
> > > > clustering. How large would be a typical XFS cluster?
> > > 
> > > Depends on inode size. typically they are 8k in size, so anything
> > > from 4-32 inodes. The inode writeback clustering is pretty tightly
> > > integrated into the transaction subsystem and has some intricate
> > > locking, so it's not likely to be easy (or perhaps even possible)
> > > to make it more generic.
> > 
> > When I talked to hch about this, he said the order file data pages
> > got written in XFS was still dictated by the order the higher
> > layers sent things down.
> 
> Sure, that's file data. I was talking about the inode writeback, not
> the data writeback.

I think we're trying to gain different things from inode based
clustering...I'm not worried that the inode be next to the data.  I'm
going under the assumption that most of the time, the FS will try to
allocate inodes in groups in a directory, and so most of the time the
data blocks for inode N will be close to inode N+1.

So what I'm really trying for here is data block clustering when
writing multiple inodes at once.  This matters most when files are
relatively small and written in groups, which is a common workload.

It may make the most sense to change the patch to supply some key for
the data block clustering instead of the inode number, but its an easy
first pass.

-chris
