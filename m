Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076AbXD1TJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbXD1TJN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbXD1TJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:09:12 -0400
Received: from mail.tmr.com ([64.65.253.246]:49308 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076AbXD1TJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:09:10 -0400
Message-ID: <46339BF7.5090906@tmr.com>
Date: Sat, 28 Apr 2007 15:09:43 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: nigel@nigel.suspend2.net
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
References: <1177567481.5025.211.camel@nigel.suspend2.net>	 <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com>	 <1177573348.5025.224.camel@nigel.suspend2.net>	 <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org> <1177617379.4737.29.camel@nigel.suspend2.net>
In-Reply-To: <1177617379.4737.29.camel@nigel.suspend2.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nigel Cunningham wrote:

> Please, go apply that logic elsewhere, then cut out (or at least stop
> adding) support for users with less common needs in other areas. I fully
> acknowledge that most users have only one place to store their image and
> it's a swap device. But that doesn't mean one size fits all.
> 
I think to some extent that's part of the problem. Consider for a moment 
that a /dev/hibernate would be required, and that it must be (a) a disk, 
or (b) a partition, or (c) other devices in the future, like an nbd, USB 
flash or DVD.

Don't have a device like that, then can't hibernate. Stop trying to be 
smart and use swap for two different things. Stop trying to have an 
interface between user space and kernel which does things not required 
to preserve the system. A progress indicator is not needed, power off is 
my progress indicator, and should be the sole valid end of a hibernate.

> A full image implies that you need to figure out what's not going to
> change while you're writing it and save that separately. At the moment,
> I'm treating most of the LRU contents as that list. If we're going to
> start trying to let every man and his dog run while we're trying to
> snapshot the system, that's not going to work anymore - or the logic
> will get a lot more complicated.
> 
> Sorry. I never thought I'd say this, but I think you're being naive
> about how simple the process of snapshotting a system is.

Hibernate is useful to avoid complex boot, it's useful as the UPS gets 
tired, and putting features in the process beyond saving the snap 
(possibly compressed and/or encrypted) just adds complexity. Put it all 
in the kernel and use /sys/power/state as the user interface. Stop 
oversolving the problem.

No, that doesn't avoid other hard issues, but for the most part suspend2 
has addressed them.


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
