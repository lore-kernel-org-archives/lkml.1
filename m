Return-Path: <linux-kernel-owner+w=401wt.eu-S1753765Ab0AZVjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab0AZVjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 16:39:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030Ab0AZVjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 16:39:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab0AZVjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 16:39:09 -0500
Date: Tue, 26 Jan 2010 22:38:53 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Robin Holt <holt@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>, cl@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] - Fix unmap_vma() bug related to mmu_notifiers
Message-ID: <20100126213853.GY30452@random.random>
References: <20100125174556.GA23003@sgi.com>
 <20100125190052.GF5756@random.random>
 <20100125211033.GA24272@sgi.com>
 <20100125211615.GH5756@random.random>
 <20100126212904.GE6653@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100126212904.GE6653@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 03:29:04PM -0600, Robin Holt wrote:
> On Mon, Jan 25, 2010 at 10:16:15PM +0100, Andrea Arcangeli wrote:
> > The old patches are in my ftp area, they should still apply, you
> > should concentrate testing with those additional ones applied, then it
> > will work for xpmem too ;)
> 
> Andrea, could you point me at your ftp area?

Sure, this is the very latest version I maintained:

http://www.kernel.org/pub/linux/kernel/people/andrea/patches/v2.6/2.6.26-rc7/mmu-notifier-v18/

Note, it may be an option to make mmu notifier sleepable through
.config, unless people uses xpmem there is no reason to add
refcounting to vmas. That is something we'd pay even if no KVM is used
and no mmu notifer is used. I think the ideal is that anon-vma lock
should be a rwspinlock and only rcu (no refcounting) with
MMU_NOTIFIER_SLEEPABLE=n, and a read-write sem + refcounting if
MMU_NOTIFIER_SLEEPABLE=y. MMU_NOTIFIER_SLEEPABLE doesn't need to be
user visible, simply XPMEM=y will automatically set
MMU_NOTIFIER_SLEEPABLE=y.
