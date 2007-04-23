Return-Path: <linux-kernel-owner+w=401wt.eu-S1030787AbXDWEg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030787AbXDWEg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 00:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161178AbXDWEg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 00:36:27 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:39988 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030787AbXDWEg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 00:36:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=c4SqtL5HBb8ZUont1qs1w6cBgqcFb+KxgRxOUzwTRAej3dsYgZsP8EAQKrHiNBHoLu2DbzVcQYzw2H2Y95kmyYk1lFz+7sea2mx1fH0bwBGy9hsk3UhdlgVgbknhlRBwkwkYeZN2AGXN2XEFJhCr2NOMkwtc34BQ/4caZvG4HkA=  ;
X-YMail-OSG: 90HoDFkVM1mb2yAOB.zsfM9yLp1o08F6l3YmqVMsiFt_S9iXj3eUByfp3eK8FVW9ta11kuvKMv.VAXBEtY_1L7_irY5lwnltsbbnppYe_F8aKrIHqL_AXfmOiF0T3g--
Message-ID: <462C37B9.5090600@yahoo.com.au>
Date: Mon, 23 Apr 2007 14:36:09 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Jakub Jelinek <jakub@redhat.com>
CC: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, shak <dshaks@redhat.com>
Subject: Re: [PATCH] lazy freeing of memory through MADV_FREE
References: <46247427.6000902@redhat.com> <20070420135715.f6e8e091.akpm@linux-foundation.org> <462932BE.4020005@redhat.com> <20070420150618.179d31a4.akpm@linux-foundation.org> <4629524C.5040302@redhat.com> <20070421071202.GA355@devserv.devel.redhat.com>
In-Reply-To: <20070421071202.GA355@devserv.devel.redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jakub Jelinek wrote:
> On Fri, Apr 20, 2007 at 07:52:44PM -0400, Rik van Riel wrote:
> 
>>It turns out that Nick's patch does not improve peak
>>performance much, but it does prevent the decline when
>>running with 16 threads on my quad core CPU!
>>
>>We _definately_ want both patches, there's a huge benefit
>>in having them both.
>>
>>Here are the transactions/seconds for each combination:
>>
>>   vanilla   new glibc  madv_free kernel   madv_free + mmap_sem
>>threads
>>
>>1     610         609             596                545
>>2    1032        1136            1196               1200
>>4    1070        1128            2014               2024
>>8    1000        1088            1665               2087
>>16    779        1073            1310               1999
> 
> 
> FYI, I have uploaded a testing glibc that uses MADV_FREE and falls back
> to MADV_DONTUSE if MADV_FREE is not available, to
> http://people.redhat.com/jakub/glibc/2.5.90-21.1/

Hmm, I wonder how glibc malloc stacks up to tcmalloc on this test
(after the mmap_sem patch as well).

I'll try running that as well!

-- 
SUSE Labs, Novell Inc.
