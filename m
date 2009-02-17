Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbZBQVWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbZBQVWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 16:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbZBQVWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 16:22:00 -0500
Received: from mbox2.netikka.net ([213.250.81.203]:52864 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbZBQVWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 16:22:00 -0500
X-Greylist: delayed 1383 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Feb 2009 16:21:59 EST
Message-ID: <499B2497.50807@mandriva.org>
Date: Tue, 17 Feb 2009 22:56:55 +0200
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Brian Haley <brian.haley@hp.com>
CC: Andrey Borzenkov <arvidjaar@mail.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       netdev@vger.kernel.org, bonding-devel@lists.sourceforge.net,
       =?ISO-8859-1?Q?=22J=2EA=2E_Magall=F3n=22?= <jamagallon@ono.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29 regression? Bonding tied to IPV6 in 29-rc5
References: <alpine.LFD.2.00.0902131413120.3179@localhost.localdomain> <20090217095232.5da06b9f@werewolf.home> <200902172001.41804.arvidjaar@mail.ru> <200902172117.22671.arvidjaar@mail.ru> <499B19AF.1000003@hp.com>
In-Reply-To: <499B19AF.1000003@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Haley skrev:
> Andrey Borzenkov wrote:
>> On 17 of February 2009 20:01:38 Andrey Borzenkov wrote:
>>> Forward to bonding and netdev
>>>
>>> On 17 of February 2009 11:52:32 J.A. Magallón wrote:
>>>> Hi all...
>>>>
>>>> Don't know if this is specific for -rc5, I have jumped from 28.4 to
>>>> 29-rc5. In this latest kernel, I can not install 'bonding' module
>>>> if 'ipv6' is disabled to load via modprobe.conf:
>>>>
>>>> install ipv6 /bin/true
>>>>
>>>> Trying bonding gives this dmesg:
>>>>
>>>> bonding: Unknown symbol ndisc_build_skb
>>>> bonding: Unknown symbol in6_dev_finish_destroy
>>>> bonding: Unknown symbol ndisc_send_skb
>>>> bonding: Unknown symbol unregister_inet6addr_notifier
>>>> bonding: Unknown symbol register_inet6addr_notifier
>>>>
>>>> Commenting the line in modprobe.conf makes things smooth again.
>>>> We can not disable ipv6 anymore ?
>>> If IPv6 is disable in kernel config bonding loads. But I think it is
>>> regression, it should be possible to disable IPv6 if not required.
>>
>> This hard dependency was apparently introduced by this commit:
>>
>> commit 305d552accae6afb859c493ebc7d98ca3371dae2
>> Author: Brian Haley <brian.haley@hp.com>
>> Date:   Tue Nov 4 17:51:14 2008 -0800
>>
>>     bonding: send IPv6 neighbor advertisement on failover
> 
> I initially had bonding IPv6 support as a Kconfig option, but it was 
> decided it would be cleaner if it just got built-in whenever CONFIG_IPV6 
> was set like SCTP, with the assumption you might want it.
> 
> Is it a common configuration to not allow a module to load like you're 
> doing in modprobe.conf?  I don't know how hard it would be to rip this 

Yep.

> out into it's own bonding_ipv6.ko module, simply turning-off CONFIG_IPV6 
> seems better.

That's not an option for distro kernels ...

--
Thomas
