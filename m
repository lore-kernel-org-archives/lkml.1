Return-Path: <linux-kernel-owner+w=401wt.eu-S1756716AbXHRRNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbXHRRNb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 13:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbXHRRM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 13:12:59 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:41410 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbXHRRM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 13:12:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=fDzjg/gRGY+Vc7gkJU5Si3VTGdG/ibOfbbEoSuheTsk0hWt7PMd1DPIJ09V1xKd6KeTLg0NP8bSTKmJvOMAUcNJXuN4x8QcT7OIgsqSgJiVvi+7YwSqOlG+BOlLz5UmH6pZh00iD8KGXUVM9xlv2GAsiuOc/jg9wq+Ft5znK+yE=
Message-ID: <46C728CB.6060102@gmail.com>
Date: Sat, 18 Aug 2007 19:13:47 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
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
References: <737828602404912540@wsc.cz>	<428714662539710215@wsc.cz> <20070818094602.0ea69c27.randy.dunlap@oracle.com>
In-Reply-To: <20070818094602.0ea69c27.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap napsal(a):
> On Sat, 18 Aug 2007 11:44:12 +0200 (CEST) Jiri Slaby wrote:
> 
>> define global BIT macro
>>
>> move all local BIT defines to the new globally define macro.
>>
>> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>>
>> ---
>>
>>  include/linux/bitops.h                      |    1 +
>>  include/video/sstfb.h                       |    1 -
>>  include/video/tdfx.h                        |    2 --
>>  net/mac80211/ieee80211_i.h                  |    2 --
>>  18 files changed, 1 insertions(+), 37 deletions(-)
>>
>> diff --git a/include/linux/bitops.h b/include/linux/bitops.h
>> index 3255b06..a57b81f 100644
>> --- a/include/linux/bitops.h
>> +++ b/include/linux/bitops.h
>> @@ -3,6 +3,7 @@
>>  #include <asm/types.h>
>>  
>>  #ifdef	__KERNEL__
>> +#define BIT(nr)			(1UL << (nr))
>>  #define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
>>  #define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
>>  #define BITS_TO_TYPE(nr, t)	(((nr)+(t)-1)/(t))
> 
> 
> So users of the BIT() macro in include/linux/input.h can be
> changed to use the global BIT_MASK() macro...
> and the former can be removed.

I'm afraid I don't understand you. Maybe, you are writing about changes done in
patch no. 7 [1], which didn't go through to the lkml?

[1]
http://www.fi.muni.cz/~xslaby/sklad/07-get-rid-of-input-bit-duplicate-defines.patch

thanks,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
