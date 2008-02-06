Return-Path: <linux-kernel-owner+w=401wt.eu-S1752824AbYBFPaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbYBFPaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 10:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbYBFP3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 10:29:55 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:42140 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbYBFP3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 10:29:54 -0500
Date: Wed, 6 Feb 2008 15:29:32 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Tomasz Chmielewski <mangoo@wpkg.org>
cc: LKML <linux-kernel@vger.kernel.org>, Mika Lawando <rzryyvzy@trashmail.net>
Subject: Re: What is the limit size of tmpfs /dev/shm ? 
In-Reply-To: <47A9CA0E.3030507@wpkg.org>
Message-ID: <Pine.LNX.4.64.0802061517380.8470@blonde.site>
References: <47A9CA0E.3030507@wpkg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008, Tomasz Chmielewski wrote:
> > Hello Kernel Users,
> > 
> > is there a size limit for tmpfs for the /dev/shm filesystem?

There shouldn't be any artificial size limit on the /dev/shm filesystem,
it's an "internal" mount, and those are unlimited by default.  Which is
not to say that you magically receive unlimited memory along with it!

The practical limit would be somewhere round about the total size of
your swap plus, ooh, finger in the air, 75% of your RAM - though that
all depends on what else you'd be wanting to use RAM+swap for.

> > Normally its default size is set to 2 GB.

Hmm, where did that number come from, maybe I'm forgetting something.
The user-visible mounts are limited by default to half of ram, so if
you've 4GB of ram, then 2GB would be the default for those tmpfs mounts.

> > Is it possible to create a 2 TB (Terrabyte) filesystem with tmpfs?

Yes.

> > Or is there a maximum size defined in the linux kernel?
> 
> Depends on your arch.
> 
> If it's 32 bit, it's limited to 16TB:
> 
> # mount -o size=16383G -t tmpfs tmpfs /mnt/2
> # df -h
> (...)
> tmpfs                  16T     0   16T   0% /mnt/2
> 
> # umount /mnt/2
> 
> # mount -o size=16385G -t tmpfs tmpfs /mnt/2
> # df -h
> (...)
> tmpfs                 1.0G     0  1.0G   0% /mnt/2
> 
> So 16384G would mean the same as 0.

Hah!  Nice investigation.  That's more of a bug than anything,
though not one I feel urgently compelled to fix.

> If you're 64 bit, you need to have really loads of storage and/or RAM to
> accumulate 16EB:
> 
> # mount -t tmpfs -o size=171798691839G tmpfs /mnt/2
> # df -h
> (...)
> tmpfs                  16E     0   16E   0% /mnt/2

Mika, you answered:

> Nice, I will try this out.
> I have not the money for 16E of memory of RAM! :-) lol
> Already to provide 1 TB it would cost at least for the memory about 20 000
> EUR + the server costs which support this.

Don't forget that tmpfs overflows into swap, so you could save money
by adding adding more swap and cutting down on the RAM: though of
course that will perform very poorly once it's actually using the
swap, probably not the direction you want to go in.

Hugh
