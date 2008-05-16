Return-Path: <linux-kernel-owner+w=401wt.eu-S1755026AbYEPGnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbYEPGnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 02:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbYEPGnC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 02:43:02 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:28674 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbYEPGnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 02:43:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=N4Q0V50z1lk7UJN8nwv+NkvWKyVnfyIcQXbGw8DZuGEcfHW4AaoJNelb6ZSu3Ixq1Ozad5dIP+FSNE+9q+gEn6JHsp1aT0f1m1dRS/nI0bCeWvDpxzR5Yxrnt0EcDmDNMHd1YLWgwvzSqqUgC/m2BS8oC8puk8YI2STyXS766Uo=
Message-ID: <28c262360805152342r57851584y888c1a4d08820eb2@mail.gmail.com>
Date: Fri, 16 May 2008 15:42:59 +0900
From: "MinChan Kim" <minchan.kim@gmail.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [PATCH -mm 09/15] add some sanity checks to get_scan_ratio
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20080515091230.6718cdb8@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080428181835.502876582@redhat.com>
	 <20080428181852.961869151@redhat.com>
	 <28c262360805142334y4740530co36ecd5c44752f1@mail.gmail.com>
	 <20080515091230.6718cdb8@bree.surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 10:12 PM, Rik van Riel <riel@redhat.com> wrote:
> On Thu, 15 May 2008 15:34:51 +0900
> "MinChan Kim" <minchan.kim@gmail.com> wrote:
>
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -1375,8 +1375,7 @@ static unsigned long shrink_zone(int priority, struct zon
>>          * rebalance the anon lru active/inactive ratio.
>>          */
>>         if (scan_global_lru(sc) && inactive_anon_low(zone))
>> -               shrink_list(NR_ACTIVE_ANON, SWAP_CLUSTER_MAX, zone, sc,
>> -                                                               priority);
>> +               shrink_inactive_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
>>
>>         throttle_vm_writeout(sc->gfp_mask);
>>         return nr_reclaimed;
>
> shrink_active_list, but yes, that is the idea.

But you used argument with NR_ACTIVE_ANON during call shrink_list.
I think It is not your intention.
So, you have to change LRU_ACTIVE_ANON or call shrink_active_list directly.




-- 
Kinds regards,
MinChan Kim
