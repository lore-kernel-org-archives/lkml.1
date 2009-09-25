Return-Path: <linux-kernel-owner+w=401wt.eu-S1752740AbZIYWsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbZIYWsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 18:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbZIYWsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 18:48:17 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:53687 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbZIYWsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 18:48:17 -0400
Message-ID: <4ABD4839.7060508@nortel.com>
Date: Fri, 25 Sep 2009 16:46:17 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       sat <takeuchi_satoru@jp.fujitsu.com>,
       lkml <linux-kernel@vger.kernel.org>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Raistlin <raistlin@linux.it>
Subject: Re: massive_intr on CFS, BFS, and EDF
References: <4ABC068A.6070704@jp.fujitsu.com>	 <4ABCEABC.4050200@gandalf.sssup.it>  <4ABD36CE.3080400@nortel.com> <1253918258.18939.192.camel@laptop>
In-Reply-To: <1253918258.18939.192.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Sep 2009 22:48:02.0434 (UTC) FILETIME=[3CE3F620:01CA3E32]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2009 04:37 PM, Peter Zijlstra wrote:
> On Fri, 2009-09-25 at 15:31 -0600, Chris Friesen wrote:

>> Do you allow oversubscription with EDF?  It would seem so based on these
>> results.  Would it maybe make sense to disallow oversubscription, or
>> make it an option?
> 
> afaiu he doesn't, he simply splits the task's wcet between parent and
> child and (intends?) to feed back on child exit.

How does this work if we have one parent task that forks off a bunch of
kids like massive_intr?  Does each child get half the bandwidth of the
previous child?

> oversubscribing edf isn't in general recommended, iirc u>1 gives
> unbounded latencies with edf.

Right...so would it perhaps be more interesting to try a modified test
where each child's bandwidth is equal and small enough that there is no
oversubscription?

Chris
