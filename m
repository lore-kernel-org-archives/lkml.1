Return-Path: <linux-kernel-owner+w=401wt.eu-S1758196AbYENH3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196AbYENH3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 03:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbYENH33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 03:29:29 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:52637 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbYENH31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 03:29:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=VRi2n7A1P3la+tr4ahDQ/fqmsAEYF4E1RDLjckHDDmofACKTZtfcpVInJSqAmeGgy70xBeMW7p9iwsQc5foprLyLjuDDaPXd6FjKR7lQJsApXsVz/OtoBfWACHaq8qFyvnWu5CUYDjIS10gsfPydbiw2fMWrScX6U+ktFdnW7zk=
Message-ID: <482A94CE.5060705@gmail.com>
Date: Wed, 14 May 2008 16:29:18 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bruce Allen <ballen@gravity.phys.uwm.edu>
Subject: Re: libata errors with smartctl on 2.6.24, WD3200AAKS and nVidia
 AHCI
References: <200804092130.07149.tvrtko@ursulin.net> <200804150721.17337.tvrtko@ursulin.net> <482A7C2C.6040302@gmail.com> <200805140758.53407.tvrtko@ursulin.net>
In-Reply-To: <200805140758.53407.tvrtko@ursulin.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tvrtko A. Ursulin wrote:
> On Wednesday 14 May 2008 06:44:12 Tejun Heo wrote:
>> Tvrtko A. Ursulin wrote:
>>> On Tuesday 15 April 2008 04:10:57 Tejun Heo wrote:
>>>> Tvrtko A. Ursulin wrote:
>>>>> On Sunday 13 April 2008 04:11:15 Tejun Heo wrote:
>>>>>> Is auto spindown configured for the drive?
>>>>> I don't think so - it's a 3.5" drive with no special PM features - but
>>>>> how to tell?
>>>> Hmm... Can you please post the result of "smartctl --version" and
>>>> "smartctl -a > out 2>&1" and dmesg after the smartctl command?
>>> Yep, pasted and attached below. dmesg is 67k, hope list is happy with
>>> that.
>> Thanks for the data.  Nothing really stands out tho.  It looks like the
>> drive just doesn't like SMART commands 0xda and 0xd1.  0xda being a
>> mandatory non-data command, it failing due to driver problem is unlikely.
>>
>> Can you please post the result of "hdparm -I /dev/sda" and "lspci -nn"?
> 
> Of course:
> 
> root@sol:~# hdparm -I /dev/sda
> 
> /dev/sda:
> 
> ATA device, with non-removable media
>         Model Number:       WDC WD3200AAKS-00VYA0
>         Serial Number:      WD-WCARW0059893
>         Firmware Revision:  12.01B02

> 00:0e.0 SATA controller [0106]: nVidia Corporation GeForce 7100/nForce 630i [10de:07f4] (rev a2)

Hmmm.. WD3200 w/ nv ahci.  WD3200 having trouble with smart commands is 
unlikely.  Is it possible for you try different drive on the controller 
and see whether smartctl works on it?

Thanks.

-- 
tejun
