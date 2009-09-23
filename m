Return-Path: <linux-kernel-owner+w=401wt.eu-S1752260AbZIWPOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbZIWPOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 11:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbZIWPOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 11:14:06 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:58968 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbZIWPOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 11:14:05 -0400
Message-ID: <4ABA3B0A.5010403@s5r6.in-berlin.de>
Date: Wed, 23 Sep 2009 17:13:14 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.22) Gecko/20090605 SeaMonkey/1.1.17
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Eric B Munson <ebmunson@us.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Dave Airlie <airlied@linux.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: v2.6.31-7381-g7fa0772: new build warnings: kmemcheck, 	__deprecated,
 hugetlb, radeon
References: <4AB8FC88.8020608@s5r6.in-berlin.de>	 <20090923091958.6a0f9d58@hyperion.delvare> <84144f020909230021h76400174q4bb6c9bcd39d576b@mail.gmail.com>
In-Reply-To: <84144f020909230021h76400174q4bb6c9bcd39d576b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On Wed, Sep 23, 2009 at 10:19 AM, Jean Delvare <khali@linux-fr.org> wrote:
[...]
>> --- linux-2.6.32-pre.orig/include/linux/kmemcheck.h     2009-09-23 08:19:34.000000000 +0200
>> +++ linux-2.6.32-pre/include/linux/kmemcheck.h  2009-09-23 09:05:30.000000000 +0200
>> @@ -145,10 +145,12 @@ static inline bool kmemcheck_is_obj_init
>>
>>  #define kmemcheck_annotate_bitfield(ptr, name)                         \
>>        do {                                                            \
>> +               int _n;                                                 \
>> +                                                                       \
>>                if (!ptr)                                               \
>>                        break;                                          \
>>                                                                        \
>> -               int _n = (long) &((ptr)->name##_end)                    \
>> +               _n = (long) &((ptr)->name##_end)                        \
>>                        - (long) &((ptr)->name##_begin);                \
>>                BUILD_BUG_ON(_n < 0);                                   \
>>                                                                        \
> 
> Oh, I was looking at an old version. The fix looks good to me, thanks Jean!
> 
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

Things have been set into motion already, see akpm's comment to thread
"[PATCH] kmemcheck: clean up kmemcheck_annotate_bitfield",
http://lkml.org/lkml/2009/9/22/585
-- 
Stefan Richter
-=====-==--= =--= =-===
http://arcgraph.de/sr/
