Return-Path: <linux-kernel-owner+w=401wt.eu-S965380AbXCOMOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965380AbXCOMOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 08:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965412AbXCOMOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 08:14:21 -0400
Received: from ik-out-1112.google.com ([66.249.90.177]:24530 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965380AbXCOMOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 08:14:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=NXBdTgOPAmecavNndfyPLXIZiLyz4s9OQnkBofgNWPySA6nO525GhNYLsBCnWJ4nnsNnrhgvh47QyR0aZJPnefRKKb2Vev7caNx+CgES0M7K0cAOmQARZHgx85bOAffbsmwVr6W1M3AgcfC2iseOOiDn+EuTrWx917LwtEJUAF0=
Message-ID: <45F93888.1080207@gmail.com>
Date: Thu, 15 Mar 2007 21:14:00 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Conke Hu <conke.hu@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ahci.c: fix ati sb600 sata IRQ_TF_ERR
References: <5767b9100703140222k79dbed9dq6419b4f35d276242@mail.gmail.com>	 <45F7E7E9.6010703@gmail.com> <5767b9100703150500t1c34dfb0kc6a199b5374a8d78@mail.gmail.com>
In-Reply-To: <5767b9100703150500t1c34dfb0kc6a199b5374a8d78@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Conke Hu wrote:
>> E  Internal error: The host bus adapter experienced an internal error
>> that caused the operation to fail and may have put the host bus adapter
>> into an error state. Host software should reset the interface before
>> re-trying the operation. If the condition persists, the host bus adapter
>> may suffer from a design issue rendering it incompatible with the
>> attached device.
>>
> 
> Yes, I saw this too :) and I am contacting the hardware engineers to
> check if there is any hardware bug.
> But, even though this were a hardware bug and could be fixed, we would
> still need this patch since many SB600 boards have already come into
> the market and those ASICs can never be fixed :(

Yeap, we certainly need the workaround.  I was just having a little fun.
 :-)

>> 4381 isn't affected while 4380 is?
> 
> I never see such an ID, and plan to remove 0x4381.
> The patch which added the PCI IDs was not sent out by myself. I
> checked all SB600 boards, and not found any 0x4381 controller, only
> 0x4380 instead. In fact, SB600 RAID and Non-RAID share the same PCI
> device ID, only with class code different.

I see.

>> Anyways, Conke Hu, can you please take a look at my patch from a month
>> ago?  It's almost identical but SERR_INTERNAL is always ignored on both
>> SB600 PCI IDs, which I think is safer.  Does this fix what you're seeing?
>>
> 
> I just read your patch. Another difference is that my patch ignores
> SERR_INTERNAL only when the command is ATAPI and IRQ_TF_ERR occurs. In
> other cases, I think, we'd better not ignore the SERR_INTERNEL. Right?

Yeah, I noticed the difference.  I don't really care but I was thinking
that SERR_INTERNAL might be set in other similar situations too.  e.g.
TF error from ATA device or what not, so I thought it would be safer to
ignore the bit altogether.  You probably need to consult your hardware
people about when exactly the bit misbehaves but unless proven
otherwise, I'd prefer to always ignore the bit.  Also, please rename the
enum constant and flag name.

Thanks.

-- 
tejun
