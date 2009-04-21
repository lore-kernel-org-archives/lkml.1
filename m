Return-Path: <linux-kernel-owner+w=401wt.eu-S1755736AbZDUIqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736AbZDUIqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 04:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbZDUIp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 04:45:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:16073 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928AbZDUIpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 04:45:55 -0400
Message-ID: <49ED87BF.7040007@petalogix.com>
Date: Tue, 21 Apr 2009 10:45:51 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Nate Straz <nate-ltp@refried.org>, subrata@linux.vnet.ibm.com,
       ltp-list@lists.sourceforge.net,
       John Williams <john.williams@petalogix.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, adilger@sun.com
Subject: Re: [LTP] statvfs -> f_bavail
References: <49E759FB.70103@petalogix.com> <49E847FB.1030801@petalogix.com> <20090417173107.GA3590@refried.org> <49EC1352.6010900@petalogix.com> <20090420062642.GY26366@ZenIV.linux.org.uk> <49EC1945.1000805@petalogix.com> <20090421002503.GA8633@ZenIV.linux.org.uk>
In-Reply-To: <20090421002503.GA8633@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Mon, Apr 20, 2009 at 08:42:13AM +0200, Michal Simek wrote:
>
>   
>> That mean that for all other fs is possible to set nr_blocks=0 (f_bavail=0) and for all this cases
>> fsync02 test failed. That mean that make sense to test f_bavail value in LTP and if is zero
>> don't work with it. Am I right?
>>     
>
> Huh?
> 	a) ramfs has no such thing as "amount of available space", simply
> because it has no limit on total size occupied.
>   
As wrote Andreas - for ramfs case make sense to use size of memory.

> 	b) tmpfs *does* have a limit and will report f_bavail, unless you
> tell it not to limit (that's what nr_blocks=... is; it sets the fs size limit
> for tmpfs and 0 means "no limit, act as ramfs").
>   
that mean that if is not limit make no sense to work with it in fsync02
test and use or default test value
or find out your fs size limit? Where is it written?

> 	c) nfs client has no fscking clue how much space is left on server
> for non-root; moreover, in case of nfs root on client might very well be
> mapped to something else on server.
>   
that mean that no make sense to work with f_bavail and return zero value
right?

> 	d) something local on-disk (ext2, ext3, etc., etc.) can and will fill
> ->f_bavail with non-zero data
>   
this is used.
> 	e) procfs has nothing to put there, period.  You can't create
> files there, it doesn't have anything like fixed-sized something that might
> be partially empty.
>   
snip
> The bottom line: some filesystems have reasonable answer to "how much space
> is left on that fs for non-root user".  Those fill the field in question.
> And for some filesystems the question makes no sense whatsoever.
>
> So statfs(2) has every right to leave the damn thing zero.  Whether it
> will do that or not depends on the fs type.  Userland code must be able
> to cope with that, unless it *knows* which filesystem type will it be
> dealing with.
>   
ok. Current LTP fsync02 failed in forever loop and my LTP patch just
solve problem if the f_bavail
is zero - if yes, just use default value which is in test.
Of course I would like to use sensible value(amount of mem or whatever)
for all fs and if is the way, I'll do it. That's question for you
if is possible to do it -> that's why I cc: fsdevel mailing list.
If is not a way to do it in generic way make sense to me use at least my
patch.

Michal
> Incidentally, nr_blocks=... will be cheerfully shat upon by just about every
> fs out there.  It's tmpfs-specific.
>   


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

