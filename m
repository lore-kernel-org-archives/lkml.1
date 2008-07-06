Return-Path: <linux-kernel-owner+w=401wt.eu-S1759075AbYGFUTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075AbYGFUTn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 16:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbYGFUTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 16:19:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:41520 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbYGFUTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 16:19:35 -0400
Date: Sun, 6 Jul 2008 13:19:37 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Timothy Normand Miller" <theosib@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: HELP: Getting unexpected fakeraid behavior. Fix?
Message-ID: <20080706131937.13065312@infradead.org>
In-Reply-To: <9871ee5f0807061307ncc55104y477c57be3e91b75f@mail.gmail.com>
References: <9871ee5f0807061307ncc55104y477c57be3e91b75f@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jul 2008 16:07:14 -0400
"Timothy Normand Miller" <theosib@gmail.com> wrote:

Him

> - So since fakeraid, as far as Linux is concerned, is just software
> RAID, behavior and performance of fakeraid (dm) and software RAID (md)
> should be identical (via the same drive controller).

there's a few minor nits on this concerning disk layout for non-RAID1;
for RAID1 they should be equivalent.

> 
> Since RAID1 is a mirrored configuration, it's possible to distribute
> reads across the drives, improving throughput and latency over a
> single drive on random reads.

This is.. borderline true. Let me explain the caveats;
for a SINGLE THREADED workload, there is actually no difference. 
Balancing long sequential reads over the 2 disks isn't such a good idea
for that case, since it just introduces seeks rather than keep up with
the streaming speed.
Balancing seeks; there might be some theoretical advantage because you
could, again in theory, do shorter seeks if you keep one head at the
inside and one the other disk head on the outside. In practice... a lot
of the seek time is rotational latency so it's not as big a deal as it
may sound; the moment you seek you pay a ton.


> 
> I have written a program that, on start up, reads through thousands of
> small files, and as a result does a great deal of random reads for
> several minutes.  While that was going on, I ran "iostat -d 2".  My
> observation was that any writes that occurred were correctly sent to
> both disks, but all reads were being requested ONLY from the first
> drive.

if your application is single threaded this isn't totally unexpected as
a result...



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
