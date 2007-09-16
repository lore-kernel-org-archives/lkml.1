Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbXIPR5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbXIPR5R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 13:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbXIPR5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 13:57:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:47882 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbXIPR5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 13:57:08 -0400
Date: Sun, 16 Sep 2007 19:57:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Ben Collins <ben.collins@ubuntu.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux1394-devel@lists.sourceforge.net
Subject: Re: regression: fireware causes oops during system
Message-ID: <20070916175753.GC11983@elf.ucw.cz>
References: <20070911190043.GA1577@elf.ucw.cz> <1189537716.7620.192.camel@cunning> <46E6ECAA.30601@s5r6.in-berlin.de> <46E6F076.5000006@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E6F076.5000006@s5r6.in-berlin.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2007-09-11 21:45:58, Stefan Richter wrote:
> >> On Tue, 2007-09-11 at 21:00 +0200, Pavel Machek wrote:
> >>> I noticed empty suspend stopped working around 2.6.23-rc4, and it is
> >>> still present in 2.6.23-rc6.
> ...
> >>> Unsetting
> >>>
> >>> CONFIG_IEEE1394=y
> >>>
> >>> solves the problem.
> ...
> 
> Between -rc3 and -rc4:
> 
> 	ieee1394: sbp2: fix sbp2_remove_device for error cases
> 	a2ee3f9bbb0ce57102dad8928d54f59acdc4b8f7
> 	should not occur in suspend path

Plus I do not have firewire attached disk here, so sbp2 should not be
used, right? 

> Between -rc1 and -rc2:
> 
> 	ieee1394: sbp2: more correct Kconfig dependencies
> 	e4f8cac5e07528f7e0bc21d3682c16c9de993ecb
> 	unrelated
> 
> 	ieee1394: revert "sbp2: enforce 32bit DMA mapping"
> 	a9c2f18800753c82c45fc13b27bdc148849bdbb2
> 	unrelated
> 
> 	(not via linux1394-2.6.git)
> 	raw1394 __user annotation
> 	5b26e64ea39e45802c5736c8261bf8a8704d212f
> 	unrelated
> 
> So it must be something older which was somehow uncovered.
> Dmesg with the oops or/and bisection would be good.

The others look even more innocent. I wonder if this may have been
responsible?

commit 831441862956fffa17b9801db37e6ea1650b0f69
tree b0334921341f8f1734bdd3243de76d676329d21c
parent 787d2214c19bcc9b6ac48af0ce098277a801eded
author Rafael J. Wysocki <rjw@sisk.pl> Tue, 17 Jul 2007 04:03:35 -0700
committer Linus Torvalds <torvalds@woody.linux-foundation.org> Tue, 17
Jul 2007 10:23:02 -0700

    Freezer: make kernel threads nonfreezable by default

Or this one?

commit 20c2df83d25c6a95affe6157a4c9cac4cf5ffaac
tree 415c4453d2b17a50abe7a3e515177e1fa337bd67
parent 64fb98fc40738ae1a98bcea9ca3145b89fb71524
author Paul Mundt <lethal@linux-sh.org> Fri, 20 Jul 2007 10:11:58
+0900
committer Paul Mundt <lethal@linux-sh.org> Fri, 20 Jul 2007 10:11:58
+0900

    mm: Remove slab destructors from kmem_cache_create().

    Slab destructors were no longer supported after Christoph's
    c59def9f222d44bb7e2f0a559f2906191a0862d7 change. They've been
    BUGs for both slab and slub, and slob never supported them
    either.


									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
