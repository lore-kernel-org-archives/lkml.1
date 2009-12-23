Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850AbZLWNC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbZLWNC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 08:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755539AbZLWNC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 08:02:27 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:40418 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbZLWNC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 08:02:26 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B321458.5020804@s5r6.in-berlin.de>
Date: Wed, 23 Dec 2009 14:00:08 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091025 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: workqueue thing
References: <1261141088-2014-1-git-send-email-tj@kernel.org> <1261143924.20899.169.camel@laptop> <4B2EE5A5.2030208@kernel.org> <1261387377.4314.37.camel@laptop> <4B2F7879.2080901@kernel.org> <1261405604.4314.154.camel@laptop> <4B3009DC.7020407@kernel.org> <1261480001.4937.21.camel@laptop> <4B319A20.9010305@kernel.org> <alpine.LFD.2.00.0912222032360.6879@localhost.localdomain> <20091223060229.GA14805@elte.hu>
In-Reply-To: <20091223060229.GA14805@elte.hu>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Likewise, if there's a reduction in complexity, that is a tangible metric as 
> well: lets do a few conversions as part of the patch-set and see how much 
> simpler things have become as a result of it.

There are for example about 160 users of  create_singlethread_workqueue
(about 140 of them in drivers/.).  As has mentioned by others, many if
not most of them would be better served by either the existing slow-work
API or by the proposed worker thread pool.  Conversion to the former
takes a bit more effort than the latter (not much, but it matters).

The little driver subsystem which I maintain extensively uses the shared
workqueue and also one single-thread workqueue.  The facts that the
shared queue is used for several purposes and a single thread for some
are both just compromises which I would rather like to get rid of.  I
should have converted the create_singlethread_workqueue usage to David
Howells' slow-work infrastructure immediately when that was merged, but
I didn't do so yet because there is too much else on my to-do list for
that particular to-do item...

> We really are not forced to the space of Gedankenexperiments here.

...to actually leave Gedankenexperiment stage as quickly as I would
like.  Tejun's worker pool would make things easier for me.
-- 
Stefan Richter
-=====-==--= ==-- =-===
http://arcgraph.de/sr/
