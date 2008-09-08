Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbYIHWae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbYIHWae (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 18:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYIHWa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 18:30:26 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:12781 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbYIHWaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 18:30:25 -0400
Message-ID: <48C5A77D.50302@hp.com>
Date: Mon, 08 Sep 2008 18:30:21 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Benchmarking results: DSS elapsed time values w/ rq_affinity=0/1
  - Jens' for-2.6.28 tree
References: <48C15C02.7060504@hp.com> <48C31095.6020206@hp.com> <20080908181046.GM20055@kernel.dk>
In-Reply-To: <20080908181046.GM20055@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> > On Sat, Sep 06 2008, Alan D. Brunelle wrote:
>> >> Here are some results obtained during runs where we varied the
number of
>> >>  readers & the multi-block read counts. 5 runs per rq_affinity setting
>> >> were done, and the averages are plotted at:
>> >>
>> >> http://free.linux.hp.com/~adb/jens/08-09-05/by_mbr.jpeg
>> >>
> > Thanks a lot for these numbers Alan, it definitely looks like a clear
> > win (and a pretty big one) for all of the above and the previous mail.
> > It would be interesting to see sys and usr times seperately, as well as
> > trying to compare profiles of two runs. On the testing that I did with a
> > 4-way ppc box, lock contention and bouncing was way down with XFS and
> > btrfs. I didn't test other file systems yet. I saw mean acquisition and
> > hold time reductions in the 20-30% range and waittime reductions of over
> > 40% in just simple meta data intensive fs testing.

Jens:

The graph up at :

http://free.linux.hp.com/~adb/jens/09-08-05/p_stats2.png

may or may not help clarify some things (the p_stats2.agr file in the
same directory can be fed into xmgrace, it may show better then the .png
file that was rendered).

The bottom graph shows reads (as measured by iostat), then above that
are the %user, %system and (%user+%system) values (as measured by
iostat). Black lines are rq_affinity=0 and red are for rq_affinity=1

/All/ values presented are averaged out over the 68 runs I did.

When rq_affinity=1, it appears that we attain the peak performance
/much/ quicker, and then we plateau out (gated by SOMETHING...). You'll
note that the red lines "terminate" quicker, as the work is more
front-loaded.

I don't see a large delta in %system between the two - and what is there
appears to be proportional to the increased I/O bandwidth. The increase
in %user also seems to be in proportion to the I/O (which is in
proportion to the DSS load capable of being performed).

I'm not sure if this helps much, but I think it may help answer part of
your question regarding %user + %sys. I'll work on some lock & profile
stuff on Tuesday (9/9/08).

Alan




