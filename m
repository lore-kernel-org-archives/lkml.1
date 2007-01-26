Return-Path: <linux-kernel-owner+w=401wt.eu-S1161150AbXAZSlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161150AbXAZSlz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 13:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161140AbXAZSlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 13:41:55 -0500
Received: from zcars04f.nortel.com ([47.129.242.57]:57655 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161150AbXAZSly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 13:41:54 -0500
Message-ID: <45BA4B57.1070604@nortel.com>
Date: Fri, 26 Jan 2007 12:41:27 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: vatsa@in.ibm.com
CC: riel@redhat.com, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Fair-user scheduler
References: <20070126060142.GA2487@in.ibm.com>
In-Reply-To: <20070126060142.GA2487@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jan 2007 18:41:31.0051 (UTC) FILETIME=[989B47B0:01C74179]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Srivatsa Vaddagiri wrote:
> Current Linux CPU scheduler doesnt recognize process aggregates while
> allocating bandwidth. As a result of this, an user could simply spawn large 
> number of processes and get more bandwidth than others.
> 
> Here's a patch that provides fair allocation for all users in a system.
> 
> Some benchmark numbers with and without the patch applied follows:
> 
> 
> 		 	user "vatsa"		    user "guest"
> 		    (make -s -j4 bzImage)      (make -s -j20 bzImage)
> 
> 2.6.20-rc5		472.07s (real)		   257.48s (real)
> 2.6.20-rc5+fairsched	766.74s (real)		   766.73s (real)

As Kirill brought up, why does it take so much more time?  Are you 
thrashing the cache?

> 	- breaks O(1) (ouch!)
> 		Best way to avoid this is to split runqueue to be per-user and
> 		per-cpu, which I have not implemented to keep the patch simple.

Presumably this would be made generic, as in per-"group" rather than per 
user?

> 	- Fairsched aware SMP load balance NOT addressed (yet)

This is kind of important, no?

Chris
