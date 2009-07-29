Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbZG2QUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbZG2QUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 12:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755439AbZG2QUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 12:20:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35981 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452AbZG2QUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 12:20:10 -0400
Message-ID: <4A707696.6080301@redhat.com>
Date: Wed, 29 Jul 2009 12:19:34 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH -mm] throttle direct reclaim when too many pages are	isolated
 already (v3)
References: <20090715223854.7548740a@bree.surriel.com> <20090715194820.237a4d77.akpm@linux-foundation.org> <4A5E9A33.3030704@redhat.com> <20090715202114.789d36f7.akpm@linux-foundation.org> <4A5E9E4E.5000308@redhat.com> <20090715203854.336de2d5.akpm@linux-foundation.org> <20090715235318.6d2f5247@bree.surriel.com> <20090729150443.GB1534@ucw.cz>
In-Reply-To: <20090729150443.GB1534@ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Wed 2009-07-15 23:53:18, Rik van Riel wrote:
>> When way too many processes go into direct reclaim, it is possible
>> for all of the pages to be taken off the LRU.  One result of this
>> is that the next process in the page reclaim code thinks there are
>> no reclaimable pages left and triggers an out of memory kill.
>>
>> One solution to this problem is to never let so many processes into
>> the page reclaim path that the entire LRU is emptied.  Limiting the
>> system to only having half of each inactive list isolated for
>> reclaim should be safe.
> 
> Is this still racy? Like on 100cpu machine, with LRU size of 50...?

If a 100 CPU system gets down to just 100 reclaimable pages,
getting the OOM killer to trigger sounds desirable.

The goal of this patch is to avoid _false_ OOM kills, when
the system still has enough reclaimable memory available.

-- 
All rights reversed.
