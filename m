Return-Path: <linux-kernel-owner+w=401wt.eu-S1760632AbYG1RUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760632AbYG1RUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 13:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759214AbYG1RUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 13:20:36 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33183 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759113AbYG1RUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 13:20:35 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5347"; a="4940529"
Message-ID: <488DFFD2.7070004@qualcomm.com>
Date: Mon, 28 Jul 2008 10:20:18 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: Li Zefan <lizf@cn.fujitsu.com>, akpm@linux-foundation.org,
       menage@google.com, seto.hidetoshi@jp.fujitsu.com, laijs@cn.fujitsu.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] cpuset: clean up cpuset hierarchy traversal code
References: <488D332A.1030008@cn.fujitsu.com> <20080728010141.fbd33866.pj@sgi.com>
In-Reply-To: <20080728010141.fbd33866.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Li Zefan wrote:
>> -	q = kfifo_alloc(number_of_cpusets * sizeof(cp), GFP_KERNEL, NULL);
> 
> 
> The block comment for rebuild_sched_domains() states:
> 
>> ... May take callback_mutex during
>> * call due to the kfifo_alloc() and kmalloc() calls.
> 
> I suspect that mention of kfifo_alloc() is no longer correct,
> with your patch.  If so, perhaps you could send a little additional
> fix patch, to remove that mention from the comment.
> 

Paul, please take a look at
	cpuset: Rework sched domains and CPU hotplug handling
patch I sent out last week.
I'd appreciate if we applied that one first. It simplifies lock nesting 
and rearranges the way sched domains are rebuilt. It is IMO a bit higher 
priority than this patch because scheduler depends on the 
rebuild_sched_domains() call and we have to call rebuild_sched_domains() 
from cpu hotplug handlers.

Max

