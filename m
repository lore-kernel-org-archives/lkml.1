Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834Ab0AEI6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab0AEI6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 03:58:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480Ab0AEI6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 03:58:03 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45485 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab0AEI6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 03:58:00 -0500
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org, "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.1001041904250.3630@localhost.localdomain>
References: <20100104182429.833180340@chello.nl>
	 <20100104182813.753545361@chello.nl>
	 <20100105092559.1de8b613.kamezawa.hiroyu@jp.fujitsu.com>
	 <alpine.LFD.2.00.1001041904250.3630@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Jan 2010 09:57:14 +0100
Message-ID: <1262681834.2400.31.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-04 at 19:13 -0800, Linus Torvalds wrote:
> Or put another way: if the vma was a writable mapping, a user may do
> 
>         munmap(mapping, size);
> 
> and the backing file is still active and writable AFTER THE MUNMAP! This 
> can be a huge problem for something that wants to unmount the volume, for 
> example, or depends on the whole writability-vs-executability thing. The 
> user may have unmapped it, and expects the file to be immediately 
> non-busy, but with the delayed free that isn't the case any more. 

If it were only unmount it would be rather easy to fix by putting that
RCU synchronization in unmount, unmount does a lot of sync things
anyway. But I suspect there's more cases where that non-busy matters
(but I'd need to educate myself on filesystems/vfs to come up with any).

