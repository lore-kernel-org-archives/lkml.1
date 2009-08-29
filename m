Return-Path: <linux-kernel-owner+w=401wt.eu-S1751633AbZH2Pcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbZH2Pcg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 11:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbZH2Pcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 11:32:36 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:43459 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbZH2Pcf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 11:32:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=O9VYPx4Fb/n3r0QdA/9nn2uelvQnQ7N1kHYE3vmAREnDBn52M3cn063ULxzmCgtvl8
         1F4s66iU5VuG+SYwbKXYmky0FVliH8ETipeB+batJI3PdHf3vAH6FAnrGdNmVG1Z0Fen
         dU1EIHXh3X6m+3mbjhruqAiv9Dwf3MxSWAroI=
MIME-Version: 1.0
In-Reply-To: <20090829122217.GA17448@cmpxchg.org>
References: <Pine.LNX.4.64.0908282034240.19475@sister.anvils>
	 <2f11576a0908290300h155596e1y730c355ade7a671e@mail.gmail.com>
	 <20090829122217.GA17448@cmpxchg.org>
Date: Sun, 30 Aug 2009 00:32:36 +0900
X-Google-Sender-Auth: a43d57ccbe04d845
Message-ID: <2f11576a0908290832l7ec0c88dl14431e8a2e1d1189@mail.gmail.com>
Subject: Re: [PATCH mmotm] vmscan move pgdeactivate modification to 
	shrink_active_list fix
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/29 Johannes Weiner <hannes@cmpxchg.org>:
> On Sat, Aug 29, 2009 at 07:00:47PM +0900, KOSAKI Motohiro wrote:
>> Hi Hugh
>>
>> 2009/8/29 Hugh Dickins <hugh.dickins@tiscali.co.uk>:
>> > mmotm 2009-08-27-16-51 lets the OOM killer loose on my loads even
>> > quicker than last time: one bug fixed but another bug introduced.
>> > vmscan-move-pgdeactivate-modification-to-shrink_active_list.patch
>> > forgot to add NR_LRU_BASE to lru index to make zone_page_state index.
>> >
>> > Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
>>
>> Can I use your test case?
>> Currently LRU_BASE is 0. it mean
>>
>> LRU_BASE == NR_INACTIVE_ANON == 0
>> LRU_ACTIVE == NR_ACTIVE_ANON == 1
>
> The zone counters are
>
>        NR_FREE_PAGES = 0
>        NR_INACTIVE_ANON = NR_LRU_BASE = 1
>        NR_ACTIVE_ANON = 2
>        ...,
>
> and NR_LRU_BASE is the offset of the LRU items within the zone stat
> items.  You missed this offset, so accounting to LRU_BASE + 0 *
> LRU_FILE actually accounts to NR_FREE_PAGES, not to NR_INACTIVE_ANON.

/me slapt self. thank you correct me ;)


> I get the feeling we should make this thing more robust...

I agree your perfectly.
