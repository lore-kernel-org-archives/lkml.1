Return-Path: <linux-kernel-owner+w=401wt.eu-S1752875AbYCJI4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbYCJI4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 04:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbYCJI4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 04:56:42 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:59914 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751310AbYCJI4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 04:56:41 -0400
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.2
To: Anders Eriksson <aeriksson@fastmail.fm>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.25-rc4 
In-reply-to: <20080308210559.0C7A193C070@tippex.mynet.homeunix.org> 
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <200803061438.22205.bzolnier@gmail.com> <20080306133347.GA23495@elte.hu> <200803061506.19449.bzolnier@gmail.com> <20080306135532.GG17940@kernel.dk> <20080306211726.2DA8C93C881@tippex.mynet.homeunix.org> <20080307084818.GK17940@kernel.dk> <20080307220432.D47E02DC047@tippex.mynet.homeunix.org> <alpine.LFD.1.00.0803081217250.2911@woody.linux-foundation.org> <20080308210559.0C7A193C070@tippex.mynet.homeunix.org>
Comments: In-reply-to Anders Eriksson <aeriksson@fastmail.fm>
   message dated "Sat, 08 Mar 2008 22:05:58 +0100."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Mon, 10 Mar 2008 09:55:39 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080310085539.6815693C900@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.237.4
X-Scan-Result: No virus found in message 1JYdnx-0002ZH-98.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1JYdnx-0002ZH-98 87e33671387a666ad5d1c768764166ac
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



aeriksson@fastmail.fm said:
> torvalds@linux-foundation.org said:
>> I think we do want the bisect run here.
>> My worry is that this is likely very timing-sensitive, so when it starts
>> failing it might not be because of the commit that actually introduces the
>> bug, but because some other timing changed, but with some luck that won't  
>> be the case.

> I'm on it. Slow machine. Household's router, 4000 versions to go... 

The bisect came up with this:

18a056feccabdfa9764016a615121b194828bc72 is first bad commit
commit 18a056feccabdfa9764016a615121b194828bc72
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Sat Jan 26 20:13:12 2008 +0100

    ide: don't enable local IRQs for PIO-in in driver_cmd_intr() (take 2)

    Don't enable local IRQs for PIO-in protocol in driver_cmd_intr().

    While at it:

    * Remove redundant rq->cmd_type check.

    * Read status register after enabling local IRQs for no-data protocol.

    v2:
    * Re-add DRQ=1 check lost in v1 (noticed by Sergei).

    Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

:040000 040000 5fb514a261b13494c5e9c035f9e7598276ce8839 0fda2eb7d96335061741d7f54ed3e05ca34ac5b8 M      drivers


