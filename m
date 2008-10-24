Return-Path: <linux-kernel-owner+w=401wt.eu-S1757294AbYJXVNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294AbYJXVNv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 17:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbYJXVNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 17:13:44 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:64929 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbYJXVNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 17:13:44 -0400
Message-ID: <49023A82.8040708@nortel.com>
Date: Fri, 24 Oct 2008 15:13:38 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, efault@gmx.de,
       vatsa@in.ibm.com
Subject: Re: [PATCH 7/8] sched: non-zero lag renice
References: <20081024090611.936552213@chello.nl> <20081024091109.912152294@chello.nl>  <49020A2A.5070809@nortel.com> <1224880083.7753.6.camel@twins>
In-Reply-To: <1224880083.7753.6.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Oct 2008 21:13:39.0587 (UTC) FILETIME=[62C61530:01C9361D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Fri, 2008-10-24 at 11:47 -0600, Chris Friesen wrote:
>> Peter Zijlstra wrote:
>>
>>  > Then renicing, esp when lowering nice value (getting heavier), its possible
>>  > to get into a starvation scenario. If you got too much runtime as a very
>>  > light task, you get shot way far too the right, which means you'll have to
>>  > wait for a long time in order to run again.
>>  >
>>  > If during that wait you get reniced down, fairness would suggest you get run
>>  > earlier, because you deserve more time.
>>  >
>>  > This can be solved by scaling the vruntime so that we keep the real-time
>>  > lag invariant.
>>
>> If we've already been shot way out to the right, presumably that would give us 
>> a large real-time lag.  If we renice to a lower nice level, wouldn't we want 
>> to reduce the real-time lag rather than make it constant?

Sorry, the patches arrived out of order and my comments were sent out before 
reading your definition of "lag" as "the difference between the service time 
received from the ideal model and the actual scheduler".

I was using a definition of lag as "amount of time before the process gets 
scheduled again".

Given your definition, I think the patch makes sense.

Chris
