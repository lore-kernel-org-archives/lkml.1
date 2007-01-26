Return-Path: <linux-kernel-owner+w=401wt.eu-S1030855AbXAZQtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030855AbXAZQtG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:49:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030850AbXAZQtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:49:06 -0500
Received: from calculon.skynet.ie ([193.1.99.88]:40246 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030852AbXAZQtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:49:03 -0500
Date: Fri, 26 Jan 2007 16:49:00 +0000 (GMT)
From: Mel Gorman <mel@csn.ul.ie>
X-X-Sender: mel@skynet.skynet.ie
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] Create the ZONE_MOVABLE zone
In-Reply-To: <Pine.LNX.4.64.0701260822510.6141@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0701261648280.23091@skynet.skynet.ie>
References: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie>
 <20070125234538.28809.24662.sendpatchset@skynet.skynet.ie>
 <Pine.LNX.4.64.0701260822510.6141@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007, Christoph Lameter wrote:

> On Thu, 25 Jan 2007, Mel Gorman wrote:
>
>> @@ -166,6 +168,8 @@ enum zone_type {
>>  #define ZONES_SHIFT 1
>>  #elif __ZONE_COUNT <= 4
>>  #define ZONES_SHIFT 2
>> +#elif __ZONE_COUNT <= 8
>> +#define ZONES_SHIFT 3
>>  #else
>
> You do not need a shift of 3. Even with ZONE_MOVABLE the maximum
> number of zones is still 4.
>
> x86_64 has DMA, DMA32, NORMAL, MOVABLE
> i386 has DMA, NORMAL, HIGHMEM, MOVABLE
>
> x86_64 is the only platform that has DMA32.
>

Good point. I'll recheck this to be sure but if it's true, it means that 
the only major collision point between these patches and the optional 
ZONE_DMA patches goes away.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
