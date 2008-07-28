Return-Path: <linux-kernel-owner+w=401wt.eu-S1759952AbYG1UtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759952AbYG1UtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbYG1UtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:49:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053AbYG1UtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:49:13 -0400
Message-ID: <488E2E58.3000306@redhat.com>
Date: Mon, 28 Jul 2008 15:38:48 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, mhalcrow@us.ibm.com, stable@kernel.org
Subject: Re: [PATCH] eCryptfs - use page_alloc not kmalloc to get a page of
 memory
References: <488DF00F.3080809@redhat.com> <20080728133504.156f438f.akpm@linux-foundation.org>
In-Reply-To: <20080728133504.156f438f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 28 Jul 2008 11:13:03 -0500
> Eric Sandeen <sandeen@redhat.com> wrote:
> 
>> With SLUB debugging turned on in 2.6.26, I was getting memory corruption
>> when testing eCryptfs.  The root cause turned out to be that eCryptfs
>> was doing kmalloc(PAGE_CACHE_SIZE); virt_to_page() and treating that
>> as a nice page-aligned chunk of memory.  But at least with SLUB debugging
>> on, this is not always true, and the page we get from virt_to_page does
>> not necessarily match the PAGE_CACHE_SIZE worth of memory we got from 
>> kmalloc.
>>
>> My simple testcase was 2 loops doing "rm -f fileX; cp /tmp/fileX ." for
>> 2 different multi-megabyte files.  With this change I no longer see
>> the corruption.
> 
> The fix applies to both 2.6.25 and to 2.6.26 and appears to be needed
> in both kernel versions, so I have tagged it for backporting into both.

I agree, thanks.

-Eric
