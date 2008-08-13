Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbYHMXzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbYHMXzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 19:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYHMXy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 19:54:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53850 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbYHMXyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 19:54:55 -0400
Date: Wed, 13 Aug 2008 16:51:12 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org, genanr@emsphone.com
Subject: Re: [Bugme-new] [Bug 11323] New: /proc/diskstats does not contain
	all disk devices
Message-ID: <20080813235112.GC32154@kroah.com>
References: <bug-11323-10286@http.bugzilla.kernel.org/> <20080813130158.c94c370d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813130158.c94c370d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 01:01:58PM -0700, Andrew Morton wrote:
> > Problem Description: /proc/diskstats does not contain all the block devices it
> > should. /sys/block has all the devices, but /proc/diskstats does not.
> > 
> > Steps to reproduce: boot a system with >9 (10?) disk devices (24 block
> > devices?)
> 
> The below would be a prime suspect.
> 
> Unfortunately a simple revert results in an uncompilable kernel.
> 
> 
> (It drives me up the wall and across the ceiling how the patch has a
> commit "date" of three months prior to the 2.6.26 release, however it
> wasn't present in 2.6.26.  What a dumb feature.  How do I make it stop
> doing this?  gitk kind of gets it right, but isn't useful across DSL)

$ git show --pretty=fuller 27f302519148f311307637d4c9a6d0fd87d07e4c

commit 27f302519148f311307637d4c9a6d0fd87d07e4c
Author:     Greg Kroah-Hartman <gregkh@suse.de>
AuthorDate: Thu May 22 17:21:08 2008 -0400
Commit:     Greg Kroah-Hartman <gregkh@suse.de>
CommitDate: Mon Jul 21 21:54:49 2008 -0700

There is a commit date, and the date the patch was written.  Both are
preserved in git.

And even if it was committed to a branch before 2.6.26 was released, and
then pulled in, that's fine, it's distributed development :)

$ git describe --contains 27f302519148f311307637d4c9a6d0fd87d07e4c
v2.6.27-rc1~866^2~40

showing it first showed up on 2.6.27-rc1.

Anyway, I don't have any systems with such a large number of devices to
test with.  Running git-bisect should narrow the problem down, you can't
just revert this patch as later-on patches relied on it, as you found
out...

Also, what is the output of these files, what exactly is missing?

thanks,

greg k-h
