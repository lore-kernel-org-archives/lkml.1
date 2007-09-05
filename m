Return-Path: <linux-kernel-owner+w=401wt.eu-S1758116AbXIEQEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116AbXIEQEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 12:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757512AbXIEQEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 12:04:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38795 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757342AbXIEQEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 12:04:15 -0400
Date: Wed, 5 Sep 2007 09:03:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: greg@kroah.com, j@fuster.org, linux-kernel@vger.kernel.org
Subject: Re: sysfs_dir_cache growing out of control
Message-Id: <20070905090332.27eae31f.akpm@linux-foundation.org>
In-Reply-To: <46CE33DA.9010501@googlemail.com>
References: <46CCD3DF.4080303@fuster.org>
	<46CD057C.3080106@fuster.org>
	<20070823095933.GA6742@kroah.com>
	<46CE29DA.60409@fuster.org>
	<20070824005429.GA32265@kroah.com>
	<46CE33DA.9010501@googlemail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 24 Aug 2007 03:26:50 +0200 Gabriel C <nix.or.die@googlemail.com> wrote:
> Greg KH wrote:
> > On Thu, Aug 23, 2007 at 08:44:10PM -0400, Joel Fuster wrote:
> >> Greg KH wrote:
> >>> On Wed, Aug 22, 2007 at 11:56:44PM -0400, Joel Fuster wrote:
> >>>> Joel Fuster wrote:
> >>>>> Hi,
> >>>>> I am running 2.6.22.3.  For reasons that escape me, over time (days) the 
> >>>>> sysfs_dir_cache, dentry, and inode_cache SLUB entries grow until they 
> >>>>> consume all the memory on my system, requiring a reboot.
> >>> Hm, those items should consume all the memory, but it should be freed if
> >>> you have memory pressure from other places.  Does it cause the machine
> >>> to lock up, or you just got scared when seeing them?
> >> Right.  The problem is that the memory never seems to get freed no matter 
> >> what I do.  I've tried setting /proc/sys/vm/vfs_cache_pressure to 10000, 
> >> but after a few days all my programs are running out of swap and I have to 
> >> reboot to get things back to a usable state.
> >>
> >>> Oh, and does the same thing happen if you do not use SLUB, but rather
> >>> the older SLAB?
> >> OK I just rebuilt 2.6.22.3 with SLAB and I seem to be getting the same 
> >> result..obviously I haven't waited several days, but 
> >> sysfs_dir_cache/dentry/inode_cache grow continuously when scanbuttond is 
> >> running, and stop growing when it isn't.
> > 
> > Do you have a pointer to the scanbuttond source code?  I'll try to take
> > a look at this tomorrow.
> > 

that was a long day?

> I guess this one :
> 
> https://sourceforge.net/projects/scanbuttond/

I needed `setenv LD_LIBRARY_PATH /usr/local/lib' to be able to run
`scanbuttond -p 1000'

and after a few minutes I'm seeing zero growth of
/proc/spabinfo:sysfs_dir_cache over a few minutes, with 2.6.23-rc4. 
Perhaps it's a specific device driver?  
