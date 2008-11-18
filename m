Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbYKRRgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbYKRRgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 12:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbYKRRf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 12:35:58 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:29079 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbYKRRf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 12:35:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=vtijNZcALKe7UtFtq9wgMNhTcUqX3AP0DRnxsfFiLAJ0S6W5WE7oTDuWABxwGV0ubd
         14Yh7ABc9Vr77iv/uqNeSCpCcxnCYapTkAeZRWyXE7RotKbiOaXuwGJl2BrAqnSwiRST
         +7bFy9teL5GLxjOiNUdVAFMTF2fpMXorvP+GA=
Message-ID: <4922FD09.2070007@tuffmail.co.uk>
Date: Tue, 18 Nov 2008 17:36:09 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Jay Cliburn <jcliburn@gmail.com>
CC: csnook@redhat.com, atl1-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: [atl1-devel] atl2: don't mess up irq on suspend/resume (probably
 msi only)
References: <49201401.1060600@tuffmail.co.uk>	<4921E574.3090602@tuffmail.co.uk> <20081117181336.1a270561@osprey.hogchain.net> <4922D195.9010505@tuffmail.co.uk>
In-Reply-To: <4922D195.9010505@tuffmail.co.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> Jay Cliburn wrote:
>   
>> [adding netdev to cc list]
>>
>> On Mon, 17 Nov 2008 21:43:16 +0000
>> Alan Jenkins <alan-jenkins@tuffmail.co.uk> wrote:
>>
>>
>>   
>>     
>>> Don't listen to me.  The problem went away because when I was testing
>>> my patch, I plugged the ethernet in and actually used it.  My patch
>>> doesn't seem to fix anything.
>>>
>>> So I now have the steps to reproduce this warning: remove the ethernet
>>> cable and suspend.
>>>
>>> Also, I was speaking rubbish because the warning isn't on the resume
>>> path.  It seems to be when network-manager re-opens the device on
>>> resume.
>>>
>>> I'll have another look for possible culprits.  Hints appreciated :).
>>>     
>>>       
>> Does this help?
>>   
>>     
>
> Ah! Yes, that fixes it, thanks.
>   

Just noticed another problem. If I suspend with the cable plugged in, I 
get a warning message about freeing the IRQ:

[ 331.023417] atl2 0000:03:00.0: restoring config space at offset 0x1 
(was 0x100006, writing 0x100406)
[ 331.023453] atl2 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 331.023462] atl2 0000:03:00.0: setting latency timer to 64
[ 331.043449] ath5k_pci 0000:01:00.0: restoring config space at offset 
0xf (was 0x100, writing 0x10a)
...
[ 332.681591] Restarting tasks ... done.
[ 333.617398] hpet1: lost 2 rtc interrupts
[ 334.016700] Trying to free already-free IRQ 17
[ 334.057257] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 334.082570] atl2 0000:03:00.0: irq 44 for MSI/MSI-X

