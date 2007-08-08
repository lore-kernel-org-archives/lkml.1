Return-Path: <linux-kernel-owner+w=401wt.eu-S935180AbXHHPTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935180AbXHHPTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 11:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbXHHPTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 11:19:25 -0400
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:45157 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754670AbXHHPTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 11:19:24 -0400
Message-ID: <46B9DEFA.1070300@lwfinger.net>
Date: Wed, 08 Aug 2007 10:19:22 -0500
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Cornelia Huck <cornelia.huck@de.ibm.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: Error message from device_rename in drivers/base/core.c
References: <46B943D3.9020207@lwfinger.net>	 <20070807.213724.27783161.davem@davemloft.net>	 <20070808113359.71e77f49@gondolin.boeblingen.de.ibm.com>	 <46B9B5C6.2070100@lwfinger.net>	 <3ae72650708080646k4279e48boc3a77d6454c8d72d@mail.gmail.com>	 <46B9CC44.8000207@lwfinger.net> <1186582491.2573.17.camel@lov.localdomain>
In-Reply-To: <1186582491.2573.17.camel@lov.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Wed, 2007-08-08 at 08:59 -0500, Larry Finger wrote:
>> Kay Sievers wrote:
>>> On 8/8/07, Larry Finger <larry.finger@lwfinger.net> wrote:
>>>> I agree with you, but you and David can fight it out. While finding out where to ask/complain about
>>>> udev, I had a private communication with GregKH. He thinks that a patch to fix this has already been
>>>> pushed through Linus. As Linville's wireless-dev tree is a little behind, I'm waiting to see if it
>>>> gets fixed here by 2.6.23-rc3. If not, I'll talk to the udev/hotplug folks.
>>> Hmm, I can not immediately see how udev could request the renaming to
>>> the same name:
>>>
>>>   /* look if we want to change the name of the netif */
>>>   if (strcmp(udev->name, udev->dev->kernel) != 0) {
>>>     ...
>>>     retval = rename_netif(udev);
>>>     ...
>>>   }
>>>
>>> What udev version is it and which distro and version?
>> My distro is openSUSE 10.2, which is fully patched/updated. According to YaST, I'm using version 
>> 103-12 x86_64. My kernel is 2.6.23-rc2 from John Linville's git tree - I run bcm43xx-mac80211.
> 
> Oh, that's likely a bug in the SUSE versions of the persistent net
> interface rules. It is calling ifrename when it needs to swap interface
> names (temp rename to free the target name), that logic which may have
> that bug.
> For the next SUSE release, it is replaced by the (now available)
> upstream stuff from the udev tree, which most distros use now, and which
> should not have that problem.

Thanks for the explanation. I'll ignore the message - it doesn't cause any problems anyway, and I'll 
expect it to go away when openSUSE 10.3 comes out in October. I think I'll post a bug report with 
SUSE just to make sure it gets fixed.

Larry
