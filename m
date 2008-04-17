Return-Path: <linux-kernel-owner+w=401wt.eu-S935098AbYDQLOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935098AbYDQLOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 07:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933739AbYDQLJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 07:09:19 -0400
Received: from smtp2.sssup.it ([193.205.80.100]:50636 "EHLO smtp2.sssup.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934383AbYDQLJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 07:09:15 -0400
Date: Thu, 17 Apr 2008 13:14:07 +0200
From: Fabio Checconi <fchecconi@gmail.com>
To: Aaron Carroll <aaronc@cse.unsw.edu.au>
Cc: Paolo Valente <paolo.valente@unimore.it>,
       Jens Axboe <jens.axboe@oracle.com>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [RESEND][RFC] BFQ I/O Scheduler
Message-ID: <20080417111407.GS62286@gandalf.sssup.it>
References: <20080401152903.GB34860@gandalf.sssup.it> <20080416184441.GA3923@ucw.cz> <4806EACB.7040408@unimore.it> <20080417071012.GP12774@kernel.dk> <480709A2.7040606@unimore.it> <48072549.7040104@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48072549.7040104@cse.unsw.edu.au>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Aaron Carroll <aaronc@cse.unsw.edu.au>
> Date: Thu, Apr 17, 2008 08:24:09PM +1000
>
> Paolo Valente wrote:
> >In my opinion, the time-slice approach of cfq is definitely better 
> >suited than the (sector) budget approach for this type of workloads. On 
> >the opposite end, the price of time-slices is unfairness towards, e.g., 
> >threads doing sequential accesses. In bfq we were mainly thinking about 
> 
> How do you figure that?  This is a situation where time-slices work nicely,
> because they implicitly account for the performance penalty of poor access
> patterns.  The sequential-accessing processes (and the system overall) ends
> up with higher throughput.
> 

The unfairness is not WRT tasks generating poor access patterns.
If you have two tasks doing sequential accesses on two different
regions of the disk the exact amount of service they receive in the
same amount of time depends on the transfer rate of the disk on
that regions, and, depending on the media, it is not always the same.

We showed some example of that in the original post and it is quite
easy to try it out if you put two partitions at the ends of a disk
and you try to read from them concurrently.
