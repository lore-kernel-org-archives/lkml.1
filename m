Return-Path: <linux-kernel-owner+w=401wt.eu-S1765345AbZLQVPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765345AbZLQVPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 16:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765320AbZLQVPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 16:15:35 -0500
Received: from smtp-out.google.com ([216.239.33.17]:62225 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765262AbZLQVPc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 16:15:32 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=TUY2SLhRyJJ1S5gzk1xSuD4MrgHVXlGyqXqyjcqDuDKwWX3RAOSYtOuGqz3bD5KLM
	Z6ATVNejditw9Vv8yH0tg==
MIME-Version: 1.0
In-Reply-To: <alpine.WNT.2.00.0912170919010.2612@jbrandeb-desk1.amr.corp.intel.com>
References: <Pine.LNX.4.44L0.0912171046070.2645-100000@iolanthe.rowland.org> 
	<200912171810.45575.roger.oksanen@cs.helsinki.fi> <alpine.WNT.2.00.0912170919010.2612@jbrandeb-desk1.amr.corp.intel.com>
From: Laurent Chavey <chavey@google.com>
Date: Thu, 17 Dec 2009 13:15:04 -0800
Message-ID: <97949e3e0912171315g537903f7m9461ea8399dc018c@mail.gmail.com>
Subject: Re: e100 REGRESSION in 2.6.32 (PATCH v2)
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Cc: Roger Oksanen <roger.oksanen@cs.helsinki.fi>,
       Alan Stern <stern@rowland.harvard.edu>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when using DMAPOOL_DEBUG, do we really want to
over-write 	memset(retval, POOL_POISON_ALLOCATED, pool->size);
set in  dma_pool_alloc.


On Thu, Dec 17, 2009 at 9:21 AM, Brandeburg, Jesse
<jesse.brandeburg@intel.com> wrote:
>
> On Thu, 17 Dec 2009, Roger Oksanen wrote:
>> e100: Fix broken cbs accounting due to missing memset.
>>
>> Alan Stern noticed that e100 caused slab corruption.
>> commit 98468efddb101f8a29af974101c17ba513b07be1 changed
>> the allocation of cbs to use dma pools that don't return zeroed memory,
>> especially the cb->status field used to track which cb to clean, causing
>> (the visible) double freeing of skbs and a wrong free cbs count.
>>
>> Now the cbs are explicitly zeroed at allocation time.
>>
>> Reported-by: Alan Stern <stern@rowland.harvard.edu>
>> Tested-by: Alan Stern <stern@rowland.harvard.edu>
>> Signed-off-by: Roger Oksanen <roger.oksanen@cs.helsinki.fi>
>
> Change looks reasonable, ACK.
>
> should we also consider a followon patch to zero memory allocated with
> pci_pools?  Seems useful.
>
> Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
