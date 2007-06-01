Return-Path: <linux-kernel-owner+w=401wt.eu-S1760148AbXFAHfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148AbXFAHfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 03:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756136AbXFAHfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 03:35:24 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:42647 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981AbXFAHfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 03:35:24 -0400
Message-ID: <465FCD59.7060301@openvz.org>
Date: Fri, 01 Jun 2007 11:40:09 +0400
From: Pavel Emelianov <xemul@openvz.org>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>, Paul Menage <menage@google.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH 7/8] Scanner changes needed to implement per-container
 scanner
References: <465D9739.8070209@openvz.org> <465D9ABD.7050506@openvz.org> <20070530144647.0ace89f3.akpm@linux-foundation.org> <465FC19B.8090905@linux.vnet.ibm.com>
In-Reply-To: <465FC19B.8090905@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> Andrew Morton wrote:
>>> +		nr_reclaimed += shrink_zones(priority, zones, sc);
>>> +		if (sc->cnt == NULL)
>>> +			shrink_slab(sc->nr_scanned, gfp_mask, lru_pages);
>> We don't we shrink slab if called to shrink a container.
>>
>> This is a fundamental design decision, and a design shortcoming.  A full
>> discussion of this is absolutely appropriate to the patch changelog. 
>> Please don't just hide stuff like this in the patch and leave people
>> wondering, or ignorant.
> 
> Yes, we don't because we do not account for slab usage right now. We account
> only for memory allocated to user space. A good fat comment will help here.
> 
> 

I have already added the comment. But the problem is not in that we
do not account for kernel memory. Shrinking slabs won't unmap any
pages from user-space and thus won't help user to charge more. This
will only make kernel suffer from re-creation of objects.

Thanks,
Pavel.
