Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbYJTUOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbYJTUOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 16:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbYJTUOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 16:14:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbYJTUOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 16:14:41 -0400
Date: Mon, 20 Oct 2008 16:14:15 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       agk@redhat.com, mbroz@redhat.com, chris@arachsys.com
Subject: Re: RFC: one-bit mutexes (was: Re: [PATCH 2/3] Memory management
 livelock)
In-Reply-To: <200810112306.18118.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0810201612210.22845@hs20-bc2-1.build.redhat.com>
References: <20080911101616.GA24064@agk.fab.redhat.com>
 <20081001225404.4e973465.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0810051804040.23248@hs20-bc2-1.build.redhat.com>
 <200810112306.18118.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > If you are concerned about the size of an inode, I can convert other
> > mutexes to bit mutexes: i_mutex and inotify_mutex.
> 
> I wouldn't worry for now. mutexes can be unlocked much faster than bit
> mutexes, especially in the fastpath. And due to slab, it would be
> unlikely to actually save any space.

Maybe inotify_mutex. You are right that i_mutex is so heavily contended 
that slowing it down to save few words wouldn't be good. Do you know about 
any inotify-intensive workload?

> > I could also create 
> > bit_spinlock (one-bit spinlock that uses test_and_set_bit) and save space
> > for address_space->tree_lock, address_space->i_mmap_lock,
> > address_space->private_lock, inode->i_lock.
> 
> We have that already. It is much much faster to unlock spinlocks than
> bit spinlocks in general (if you own the word exclusively, then it's
> not, but then you would be less likely to save space), and we can also
> do proper FIFO ticket locks with a larger word.

BTW. why do spinlocks on x86(64) have 32 bits and not 8 bits or 16 bits? 
Are atomic 32-bit instuctions faster?

Can x86(86) system have 256 CPUs?

Mikulas
