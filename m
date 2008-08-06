Return-Path: <linux-kernel-owner+w=401wt.eu-S1764613AbYHFLST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764613AbYHFLST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 07:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759657AbYHFLRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 07:17:48 -0400
Received: from h155.mvista.com ([63.81.120.155]:39670 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759158AbYHFLRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 07:17:47 -0400
Message-ID: <48998852.30603@ru.mvista.com>
Date: Wed, 06 Aug 2008 15:17:38 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Robert Hancock <hancockr@shaw.ca>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: Re: Kernel Summit request for Discussion of future of ATA (libata)
 and IDE
References: <fa.OGeO7gZvBG4obEzRbVltjSebgTQ@ifi.uio.no>	<fa.KtvYE2B2yrJqUleolhtMPN9ljAQ@ifi.uio.no>	<fa.AqEKTvguYFAzDFHy/We/8MpOqmo@ifi.uio.no>	<48976168.3020804@shaw.ca>	<20080804205508.20a3f917@lxorguk.ukuu.org.uk>	<48977AE1.1070402@ru.mvista.com> <20080804224309.77ffd28e@lxorguk.ukuu.org.uk> <489786A7.8060400@ru.mvista.com> <4897883F.6020007@ru.mvista.com>
In-Reply-To: <4897883F.6020007@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>>>>>> supported. I couldn't track down where that bit was actually 
>>>>>> defined in the first place, all the way back to ATA-1 it seems to 
>>>>>> be indicated as reserved. Actually, I'm not sure why the drive 
>>>>>> cares in the first place, it would seem like a pure host 
>>>>>> controller issue..
>>>>>>             
>>>>> It goes back before IDE into the depths of the original compaq 
>>>>> spec. When
>>>>> you have a device wired basically directly to the ISA bus 
>>>>> (original IDE)
>>>>>         
>>>>    ISA has only 8/16-bit data bus, so it could not have mattered 
>>>> there...     
>>>
>>> Depends what a 32bit I/O looks like on the 16bit bus - timing wise.
>>>   
>>
>>   Two 16-bit reads at addresses 0x1x0 and 0x1x2 with the programmed 
>> recovery time, IIRC... It's just occured to me that in case of the 
>> 16-bit bus it should be how the drive treated the accesses at address 
>> 0x1x2 with IOCS16 asserted that could have mattered. If it honored 
>> them, 32-bit I/O could have worked even on a dumb ISA "controller", 
>> if not -- no way (unless you really had *something* between the ISA 
>> and the IDE cable).
>
>    Oh, -IOCS16 is driven by device, not host. I give up then. :-)
>

   OTOH, it definitely could work if the drive asserted it for the I/O 
port 0x1x2 at least for the data transfer phase (and probably even if it 
always asserted -IOCS16 for this address).
That pre-historic word indeed could have made sense then...

MBR, Sergei


