Return-Path: <linux-kernel-owner+w=401wt.eu-S1756215AbZGIK2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbZGIK2D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 06:28:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757349AbZGIK1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 06:27:54 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:64028 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833AbZGIK1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 06:27:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WP5V6iU0kN5Q5JY5WTCQjN3596+DmnDWVYErBfylBE7gQkIlHQK4nemC8k7B8klU+t
         rb3bfAXmkFgg8V/wDyoDPafGiBemSqlv15KdqvHINhcpu93bqXv9nkSOliD9SzRFQzmL
         5iw/vfrpd13xduH3yq4hNNPeROpO349lyV7+8=
MIME-Version: 1.0
In-Reply-To: <20090709161712.23B0.A69D9226@jp.fujitsu.com>
References: <alpine.DEB.1.10.0907071252060.5124@gentwo.org>
	 <20090709144938.23A8.A69D9226@jp.fujitsu.com>
	 <20090709161712.23B0.A69D9226@jp.fujitsu.com>
Date: Thu, 9 Jul 2009 19:27:52 +0900
Message-ID: <28c262360907090327w63b0cdfdn5bc2ad628239e53b@mail.gmail.com>
Subject: Re: [PATCH 5/5] add NR_ANON_PAGES to OOM log
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 9, 2009 at 4:20 PM, KOSAKI
Motohiro<kosaki.motohiro@jp.fujitsu.com> wrote:
>> > On Mon, 6 Jul 2009, Minchan Kim wrote:
>> >
>> > > Anyway, I think it's not a big cost in normal system.
>> > > So If you want to add new accounting, I don't have any objection. :)
>> >
>> > Lets keep the counters to a mininum. If we can calculate the values from
>> > something else then there is no justification for a new counter.
>> >
>> > A new counter increases the size of the per cpu structures that exist for
>> > each zone and each cpu. 1 byte gets multiplies by the number of cpus and
>> > that gets multiplied by the number of zones.
>>
>> OK. I'll implement this idea.
>
> Grr, sorry I cancel this opinion. Shem pages can't be calculated
> by minchan's formula.
>
> if those page are mlocked, the page move to unevictable lru. then
> this calculation don't account mlocked page. However mlocked tmpfs pages
> also make OOM issue.

Absolutely. You're right.
But In my opinion,  mlocked shmem pages are important ?
Now we care only number of unevictable pages but don't care what kinds
of pages there are in unevictable list.

What we need is to decode OOM more easily.
I think what kinds of pages there area unevictable lur list is not important.

-- 
Kind regards,
Minchan Kim
