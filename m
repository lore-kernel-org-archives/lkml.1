Return-Path: <linux-kernel-owner+w=401wt.eu-S1762010AbYCEWLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762010AbYCEWLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 17:11:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbYCEWLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:11:37 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:47703 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903AbYCEWLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:11:36 -0500
Date: Wed, 5 Mar 2008 23:11:26 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Hugh Dickins <hugh@veritas.com>
cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc3: 34TB vmalloc total -- overflow in /proc/meminfo?
In-Reply-To: <Pine.LNX.4.64.0803052045430.821@blonde.site>
Message-ID: <alpine.DEB.1.00.0803052301340.8658@sheep.housecafe.de>
References: <20080305090610.GA30024@atrey.karlin.mff.cuni.cz> <alpine.DEB.1.00.0803052038410.8658@sheep.housecafe.de> <Pine.LNX.4.64.0803052045430.821@blonde.site>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2008, Hugh Dickins wrote:
> I don't see what Pavel's issue is with this: it's simply a fact that
> with a 64-bit kernel, we've lots of virtual address space to spare
> for vmalloc.  What would be surprising is for VmallocUsed to get up
> as high as that.

OK, thanks for the clarification.

> Completely different and much more interesting.

Well, if it's "interesting"...here are some more details from the box:

http://nerdbynature.de/bits/2.6.19.2/

> Unlikely.  Offhand I'm not quite sure that's impossible, but it's far
> more likely that we've a kernel bug and vm_committed_space has wrapped
> negative.

Huh. When I first saw this I thought "kernel bug" too, but then read the
documentation to Committed_AS I thought it's just userspace related...

> Ancient as your kernel is, I don't notice anything in the ChangeLogs
> since then to say we've fixed a bug of that kind since 2.6.19.
> Any idea how to reproduce this?

Well, the box is running fine and since it's a production machine I don't 
intend to reboot the box very often. And since it's really an old kernel 
(for lkml discussion, that is) I don't intend to debug this one further. 
I really was only curious if this was userspace related (some app 
overcommitting) or some kernel weirdness.

>  Are you using HugePages at all?

I have:

# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set

...was this, what you meant?

Thanks,
Christian.
-- 
BOFH excuse #340:

Well fix that in the next (upgrade, update, patch release, service pack).
