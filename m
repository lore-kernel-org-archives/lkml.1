Return-Path: <linux-kernel-owner+w=401wt.eu-S1758137AbYAEV0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbYAEV0s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 16:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756893AbYAEV0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 16:26:39 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49434 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756865AbYAEV0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 16:26:38 -0500
Date: Sat, 5 Jan 2008 21:26:34 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       NetDev <netdev@vger.kernel.org>
Subject: Re: Top 10 kernel oopses for the week ending January 5th, 2008
Message-ID: <20080105212634.GM27894@ZenIV.linux.org.uk>
References: <477FF149.4070609@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477FF149.4070609@linux.intel.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2008 at 01:06:17PM -0800, Arjan van de Ven wrote:
> Rank 3: d_splice_alias
> 	NULL pointer deref
> 	Reported 3 times
> 	Happens in the isofs code
> 	Only seen in 2.6.24-rc5-mm1
> 	More info: http://www.kerneloops.org/search.php?search=d_splice_alias

in -rc6-mm1 as well, fixes on l-k...
 
> Rank 8: evdev_disconnect
> 	kernel page fault
> 	Reported 2 times (10 total reports)
> 	Previously seen in older kernels including 2.6.21 but as far back as 
> 	2.6.16
> 	More info: 
> 	http://www.kerneloops.org/search.php?search=evdev_disconnect

Practically certain to be fixed by 6addb1d6de1968b84852f54561cc9a999909b5a9;
it's list_for_each_entry() walking from the entry that just got list_del()
and kernels without that sucker have no protection of the list in question
whatsoever.
 
> Rank 9: mutex_lock
> 	kernel null pointer due to rfcomm_tty_close sysfs interaction
> 	Reported 2 times (9 total reports)
> 	Ranked 9th last week as well
> 	More info: http://www.kerneloops.org/search.php?search=mutex_lock

pissfs locking problems; AFAICS, its sysfs_get_dentry() walking into
already unlinked sysfs directory node on the way to target; no exclusion
against that is there and it's not trivial to add.
