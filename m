Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbYKXPYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbYKXPYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 10:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbYKXPYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 10:24:15 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:61554 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbYKXPYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 10:24:14 -0500
Message-ID: <492AC715.9080602@nortel.com>
Date: Mon, 24 Nov 2008 09:24:05 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Dhaval Giani <dhaval@linux.vnet.ibm.com>, bharata@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sched: Don't allow priority switch to realtime when the
 task doesn't belong to init_task_group and when CONFIG_RT_GROUP_SCHED isn't
 set
References: <20081120061854.GA4349@in.ibm.com>	 <1227402676.7685.19942.camel@twins> <20081124035807.GA3278@in.ibm.com>	 <1227515526.7685.21861.camel@twins>	 <20081124084644.GA26526@linux.vnet.ibm.com> <1227517575.7685.21906.camel@twins>
In-Reply-To: <1227517575.7685.21906.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Nov 2008 15:24:08.0812 (UTC) FILETIME=[B20602C0:01C94E48]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2008-11-24 at 14:16 +0530, Dhaval Giani wrote:
> 
> 
>>Which would mean the init_task_group becase it contains those tasks which are
>>not grouped.
> 
> 
> Only because of implementation details (we implement the !group case by
> having them all part of a single group), conceptually they don't belong
> to any group, hence talking about moving it to some group is just wrong.

> Furthermore your statement shows another misconception, a group of
> ungrouped tasks doesn't make sense.

Arguably there is such a group, which is "the set of all RT tasks".

Whether or not they should map to the top-level cgroup is a different 
question.  Maybe in the !group case there should be a second top-level 
"rt" cgroup?  We could even make the RT sched tuning knobs available there.

Chris

