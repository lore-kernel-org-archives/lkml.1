Return-Path: <linux-kernel-owner+w=401wt.eu-S1765076AbZEAUHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765076AbZEAUHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 16:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755927AbZEAUHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 16:07:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34600 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691AbZEAUHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 16:07:32 -0400
Message-ID: <49FB5623.3030403@redhat.com>
Date: Fri, 01 May 2009 16:05:55 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: elladan@eskimo.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
       tytso@mit.edu, kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org
Subject: Re: [PATCH] vmscan: evict use-once pages first (v2)
References: <20090428044426.GA5035@eskimo.com>	<20090428192907.556f3a34@bree.surriel.com>	<1240987349.4512.18.camel@laptop>	<20090429114708.66114c03@cuia.bos.redhat.com>	<20090430072057.GA4663@eskimo.com>	<20090430174536.d0f438dd.akpm@linux-foundation.org>	<20090430205936.0f8b29fc@riellaptop.surriel.com>	<20090430181340.6f07421d.akpm@linux-foundation.org>	<20090430215034.4748e615@riellaptop.surriel.com>	<20090430195439.e02edc26.akpm@linux-foundation.org>	<49FB01C1.6050204@redhat.com> <20090501123541.7983a8ae.akpm@linux-foundation.org>
In-Reply-To: <20090501123541.7983a8ae.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 01 May 2009 10:05:53 -0400
> Rik van Riel <riel@redhat.com> wrote:

>> This means we need to provide our working set protection
>> on a per-list basis, by tweaking the scan rate or avoiding
>> scanning of the active file list alltogether under certain
>> conditions.
>>
>> As a side effect, this will help protect frequently accessed
>> file pages (good for ftp and nfs servers), indirect blocks,
>> inode buffers and other frequently used metadata.
> 
> Yeah, but that's all internal-implementation-of-the-day details.  It
> just doesn't matter how the sausages are made.  What we have learned is
> that the policy of retaining mapped pages over unmapped pages, *all
> other things being equal* leads to a more pleasing system.

Well, retaining mapped pages is one of the implementations
that lead to a more pleasing system.

I suspect that a fully scan resistant active file list will
show the same behaviour, as well as a few other desired
behaviours that come in very handy in various server loads.

Are you open to evaluating other methods that could lead, on
desktop systems, to a behaviour similar to the one achieved
by the preserve-mapped-pages mechanism?

-- 
All rights reversed.
