Return-Path: <linux-kernel-owner+w=401wt.eu-S1755037AbZCEFwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbZCEFwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 00:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbZCEFwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 00:52:03 -0500
Received: from stinky.trash.net ([213.144.137.162]:58170 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbZCEFwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 00:52:00 -0500
Message-ID: <49AF687D.9080708@trash.net>
Date: Thu, 05 Mar 2009 06:51:57 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Bart Trojanowski <bart@jukie.net>
CC: David Miller <davem@davemloft.net>, greearb@candelatech.com,
       shemminger@vyatta.com, dada1@cosmosbay.com, frank.blaschka@de.ibm.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.29-rc* QinQ vlan trunking regression
References: <49AE509B.3000305@trash.net> <20090304.025914.149394356.davem@davemloft.net> <49AE69DD.80802@trash.net> <20090304.195328.106253933.davem@davemloft.net> <20090305045442.GF5959@jukie.net> <20090305045925.GG5959@jukie.net>
In-Reply-To: <20090305045925.GG5959@jukie.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Trojanowski wrote:
>>> As analyzed by Patrick McHardy, vlan needs to reset it's
>>> netdev_ops pointer in it's ->init() function but this
>>> leaves the compat method pointers stale.
>>>
>>> Add a netdev_resync_ops() and call it from the vlan code.
>> <snip>
>>>  include/linux/netdevice.h |    1 +
>>>  net/8021q/vlan_dev.c      |    1 +
>>>  net/core/dev.c            |   54 +++++++++++++++++++++++++++-----------------
>>>  3 files changed, 35 insertions(+), 21 deletions(-)
>> I tried this patch onto v2.6.29-rc7-3-g559595a, but I still get a crash.
>> I assume that this worked for you, so I am not putting much faith in my
>> results at this late hour.  I'll confirm tomorrow morning that it's not
>> something else.
> 
> ... if you're interested, here is the Oops.  And like I said, I'll
> retest tomorrow.

Thanks, I'll try to reproduce it here.
