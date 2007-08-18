Return-Path: <linux-kernel-owner+w=401wt.eu-S1757490AbXHRSLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbXHRSLI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 14:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbXHRSKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 14:10:54 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:12568 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477AbXHRSKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 14:10:52 -0400
Message-ID: <46C7373D.90005@oracle.com>
Date: Sat, 18 Aug 2007 11:15:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       source@mvista.com, dougthompson@xmission.com,
       bluesmoke-devel@lists.sourceforge.net, dtor@mail.ru,
       linux-input@atrey.karlin.mff.cuni.cz, netdev@vger.kernel.org,
       James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org,
       gtolstolytkin@ru.mvista.com, vitalywool@gmail.com, dsaxena@plexity.net,
       ralf@linux-mips.org, linux-mips@linux-mips.org, mchehab@infradead.org,
       video4linux-list@redhat.com, jbenc@suse.cz, flamingice@sourmilk.net,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH 8/9] define global BIT macro
References: <737828602404912540@wsc.cz>	<428714662539710215@wsc.cz> <20070818094602.0ea69c27.randy.dunlap@oracle.com> <46C728CB.6060102@gmail.com>
In-Reply-To: <46C728CB.6060102@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> Randy Dunlap napsal(a):
>> On Sat, 18 Aug 2007 11:44:12 +0200 (CEST) Jiri Slaby wrote:
>>
>>> define global BIT macro
>>>
>>> move all local BIT defines to the new globally define macro.
>>>
>>> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>>>
>>> ---
>>>
>>>  include/linux/bitops.h                      |    1 +
>>>  include/video/sstfb.h                       |    1 -
>>>  include/video/tdfx.h                        |    2 --
>>>  net/mac80211/ieee80211_i.h                  |    2 --
>>>  18 files changed, 1 insertions(+), 37 deletions(-)
>>>
>>> diff --git a/include/linux/bitops.h b/include/linux/bitops.h
>>> index 3255b06..a57b81f 100644
>>> --- a/include/linux/bitops.h
>>> +++ b/include/linux/bitops.h
>>> @@ -3,6 +3,7 @@
>>>  #include <asm/types.h>
>>>  
>>>  #ifdef	__KERNEL__
>>> +#define BIT(nr)			(1UL << (nr))
>>>  #define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
>>>  #define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
>>>  #define BITS_TO_TYPE(nr, t)	(((nr)+(t)-1)/(t))
>>
>> So users of the BIT() macro in include/linux/input.h can be
>> changed to use the global BIT_MASK() macro...
>> and the former can be removed.
> 
> I'm afraid I don't understand you. Maybe, you are writing about changes done in
> patch no. 7 [1], which didn't go through to the lkml?
> 
> [1]
> http://www.fi.muni.cz/~xslaby/sklad/07-get-rid-of-input-bit-duplicate-defines.patch

Exactly.  Thanks.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
