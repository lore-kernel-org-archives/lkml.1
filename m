Return-Path: <linux-kernel-owner+w=401wt.eu-S1759007AbYE2XE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007AbYE2XE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 19:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbYE2XEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 19:04:47 -0400
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:5583 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753989AbYE2XEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 19:04:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnkKAKzQPkh5LFOM/2dsb2JhbACDH60F
X-IronPort-AV: E=Sophos;i="4.27,563,1204464600"; 
   d="scan'208";a="122822133"
Date: Fri, 30 May 2008 09:04:41 +1000
From: Dave Chinner <david@fromorbit.com>
To: Rik van Riel <riel@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Xiaoming Li <forrubm2@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [help]How to block new write in a "Thin Provisioning" logical
	volume manager as a virtual device driver when physical spaces run
	out?
Message-ID: <20080529230441.GB5134@disturbed>
Mail-Followup-To: Rik van Riel <riel@redhat.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Xiaoming Li <forrubm2@gmail.com>, linux-kernel@vger.kernel.org
References: <5f7c1d2c0805290212i45aece46j7fae2dcf9c158b92@mail.gmail.com> <20080529113159.113a7f06@core> <20080529120815.177bd456@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529120815.177bd456@bree.surriel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 12:08:15PM -0400, Rik van Riel wrote:
> On Thu, 29 May 2008 11:31:59 +0100
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > > Does anyone have some ideas for a better solution?
> > 
> > Take one file system such as ext3, or even a cluster file system like
> > GFS2 or OCFS. Create top level subdirectories in it for each machine.
> > Either export the subdirectory via NFS.
> 
> Xiaoming, let me point out another advantage of Alan's approach.
> 
> In a block based thin provisioning system, like you proposed, there
> is no way to free up space.  Once a user's filesystem has written a
> block, it is allocated - when the user deletes a file inside the
> filesystem, the space will not be freed again...

That's where we've been discussing bio hints to help communicate
space being allocated and freed by the filesystem to the lower layers.

See here:

http://marc.info/?l=linux-fsdevel&m=119370585902974&w=2

Alternatively, forget about block based thin provisioning and
just use XFS directory quotas....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
