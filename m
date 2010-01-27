Return-Path: <linux-kernel-owner+w=401wt.eu-S1756299Ab0A0WaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab0A0WaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 17:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756255Ab0A0WaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 17:30:16 -0500
Received: from mail.windriver.com ([147.11.1.11]:55557 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266Ab0A0WaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 17:30:15 -0500
Message-ID: <4B60BE31.5030707@windriver.com>
Date: Wed, 27 Jan 2010 16:29:05 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/4] perf,hw_breakpoint: add lockless reservation forhw_breaks
References: <1264480000-6997-1-git-send-email-jason.wessel@windriver.com> <1264480000-6997-3-git-send-email-jason.wessel@windriver.com> <4B5F419F.2090901@windriver.com> <20100127175647.GA23017@nowhere>
In-Reply-To: <20100127175647.GA23017@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jan 2010 22:29:06.0847 (UTC) FILETIME=[234022F0:01CA9FA0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Tue, Jan 26, 2010 at 01:25:19PM -0600, Jason Wessel wrote:
>   
>> @@ -250,11 +326,16 @@ int reserve_bp_slot(struct perf_event *b
>>  
>>  	mutex_lock(&nr_bp_mutex);
>>  
>> +	ret = dbg_hw_breakpoint_alloc(bp->cpu);
>> +	if (ret)
>> +		goto end;
>> +
>>     
>
>
>
> This is totally breaking all the constraints that try to
> make the reservation cpu-wide/task-wide aware.
>   

Agreed.  I was unaware of all the various pieces that the toggle_bp
handled.

A revised series is on the way based on the off-list discussion.

Thanks,
Jason.

