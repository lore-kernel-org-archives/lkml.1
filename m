Return-Path: <linux-kernel-owner+w=401wt.eu-S1763457AbXFEG4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763457AbXFEG4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 02:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761534AbXFEG4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 02:56:32 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:59345 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760978AbXFEG4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 02:56:31 -0400
Message-ID: <466507B4.2070802@linux.vnet.ibm.com>
Date: Tue, 05 Jun 2007 12:20:28 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Maxim Uvarov <muvarov@ru.mvista.com>, LKML <linux-kernel@vger.kernel.org>,
       Shailabh Nagar <nagar@watson.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Jay Lan <jlan@engr.sgi.com>
Subject: Re: [PATCH] Performance Stats: Kernel patch
References: <20070530184945.28147.50305.stgit@localhost.localdomain> <20070604121955.734de15e.akpm@linux-foundation.org>
In-Reply-To: <20070604121955.734de15e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 30 May 2007 18:49:46 +0000
> Maxim Uvarov <muvarov@ru.mvista.com> wrote:
> 
>> +void print_taskstats(struct taskstats *t)
>> +{
>> +	printf("\n\nTask   %15s%15s\n"
>> +	       "       %15lu%15lu\n",
>> +	       "voluntary", "nonvoluntary",
>> +	       t->nvcsw, t->nivcsw);
>> +}
> 
> print_task_stats versus print_taskstats is a bit confusing, but I guess it
> doesn't matter.
> 
> More significantly, the whole idea of calling it "task stats" isn't a good
> one: it's far too general.  The whole kernel interface is called taskstats,
> but the additions here are a tiny part of that.
> 
> Perhaps task_context_switch_rates would be more appropriate, although
> rather a lot to type.
>

I agree, taskstats is the name given to the genetlink interface.

 
> The patch otherwise seems OK.  Thoughts:
> 
> - Do we need to increment TASKSTATS_VERSION for this?  I forget the rules
>   there.

Any ABI change should result in a version bump. So the bump is ok

> 
> - The lack of context-switch accounting in taskstats is, I think, a
>   simple oversight.  It should have been included on day one.  
> 

Yes, it should have been included

>   There are perhaps other things which _should_ be in taskstats, but we
>   forgot to add them.  Can we think of any such things?
>

I think it's worth reviewing the data exported. I thought CSA filled
out the gaps, but it's definitely worth revisiting.

 
>   We shouldn't just toss any old random stuff in there: it should be
>   things which make sense, and which Unix or Linux accounting traditionally
>   provides, and it should be something which we expect won't suddenly
>   become unsupportable if people make internal kernel changes.
> 

Yes, agreed. The interface must also be open for changes to accounting information
that might be useful as a result of new features, like containers, etc.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
