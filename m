Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbYB0Edq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbYB0Edq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 23:33:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbYB0Edh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 23:33:37 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:35895 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753287AbYB0Edg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 23:33:36 -0500
Message-ID: <47C4E6CD.6090401@linux.vnet.ibm.com>
Date: Wed, 27 Feb 2008 09:57:57 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20071129)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [RFC][PATCH] page reclaim throttle take2
References: <20080226104647.FF26.KOSAKI.MOTOHIRO@jp.fujitsu.com> <1204060718.6242.333.camel@lappy> <20080227131939.4244.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080227131939.4244.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Hi Peter,
> 
>>> +
>>> +	atomic_t		nr_reclaimers;
>>> +	wait_queue_head_t	reclaim_throttle_waitq;
>>>  	/*
>>>  	 * rarely used fields:
>>>  	 */
>> Small nit, that extra blank line seems at the wrong end of the text
>> block :-)
> 
> Agghhh, sorry ;-)
> I'll fix at next post.
> 
>>> +out:
>>> +	atomic_dec(&zone->nr_reclaimers);
>>> +	wake_up_all(&zone->reclaim_throttle_waitq);
>>> +
>>> +	return ret;
>>> +}
>> Would it be possible - and worthwhile - to make this FIFO fair?
> 
> Hmmm
> may be, we don't need perfectly fair.
> because try_to_free_page() is unfair mechanism.
> 
> but I will test use wake_up() instead wake_up_all().
> it makes so so fair order if no performance regression happend.
> 
> Thanks very useful comment.

One more thing, I would request you to add default heuristics (number of
reclaimers), based on the number of cpus in the system. Letting people tuning it
is fine, but defaults should be related to number of cpus, nodes and zones on
the system. Zones can be reaped in parallel per node and cpus allow threads to
run in parallel. So please use that to come up with good defaults, instead of a
number like "3".

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
