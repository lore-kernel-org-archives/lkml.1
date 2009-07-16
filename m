Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbZGPDnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbZGPDnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 23:43:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757335AbZGPDnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 23:43:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59003 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757334AbZGPDnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 23:43:08 -0400
Message-ID: <4A5EA1A4.1080502@redhat.com>
Date: Wed, 15 Jul 2009 23:42:28 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH -mm] throttle direct reclaim when too many pages are isolated
 already
References: <20090715223854.7548740a@bree.surriel.com>	<20090715194820.237a4d77.akpm@linux-foundation.org>	<4A5E9A33.3030704@redhat.com>	<20090715202114.789d36f7.akpm@linux-foundation.org>	<4A5E9E4E.5000308@redhat.com> <20090715203854.336de2d5.akpm@linux-foundation.org>
In-Reply-To: <20090715203854.336de2d5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 15 Jul 2009 23:28:14 -0400 Rik van Riel <riel@redhat.com> wrote:

>> If we are stuck at this point in the page reclaim code,
>> it is because too many other tasks are reclaiming pages.
>>
>> That makes it fairly safe to just return SWAP_CLUSTER_MAX
>> here and hope that __alloc_pages() can get a page.
>>
>> After all, if __alloc_pages() thinks it made progress,
>> but still cannot make the allocation, it will call the
>> pageout code again.
> 
> Which will immediately return because the caller still has
> fatal_signal_pending()?

Other processes are in the middle of freeing pages at
this point, so we should succeed in __alloc_pages()
fairly quickly (and then die and free all our memory).

-- 
All rights reversed.
