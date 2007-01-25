Return-Path: <linux-kernel-owner+w=401wt.eu-S965361AbXAYFtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965361AbXAYFtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 00:49:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965360AbXAYFtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 00:49:46 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:42249 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965365AbXAYFtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 00:49:45 -0500
Message-ID: <45B844E3.4050203@linux.vnet.ibm.com>
Date: Thu, 25 Jan 2007 11:19:23 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 1.5.0.5 (X11/20060728)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Christoph Lameter <clameter@sgi.com>, Aubrey Li <aubreylee@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       "Henn, erich, Michael" <Michael.Hennerich@analog.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Limit the size of the pagecache
References: <Pine.LNX.4.64.0701231645260.5239@schroedinger.engr.sgi.com> <45B75208.90208@linux.vnet.ibm.com> <Pine.LNX.4.64.0701240655400.9696@schroedinger.engr.sgi.com> <45B82F41.9040705@linux.vnet.ibm.com> <45B835FE.6030107@redhat.com>
In-Reply-To: <45B835FE.6030107@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Rik van Riel wrote:
> Vaidyanathan Srinivasan wrote:
> 
>> In my opinion, once a
>> file page is mapped by the process, then it should be treated at par
>> with anon pages.  Application programs generally do not mmap a file
>> page if the reuse for the content is very low.
> 
> Why not have the VM measure this, instead of making wild
> assumptions about every possible workload out there?

Yes, VM page aging and page replacement algorithm should decide on the
relevance of anon or mmap page.  However we may still need to limit
total pages in memory for a given set of process.

> There are a few databases out there that mmap the whole
> thing.  Sleepycat for one...
> 

That is why my suggestion would be not to touch mmapped pagecache
pages in the current pagecache limit code.  The limit should concern
only unmapped pagecache pages.

When the application unmaps the pages, then instantly we would go over
limit and 'now' unmapped pages can be reclaimed.  This behavior has
been verified with my fix on top of Christoph's patch.

