Return-Path: <linux-kernel-owner+w=401wt.eu-S1755877AbZBGXZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbZBGXZO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 18:25:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbZBGXZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 18:25:00 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38603 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbZBGXZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 18:25:00 -0500
Date: Sat, 7 Feb 2009 18:24:58 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Build failure with latest -git: btrfs on ppc64
Message-ID: <20090207232458.GB23407@bombadil.infradead.org>
References: <20090207155039.3b6a7429@dhcp-100-2-144.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090207155039.3b6a7429@dhcp-100-2-144.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 07, 2009 at 03:50:39PM -0500, Chuck Ebbert wrote:
> fs/btrfs/locking.c: In function 'btrfs_path_lock_waiting':
> fs/btrfs/locking.c:254: error: implicit declaration of function '__raw_spin_is_contended'
> 
> Looks like spin_is_contended() is only available on mips and x86??
> 

Looks to be if there are other folks in line for the ticket lock.

Arguably this should probably be something silly in spinlock.h like,

#ifndef __raw_spin_is_contended
# define spin_is_contended (0)
#else
# define spin_is_contended(x) __raw_spin_is_contended((x))
#endif

or something since in theory anybody has a chance of acquiring it next
(well, lies because caches bias, but there's no waiters at least.)

Either that, or we just define it to be spin_is_locked if the assumption
is that the lock will continue to be locked...

regards, Kyle
