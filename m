Return-Path: <linux-kernel-owner+w=401wt.eu-S1752475AbZIYWhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbZIYWhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 18:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbZIYWhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 18:37:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:34088 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbZIYWhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 18:37:47 -0400
Subject: Re: massive_intr on CFS, BFS, and EDF
From: Peter Zijlstra <peterz@infradead.org>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       sat <takeuchi_satoru@jp.fujitsu.com>,
       lkml <linux-kernel@vger.kernel.org>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Raistlin <raistlin@linux.it>
In-Reply-To: <4ABD36CE.3080400@nortel.com>
References: <4ABC068A.6070704@jp.fujitsu.com>
	 <4ABCEABC.4050200@gandalf.sssup.it>  <4ABD36CE.3080400@nortel.com>
Content-Type: text/plain
Date: Sat, 26 Sep 2009 00:37:38 +0200
Message-Id: <1253918258.18939.192.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-25 at 15:31 -0600, Chris Friesen wrote:
> On 09/25/2009 10:07 AM, Michael Trimarchi wrote:
> > It is important to note that
> > the expected behavior of an edf scheduler is *not* a fair one. It has to
> > do its best to guarantee the deadlines of the admitted tasks.
> 
> Do you allow oversubscription with EDF?  It would seem so based on these
> results.  Would it maybe make sense to disallow oversubscription, or
> make it an option?

afaiu he doesn't, he simply splits the task's wcet between parent and
child and (intends?) to feed back on child exit.

> If you have massive oversubscription with EDF, what is the design
> intent?  Do you try to meet the goals on as many tasks as possible,
> while the oversubscribed tasks get nothing?

oversubscribing edf isn't in general recommended, iirc u>1 gives
unbounded latencies with edf.

