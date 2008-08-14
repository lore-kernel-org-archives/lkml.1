Return-Path: <linux-kernel-owner+w=401wt.eu-S1757618AbYHNAVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618AbYHNAVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 20:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbYHNAUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 20:20:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751352AbYHNAUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 20:20:53 -0400
Date: Wed, 13 Aug 2008 17:20:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: kay.sievers@vrfy.org, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org, genanr@emsphone.com
Subject: Re: [Bugme-new] [Bug 11323] New: /proc/diskstats does not contain
 all disk devices
Message-Id: <20080813172041.9c59167d.akpm@linux-foundation.org>
In-Reply-To: <20080813235112.GC32154@kroah.com>
References: <bug-11323-10286@http.bugzilla.kernel.org/>
	<20080813130158.c94c370d.akpm@linux-foundation.org>
	<20080813235112.GC32154@kroah.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008 16:51:12 -0700
Greg KH <greg@kroah.com> wrote:

> On Wed, Aug 13, 2008 at 01:01:58PM -0700, Andrew Morton wrote:
> > > Problem Description: /proc/diskstats does not contain all the block devices it
> > > should. /sys/block has all the devices, but /proc/diskstats does not.
> > > 
> > > Steps to reproduce: boot a system with >9 (10?) disk devices (24 block
> > > devices?)
> > 
> > The below would be a prime suspect.
> > 
> > Unfortunately a simple revert results in an uncompilable kernel.
> > 
> > 
> > (It drives me up the wall and across the ceiling how the patch has a
> > commit "date" of three months prior to the 2.6.26 release, however it
> > wasn't present in 2.6.26.  What a dumb feature.  How do I make it stop
> > doing this?  gitk kind of gets it right, but isn't useful across DSL)
> 
> $ git show --pretty=fuller 27f302519148f311307637d4c9a6d0fd87d07e4c

<writes a script>

> commit 27f302519148f311307637d4c9a6d0fd87d07e4c
> Author:     Greg Kroah-Hartman <gregkh@suse.de>
> AuthorDate: Thu May 22 17:21:08 2008 -0400
> Commit:     Greg Kroah-Hartman <gregkh@suse.de>
> CommitDate: Mon Jul 21 21:54:49 2008 -0700
> 
> There is a commit date, and the date the patch was written.  Both are
> preserved in git.
> 
> And even if it was committed to a branch before 2.6.26 was released, and
> then pulled in, that's fine, it's distributed development :)

It's useless.  I have never ever ever ever wanted to know when random
person X committed a patch to some local tree.  The overwhelmingly most
common question is "when did that go into Linux".  Sigh.

> $ git describe --contains 27f302519148f311307637d4c9a6d0fd87d07e4c
> v2.6.27-rc1~866^2~40
> 
> showing it first showed up on 2.6.27-rc1.

Spose that works.  My usual recourse is searching the commits list,
which has useful-to-humans ordering information.

Is the date at which it went into mainline recorded?

> Anyway, I don't have any systems with such a large number of devices to
> test with.

I suppose that partitioning a junk disk with lots of little partitions
will show it.  parted wants to go stupid on me though.

>  Running git-bisect should narrow the problem down, you can't
> just revert this patch as later-on patches relied on it, as you found
> out...
> 
> Also, what is the output of these files, what exactly is missing?

