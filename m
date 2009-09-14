Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbZINQcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbZINQcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 12:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbZINQca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 12:32:30 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:63597 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbZINQc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 12:32:29 -0400
Message-ID: <4AAE6FD7.5070401@nortel.com>
Date: Mon, 14 Sep 2009 10:31:19 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: pavel@pavlinux.ru, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Network Development list <netdev@vger.kernel.org>
Subject: Re: INGO Why you remove  set_user_nice() from kernel/kthread.c
References: <200909141742.45487.pavel@pavlinux.ru>	 <1252937140.6500.11.camel@marge.simson.net>  <4AAE5D60.2080703@nortel.com> <1252943123.12986.70.camel@marge.simson.net>
In-Reply-To: <1252943123.12986.70.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Sep 2009 16:32:29.0248 (UTC) FILETIME=[F3856400:01CA3558]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2009 09:45 AM, Mike Galbraith wrote:
> On Mon, 2009-09-14 at 09:12 -0600, Chris Friesen wrote:
>> On 09/14/2009 08:05 AM, Mike Galbraith wrote:

>>> I did that, not Ingo, and did so because with kthreads that use
>>> diddly-spit CPU (every one I see), it's just a waste of math.  What
>>> kthreads are you seeing using so much CPU that their weight is a factor?
>>> They _should_ be able to preempt and get their work done just fine
>>> without a boost.
>>
>> Under heavy network load ksoftirqd can use significant amounts of cpu.
> 
> OK, that may justify a weight adjustment, since it is a proxy for many.
> Question is, does it really need it?

I guess it depends how we want it to behave by default.  Likely anyone
that really cares is going to fine-tune the ksoftirqd priority level
anyways.

I've added netdev to the CC list.  Maybe some of the people there have
an opinion on what the default priority should be for ksoftirqd.

Chris
