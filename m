Return-Path: <linux-kernel-owner+w=401wt.eu-S1753245AbYKZJCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbYKZJCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 04:02:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbYKZJBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 04:01:52 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:40644 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbYKZJBv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 04:01:51 -0500
Message-ID: <492D107B.1060303@cosmosbay.com>
Date: Wed, 26 Nov 2008 10:01:47 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: ut <mchan@broadcom.com>
CC: linux kernel <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [BUG] linux-2.6.28-rc3 regression: IRQ smp_affinities not respected
References: <C27F8246C663564A84BB7AB343977242151F4B18B5@IRVEXCHCCR01.corp.ad.broadcom.com> <491154C8.3040401@cosmosbay.com>
In-Reply-To: <491154C8.3040401@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 26 Nov 2008 10:01:48 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> Michael Chan a écrit :
>> I believe this may be the patch that broke it:
>>
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ce6fce4295ba727b36fdc73040e444bd1aae64cd 
>>
>>
>> I don't remember all the details, but the Broadcom 5708 chip is
>> affected because it does not support MSI per-vector masking.
>>
>> One way to get around is to disable MSI with bnx2 parameter
>> disable_msi=1.
>>

> 
> I tried this MSI disabling and yes, it now works.
> 
> 16:      42726        128        105        106         89         
> 89        145        152   IO-APIC-fasteoi   uhci_hcd:usb1, eth0, eth1
> 

I believe the bnx2 driver doesnt work at all if !disable_msi (default setting)

Doing a "echo 0 >/sys/devices/system/cpu/cpu1/online" just freeze network

No messages logged

If loaded with disable_msi=1, the cpu unplug works as expected.

Thats a pretty serious issue.


