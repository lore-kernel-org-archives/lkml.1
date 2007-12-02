Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861AbXLBUre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbXLBUre (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 15:47:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808AbXLBUr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 15:47:27 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45699 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389AbXLBUr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 15:47:26 -0500
Date: Sun, 2 Dec 2007 21:47:25 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071202204725.GA25891@one.firstfloor.org>
References: <20071201092037.GA32544@elte.hu> <p737ijwylet.fsf@bingen.suse.de> <20071202185945.GA25990@elte.hu> <20071202114152.3bf4332d@laptopd505.fenrus.org> <20071202200953.GA23994@one.firstfloor.org> <20071202202602.GA16480@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071202202602.GA16480@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Out of direct experience, 95% of the "too long delay" cases are plain 
> old bugs. The rest we can (and must!) convert to TASK_KILLABLE or could 

I already pointed out a few cases (nfs, cifs, smbfs, ncpfs, afs).   
It would be pretty bad to merge this patch without converting them to 
TASK_KILLABLE first

There's also the additional issue that even block devices are often
network or SAN backed these days. Having 120 second delays in there
is quite possible.

So most likely adding this patch and still keeping a robust kernel
would require converting most of these delays to TASK_KILLABLE first.
That would not be a bad thing -- i would often like to kill a
process stuck on a bad block device -- but is likely a lot of work.

> There are no softlockup false positive bugs open at the moment. If you 
> know about any, then please do not hesitate and report them, i'll be 
> eager to fix them. The softlockup detector is turned on by default in 
> Fedora (alongside lockdep in rawhide), and it helped us find countless 

That just means nobody runs stress tests on those. e.g. lockdep 
tends to explode even on simple stress tests on larger systems because it
tracks all locks in all dynamic objects in memory and towards 6k-10k entries
the graph walks tend to take multiple seconds on some NUMA systems.

-Andi

