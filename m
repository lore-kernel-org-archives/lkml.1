Return-Path: <linux-kernel-owner+w=401wt.eu-S1764773AbXHHMXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764773AbXHHMXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 08:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbXHHMXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 08:23:37 -0400
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:33898 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751837AbXHHMXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 08:23:36 -0400
Message-ID: <46B9B5C6.2070100@lwfinger.net>
Date: Wed, 08 Aug 2007 07:23:34 -0500
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: Error message from device_rename in drivers/base/core.c
References: <46B943D3.9020207@lwfinger.net>	<20070807.213724.27783161.davem@davemloft.net> <20070808113359.71e77f49@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070808113359.71e77f49@gondolin.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Tue, 07 Aug 2007 21:37:24 -0700 (PDT),
> David Miller <davem@davemloft.net> wrote:
> 
>> I think this check belongs in udev not in the kernel.  Thankfully
>> this message at least tells us it is happening, please don't
>> remove it.
> 
> Hm, device_rename() could alternatively just return success if
> dev->bus_id and new_name are the same.

That is what my proposed patch did. One could argue that the test should come before the failure, 
not after, but the effect is the same.

>> I'm pretty sure it's UDEV doing this, and it should not try to rename
>> a netdevice to what it already is named.
> 
> But it shouldn't cause an error either :)

I agree with you, but you and David can fight it out. While finding out where to ask/complain about 
udev, I had a private communication with GregKH. He thinks that a patch to fix this has already been 
pushed through Linus. As Linville's wireless-dev tree is a little behind, I'm waiting to see if it 
gets fixed here by 2.6.23-rc3. If not, I'll talk to the udev/hotplug folks.
