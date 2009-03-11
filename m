Return-Path: <linux-kernel-owner+w=401wt.eu-S1752525AbZCKIgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbZCKIgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 04:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbZCKIgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 04:36:22 -0400
Received: from sh.osrg.net ([192.16.179.4]:41375 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627AbZCKIgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 04:36:20 -0400
Date: Wed, 11 Mar 2009 17:35:48 +0900 (JST)
Message-Id: <20090311.173548.59681981.ryusuke@osrg.net>
To: akpm@linux-foundation.org
Cc: konishi.ryusuke@lab.ntt.co.jp, hch@lst.de, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Asking for inclusion of nilfs2 in the mainline kernel
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <20090310155459.11ffa81f.akpm@linux-foundation.org>
References: <20090311.015542.118514963.ryusuke@osrg.net>
	<20090310155459.11ffa81f.akpm@linux-foundation.org>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 11 Mar 2009 17:35:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,
On Tue, 10 Mar 2009 15:54:59 -0700, Andrew Morton wrote:
> On Wed, 11 Mar 2009 01:55:42 +0900 (JST)
> Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:
> 
> > I've been working for the past serveral months to take review comments
> > and to continually solve users' problems come up in mainling list
> 
> Yes, the maintenance has been impressive.

Thanks for picking up additional patches at all times!
 
> > (thanks for all giving comments and feedbacks!).  Also, I've tried to
> > stabilize API and disk format to restrict additional changes and
> > ensure backward compatibility.
> 
> Well.  From the point of view of mainline linux, there is no
> back-compatibility issue, because the fs hasn't been merged yet.

Oops, sorry, I mistook; it meant forward-compatibility.

My recent patch series and the recent userland tasks were intended to
give better support for future extensions though I even tried to keep
backward compatibility.

> You perhaps have back-compatibility concerns for existing users of the
> out-of-tree patch, but I'd encourage you to not worry about that too
> much - there will be fairly few users and they are probably pretty
> technical and will be able to cope with a migration.  It's a _bit_ hard
> on them but on the other hand, omitting back-compatibility code leads
> to a better implementation for the long term.

Thanks for the advice.  I'll keep this comment in mind and will handle
matters more flexibly with considering long term merits and trade-off.

> What you should be more concerned about is forward-compatibility.  What
> arrangements do you presently have in place to be able to later alter the
> on-disk format without causing too much disruption?  Having a strong
> design here will make changes easier to do and will lead to a better
> filesystem.

Yes, I recognize the importance of this.  For example, I've carefully
converted both userland and kernel code so that they refer to ``size''
fields embeded in on-disk structures instead of calculating with
sizeof().  In addition, I paid attention to initialization of reserved
fields not to break the forward compatibility.

We arranged various size fields: size of super block, size of segment
header, size of on-disk items in meta data files such as inode on
ifile, checkpoint entry on cpfile, segment usage entry on sufile, and
so forth.  All those fields are for handling possible future
extensions.

Further, each log of nilfs2 is designed so that it can have additional
blocks in the tail.  They may be used, for instance, to write
additional copies of superblock.
 
> Also..  Don't get _too_ concerned about freezing the on-disk format at
> this time.  You could put in a mount-time printk("the nilfs on-disk
> format may change at any time - do not place critical data on a nilfs
> filesystem") and we leave that in place for a few months while things
> stabilise.

Got it.  So, I will do the message insertion  :)

> And yes, I was planning on sending nilfs in to Linus for 2.6.30 unless
> someone has decent-sounding reasons to hold it back.

Great!

Regards,
Ryusuke Konishi
