Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbYCJAvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbYCJAvK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 20:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbYCJAu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 20:50:59 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:47103 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbYCJAu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 20:50:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=GNRpzOrtFSH6d/RpwdCcz1rkDOd1Rua38YlU2WyRp/NC162550f9+2Fw9g9/XIFm0+5LLMKfapoFj1rvIq9pCQUBzv/vSaIWWiTAWe66L4N3eAxp8F3bH11vQIWP5AM+rZSopQ9qyxQuiY7a5vLE2Zv0xNBhBmvr33mz7wm29wc=
Message-ID: <47D485EC.1060103@gmail.com>
Date: Mon, 10 Mar 2008 09:50:52 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org
Subject: Re: Unknown SATA PIIX PCI device ID 0x29b6
References: <Pine.LNX.4.64.0802282306190.10087@axis700.grange> <20080228225603.2764bfd1@core> <Pine.LNX.4.64.0802290010320.10498@axis700.grange> <47CFADDF.20200@gmail.com> <Pine.LNX.4.64.0803061248070.5670@axis700.grange> <47D0C9E6.8090301@gmail.com> <Pine.LNX.4.64.0803082345000.6749@axis700.grange> <47D3723B.3040700@gmail.com> <Pine.LNX.4.64.0803092221560.7385@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0803092221560.7385@axis700.grange>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski wrote:
> On Sun, 9 Mar 2008, Tejun Heo wrote:
> 
>> Guennadi Liakhovetski wrote:
>>> On Fri, 7 Mar 2008, Tejun Heo wrote:
>>>
>>>>> Looks like almost a minute to me? On another occurence I see about 1.5 
>>>>> minutes, then "port is slow to respond, please be patient (Status 0x80)" 
>>>>> has been repeated 3 times. On cold-plug also 3 times, I think, about the 
>>>>> same time then (time is not updated in the log).
>>>> I see.  Does the attached patch make any difference?
>>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>>> index 4fbcce7..abebdcc 100644
>>> --- a/drivers/ata/libata-core.c
>>> +++ b/drivers/ata/libata-core.c
>>> @@ -6712,6 +6712,7 @@ int sata_link_init_spd(struct ata_link *link)
>>>  	spd = (scontrol >> 4) & 0xf;
>>>  	if (spd)
>>>  		link->hw_sata_spd_limit &= (1 << spd) - 1;
>>> +	link->hw_sata_spd_limit = 1;
>>>  
>>>  	ata_force_spd_limit(link);
>>>  
>>> Hm, this would force 1.5Gbps on all ports and devices, right? Cannot I 
>>> just boot with "libata.force=4:1.5Gbps"?
>> Yeap, you can do that.  Wasn't sure you were using .25-rc or .24.
> 
> Yctually it was 2.6.24 before, rebuilt 2.6.25-rc4, booted as above, it did 
> say:
> 
> ata4: FORCE: PHY spd limit set to 1.5Gbps
> 
> but hot-plugging the drive still took 50 seconds to recover.

How about cold plugging?

-- 
tejun
