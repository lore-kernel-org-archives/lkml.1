Return-Path: <linux-kernel-owner+w=401wt.eu-S1750904AbXBSKjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750904AbXBSKjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 05:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbXBSKjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 05:39:35 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:55396 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbXBSKje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 05:39:34 -0500
Message-ID: <45D97E5E.7060603@in.ibm.com>
Date: Mon, 19 Feb 2007 16:09:26 +0530
From: Balbir Singh <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, ckrm-tech@lists.sourceforge.net, xemul@sw.ru,
       linux-mm@kvack.org, svaidy@linux.vnet.ibm.com, devel@openvz.org
Subject: Re: [RFC][PATCH][0/4] Memory controller (RSS Control)
References: <20070219065019.3626.33947.sendpatchset@balbir-laptop> <20070219005441.7fa0eccc.akpm@linux-foundation.org> <6599ad830702190106m3f391de4x170326fef2e4872@mail.gmail.com>
In-Reply-To: <6599ad830702190106m3f391de4x170326fef2e4872@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On 2/19/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> Alas, I fear this might have quite bad worst-case behaviour.  One small
>> container which is under constant memory pressure will churn the
>> system-wide LRUs like mad, and will consume rather a lot of system time.
>> So it's a point at which container A can deleteriously affect things 
>> which
>> are running in other containers, which is exactly what we're supposed to
>> not do.
> 
> I think it's OK for a container to consume lots of system time during
> reclaim, as long as we can account that time to the container involved
> (i.e. if it's done during direct reclaim rather than by something like
> kswapd).
> 
> Churning the LRU could well be bad though, I agree.
> 

I completely agree with you on reclaim consuming time.

Churning the LRU can be avoided by the means I mentioned before

1. Add a container pointer (per page struct), it is also
    useful for the page cache controller
2. Check if the page belongs to a particular container before
    the list_del(&page->lru), so that those pages can be skipped.
3. Use a double LRU list by overloading the lru list_head of
    struct page.

> Paul
> 


-- 
	Warm Regards,
	Balbir Singh
