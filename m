Return-Path: <linux-kernel-owner+w=401wt.eu-S1761453AbXJDVsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761453AbXJDVsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 17:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757694AbXJDVsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 17:48:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345AbXJDVsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 17:48:31 -0400
Message-ID: <47055F84.109@redhat.com>
Date: Thu, 04 Oct 2007 17:47:48 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: willy@linux.intel.com, clameter@sgi.com, nickpiggin@yahoo.com.au,
       hch@lst.de, mel@skynet.ie, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, dgc@sgi.com, jens.axboe@oracle.com,
       suresh.b.siddha@intel.com
Subject: Re: SLUB performance regression vs SLAB
References: <20071004192824.GA9852@linux.intel.com>	<20071004.135537.39158051.davem@davemloft.net>	<470554D9.2050505@redhat.com> <20071004.141113.08322956.davem@davemloft.net>
In-Reply-To: <20071004.141113.08322956.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2007 05:11 PM, David Miller wrote:
> From: Chuck Ebbert <cebbert@redhat.com>
> Date: Thu, 04 Oct 2007 17:02:17 -0400
> 
>> How do you simulate reading 100TB of data spread across 3000 disks,
>> selecting 10% of it using some criterion, then sorting and
>> summarizing the result?
> 
> You repeatedly read zeros from a smaller disk into the same amount of
> memory, and sort that as if it were real data instead.

You've just replaced 3000 concurrent streams of data with a single
stream.  That won't test the memory allocator's ability to allocate
memory to many concurrent users very well.
