Return-Path: <linux-kernel-owner+w=401wt.eu-S1757378AbYFYXwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbYFYXwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 19:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756865AbYFYXw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 19:52:28 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:50885 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818AbYFYXw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 19:52:27 -0400
Message-ID: <4862DA32.2070102@linux.vnet.ibm.com>
Date: Thu, 26 Jun 2008 05:22:18 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: yamamoto@valinux.co.jp, menage@google.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [1/2] memrlimit handle attach_task() failure, add can_attach()
 callback
References: <20080620150132.16094.29151.sendpatchset@localhost.localdomain> <20080620150142.16094.48612.sendpatchset@localhost.localdomain> <20080625163753.6039c46b.akpm@linux-foundation.org>
In-Reply-To: <20080625163753.6039c46b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 20 Jun 2008 20:31:42 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> +/*
>> + * Add the value val to the resource counter and check if we are
>> + * still under the limit.
>> + */
>> +static inline bool res_counter_add_check(struct res_counter *cnt,
>> +						unsigned long val)
>> +{
>> +	bool ret = false;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&cnt->lock, flags);
>> +	if (cnt->usage + val <= cnt->limit)
>> +		ret = true;
>> +	spin_unlock_irqrestore(&cnt->lock, flags);
>> +	return ret;
>> +}
> 
> The comment and the function name imply that thins function will "Add
> the value val to the resource counter".  But it doesn't do that at all.
> In fact the first arg could be a `const struct res_counter *'.
> 
> Perhaps res_counter_can_add() would be more accurate.

Will fix both problems and send out fixes. I intended to call it
res_counter_check_and_add(), but I don't like "and" in function names.
res_counter_can_add is definitely better.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
