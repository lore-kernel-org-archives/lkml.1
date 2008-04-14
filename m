Return-Path: <linux-kernel-owner+w=401wt.eu-S1764376AbYDNTqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764376AbYDNTqF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 15:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757952AbYDNTpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 15:45:52 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:42831 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753119AbYDNTpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 15:45:51 -0400
Date: Mon, 14 Apr 2008 15:45:50 -0400
To: Jan Kara <jack@suse.cz>
Cc: Bodo Eggert <7eggert@gmx.de>, Diego Calleja <diegocg@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>, Michal Hocko <mhocko@suse.cz>,
       Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
Message-ID: <20080414194550.GN7385@csclub.uwaterloo.ca>
References: <ah7vN-7Wz-9@gated-at.bofh.it> <E1JkIJ0-0000tG-LV@be1.7eggert.dyndns.org> <20080411135544.GG2160@csclub.uwaterloo.ca> <20080414162031.GD15824@duck.suse.cz> <20080414162202.GB7387@csclub.uwaterloo.ca> <20080414165354.GF15824@duck.suse.cz> <20080414170613.GI7385@csclub.uwaterloo.ca> <20080414190308.GJ15824@duck.suse.cz> <20080414192928.GM7385@csclub.uwaterloo.ca> <20080414194246.GN15824@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414194246.GN15824@duck.suse.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 09:42:46PM +0200, Jan Kara wrote:
> > Why would you want to?  You can already set the filepointer explicitly
> > to any value you want if you have the filehandle.
> > 
> > If you had a file with some security checks for whether the user could
> > read from it implemented based on locations then you would check it when
> > you read/write not when you seek, since after all you could just keep
> > reading until you get to the desired position.
>   Yes and no - for example if you manage to corrupt f_pos so that it
> becomes negative, you have won because it is checked only in seek, pread,
> pwrite, but not in read or write which rely on the check in seek...

The only file that could possibly implement any such silly security
based on position would be in /proc or /sys or similar, in which case
whatever driver implements it can check the position during any
read/write operation, and it would have to if it wants to implement such
a silly security system.

Any sane system would put the secured data in a seperate file from the
unsecured data obviously.

Trying to read from a negative position on a normal file should clearly
fail, and if it doesn't then that is a seperate issue to fix and has
nothing to do with the file position being set atomicly.

-- 
Len Sorensen
