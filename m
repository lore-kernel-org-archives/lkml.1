Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbXIPRxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbXIPRxt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 13:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbXIPRxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 13:53:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:57054 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbXIPRxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 13:53:38 -0400
Date: Sun, 16 Sep 2007 19:54:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Ben Collins <ben.collins@ubuntu.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux1394-devel@lists.sourceforge.net
Subject: Re: regression: fireware causes oops during system
Message-ID: <20070916175424.GB11983@elf.ucw.cz>
References: <20070911190043.GA1577@elf.ucw.cz> <1189537716.7620.192.camel@cunning> <46E6ECAA.30601@s5r6.in-berlin.de> <46E6F076.5000006@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E6F076.5000006@s5r6.in-berlin.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

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
> 
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

Sorry, had to hand-copy. It is oops at virtual adddress 6b6b6b7b --
looks like slab poison to me?

EIP is in task_rq_lock, backtrace is
try_to_wake_up
highlevel_host_reset
ohci_irq_handler
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
