Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbZFCV3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbZFCV3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 17:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756344AbZFCV3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 17:29:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:39217 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756632AbZFCV3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 17:29:11 -0400
Date: Wed, 3 Jun 2009 14:22:06 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 3 (driver core)
Message-ID: <20090603212206.GA20804@suse.de>
References: <20090603190952.2dd0cc70.sfr@canb.auug.org.au> <4A269BB2.4050508@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A269BB2.4050508@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03, 2009 at 08:50:10AM -0700, Randy Dunlap wrote:
> Stephen Rothwell wrote:
> > Hi all,
> > 
> > Looks like a real rush since -rc7 ...
> 
> 
> drivers/built-in.o: In function `register_mem_sect_under_node':
> (.text+0x1d305b): undefined reference to `sysfs_create_link_nowarn'
> 
> 
> I can't find this function's implementation when CONFIG_SYSFS=y.

Ah, it looks like this shows up when CONFIG_MEMORY_HOTPLUG_SPARSE is
set.

Eric, your patch, "sysfs: Remove now unnecessary error reporting
suppression." caused this.  Turns out it is still used in the tree, and
you forgot to remove the function from sysfs.h at the same time.

I'm going to drop it, and the other two patches I took from you for
sysfs, as it doesn't make sense to have them in the tree yet.

Care to rework your series with this fixed?

thanks,

greg k-h
