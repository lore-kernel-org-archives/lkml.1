Return-Path: <linux-kernel-owner+w=401wt.eu-S933654AbXHXBAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933654AbXHXBAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 21:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764058AbXHXA76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 20:59:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39843 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763170AbXHXA76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 20:59:58 -0400
Date: Thu, 23 Aug 2007 17:54:29 -0700
From: Greg KH <greg@kroah.com>
To: Joel Fuster <j@fuster.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sysfs_dir_cache growing out of control
Message-ID: <20070824005429.GA32265@kroah.com>
References: <46CCD3DF.4080303@fuster.org> <46CD057C.3080106@fuster.org> <20070823095933.GA6742@kroah.com> <46CE29DA.60409@fuster.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CE29DA.60409@fuster.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 08:44:10PM -0400, Joel Fuster wrote:
> Greg KH wrote:
>> On Wed, Aug 22, 2007 at 11:56:44PM -0400, Joel Fuster wrote:
>>> Joel Fuster wrote:
>>>> Hi,
>>>> I am running 2.6.22.3.  For reasons that escape me, over time (days) the 
>>>> sysfs_dir_cache, dentry, and inode_cache SLUB entries grow until they 
>>>> consume all the memory on my system, requiring a reboot.
>> Hm, those items should consume all the memory, but it should be freed if
>> you have memory pressure from other places.  Does it cause the machine
>> to lock up, or you just got scared when seeing them?
> Right.  The problem is that the memory never seems to get freed no matter 
> what I do.  I've tried setting /proc/sys/vm/vfs_cache_pressure to 10000, 
> but after a few days all my programs are running out of swap and I have to 
> reboot to get things back to a usable state.
>
>> Oh, and does the same thing happen if you do not use SLUB, but rather
>> the older SLAB?
>
> OK I just rebuilt 2.6.22.3 with SLAB and I seem to be getting the same 
> result..obviously I haven't waited several days, but 
> sysfs_dir_cache/dentry/inode_cache grow continuously when scanbuttond is 
> running, and stop growing when it isn't.

Do you have a pointer to the scanbuttond source code?  I'll try to take
a look at this tomorrow.

thanks,

greg k-h
