Return-Path: <linux-kernel-owner+w=401wt.eu-S1757225AbYISKPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225AbYISKPB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 06:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbYISKOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 06:14:54 -0400
Received: from mail.vpac.org ([202.158.218.6]:54766 "EHLO mail.vpac.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbYISKOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 06:14:53 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.585
Date: Fri, 19 Sep 2008 20:14:46 +1000 (EST)
From: Brett Pemberton <brett@vpac.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <268870537.725801221819286330.JavaMail.root@mail.vpac.org>
In-Reply-To: <20080919015502.4183933d.akpm@linux-foundation.org>
Subject: Re: BUG: soft lockup in 2.6.25.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [124.168.11.114]
X-Mailer: Zimbra 5.0.8_GA_2462.RHEL5_64 (ZimbraWebClient - FF3.0 (Mac)/5.0.8_GA_2462.RHEL5_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Andrew Morton" <akpm@linux-foundation.org> wrote:

> On Fri, 19 Sep 2008 13:49:16 +1000 Brett Pemberton <brett@vpac.org>
> wrote:
> 
> > I'm getting about 3-5 machines in a cluster of 95 hanging with 
> > 
> > BUG: soft lockup - CPU#7 stuck for 61s! [pdflush:321]
> > 
> > per week.  Nothing in common each time, different users running
> > different jobs on different nodes.
> > 
> > The most recent is at the end of this email, .config is attached.
> > 
> > Googling is scary.  Many people reporting these, but never any
> response.
> > It's happening on enough separate nodes that I can't believe it's
> > hardware, although they are identical machines:
> > 
> > - 2x Quad-Core AMD Opteron(tm) Processor 2356
> > - 32gb ram
> > - 4 x sata drives
> > 
> > Running CentOS 5.2 with a kernel.org kernel
> > Has been happening with a variety of kernels from 2.6.25 - present.
> 
> Yes, it's a false positive.  With a lot of memory and a random-access
> or lot-of-files writing behaviour, it can take tremendous amounts of
> time to get everything stored on the disk.
> 
> Not sure what to do about it, really.  Perhaps touch the softlockup
> detector somewhere in the writeback code.
> 
> > I'd love any advice on where to turn to next and what avenues to
> pursue.
> 
> Set /proc/sys/kernel/softlockup_thresh to zero to shut it up :(
> 

Hmm,

I'd love to believe it's a false positive, but I guess I didn't mention that
once a machine gets one of these, it incrementally increases load until it
falls over a few (hours, days) later.

When I've noticed, and have been able to log in and run top before it falls over,
I can see that one or two cores have their processes stuck in a wait state, while
the others continue as normal.

This is consistent.  I've never had a node hit this BUG: and not eventually
die (lose all network connectivity, sit at console waiting for login but
not registering keystrokes) within a week.  The node today hit lockup around
2 hours after registering this BUG:

Surely turning off the detection via the proc file will just mean this will
happen silently in the future?

cheers,

     / Brett
