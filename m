Return-Path: <linux-kernel-owner+w=401wt.eu-S1753412AbZHFMjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbZHFMjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 08:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbZHFMjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 08:39:10 -0400
Received: from main.gmane.org ([80.91.229.2]:40587 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbZHFMjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 08:39:09 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Raja R Harinath <harinath@hurrynot.org>
Subject: Re: [PATCH] kmemcheck: fix sparse warning
Date: Thu, 06 Aug 2009 18:06:41 +0530
Message-ID: <87r5vpyv8m.fsf@hariville.hurrynot.org>
References: <1246873983.20908.0.camel@johannes.local>
	<1248874951.25614.0.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 59.92.172.24
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
Cancel-Lock: sha1:/jQ2TJFi0vDwve51Xjo8EzX/iJw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Johannes Berg <johannes@sipsolutions.net> writes:

>> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

I know I'm colouring the bike-shed but you can avoid the outer do-while
with:

>> --- wireless-testing.orig/include/linux/kmemcheck.h	2009-07-06 11:41:16.000000000 +0200
>> +++ wireless-testing/include/linux/kmemcheck.h	2009-07-06 11:41:30.000000000 +0200
>> @@ -137,13 +137,13 @@ static inline void kmemcheck_mark_initia
>>  	int name##_end[0];
>>  
>>  #define kmemcheck_annotate_bitfield(ptr, name)				\
>> -	do if (ptr) {							\
>> +	do { if (ptr) {							\

   +    if (ptr) {

>>  		int _n = (long) &((ptr)->name##_end)			\
>>  			- (long) &((ptr)->name##_begin);		\
>>  		BUILD_BUG_ON(_n < 0);					\
>>  									\
>>  		kmemcheck_mark_initialized(&((ptr)->name##_begin), _n);	\
>> -	} while (0)
>> +	} } while (0)

   +    } else

Of course, that tailing 'else' may be much too clever to live.  A
slightly less clever but more idiomatic approach would be to use

  +    } else do {} while (0)

but what's the point.  Oh well, ignore me :-) I'm just pained by the
'} }' due to my wierd sense of aesthetics.

- Hari

