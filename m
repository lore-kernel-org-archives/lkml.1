Return-Path: <linux-kernel-owner+w=401wt.eu-S1758135AbYDCJpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135AbYDCJpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 05:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750792AbYDCJpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 05:45:04 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:42602 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbYDCJpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 05:45:02 -0400
Message-ID: <47F4A700.3080307@linux.vnet.ibm.com>
Date: Thu, 03 Apr 2008 15:14:32 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: [-mm] Make the memory controller more desktop responsive
References: <20080403093253.8944.10168.sendpatchset@localhost.localdomain> <20080403184351.42de4f56.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080403184351.42de4f56.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Thu, 03 Apr 2008 15:02:53 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>> This patch makes the memory controller more responsive on my desktop.
>>
>> Here is what the patch does
>>
>> 1. Reduces the number of retries to 2. We had 5 earlier, since we
>>    were controlling swap cache as well. We pushed data from mappings
>>    to swap cache and we needed additional passes to clear out the cache.
> 
> Hmm, what this change improves ?
> I don't want to see OOM.
> 

I had set it to 5 earlier, since the swap cache came back to our memory
controller, where it was accounted. I have not seen OOM with it on my desktop,
but at some point if the memory required is so much that we cannot fulfill it,
we do OOM. I have not seen any OOM so far with these changes.

>> 2. It sets all cached pages as inactive. We were by default marking
>>    all pages as active, thus forcing us to go through two passes for
>>    reclaiming pages
> Agreed.
> 
>> 3. Removes congestion_wait(), since we already have that logic in
>>    do_try_to_free_pages()
>>
> Agreed.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
