Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbZBJUlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbZBJUlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 15:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277AbZBJUlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 15:41:23 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:45554 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbZBJUlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 15:41:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=n/RhzoSenatW9T4PETL6d/KsTo2QohpNpoXjQ5wSsGG0WIkpeGwWHWsR4dA4pTuyIV
         7LCeVBXMFmuPaw1fCupSVqNSf5UjSiZfmlBZNDD92RLtX2yH/5yYTBnpY4Sl9VYNoWgt
         z7aQeBMxpFZ7dEruMn4SY+5H5ngsSWZ9ir06s=
MIME-Version: 1.0
In-Reply-To: <20090210162052.GB2371@cmpxchg.org>
References: <28c262360902100440v765d3f7bnd56cc4b5510349c0@mail.gmail.com>
	 <20090210215718.700D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20090210215811.7010.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20090210162052.GB2371@cmpxchg.org>
Date: Wed, 11 Feb 2009 05:41:21 +0900
X-Google-Sender-Auth: 16240b18d8c10d87
Message-ID: <2f11576a0902101241j5a006e09w46ecdbdb9c77e081@mail.gmail.com>
Subject: Re: [PATCH] shrink_all_memory() use sc.nr_reclaimed
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: MinChan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       William Lee Irwin III <wli@movementarian.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  {
>>       struct zone *zone;
>> -     unsigned long nr_to_scan, ret = 0;
>> +     unsigned long nr_to_scan;
>>       enum lru_list l;
>
> Basing it on swsusp-clean-up-shrink_all_zones.patch probably makes it
> easier for Andrew to pick it up.

ok, thanks.

>>                       reclaim_state.reclaimed_slab = 0;
>> -                     shrink_slab(nr_pages, sc.gfp_mask, global_lru_pages());
>> -                     ret += reclaim_state.reclaimed_slab;
>> -             } while (ret < nr_pages && reclaim_state.reclaimed_slab > 0);
>> +                     shrink_slab(nr_pages, sc.gfp_mask,
>> +                                 global_lru_pages());
>> +                     sc.nr_reclaimed += reclaim_state.reclaimed_slab;
>> +             } while (sc.nr_reclaimed < nr_pages &&
>> +                      reclaim_state.reclaimed_slab > 0);
>
> :(
>
> Is this really an improvement?  `ret' is better to read than
> `sc.nr_reclaimed'.

I know it's debetable thing.
but I still think code consistency is important than variable name preference.
