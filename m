Return-Path: <linux-kernel-owner+w=401wt.eu-S1759527AbYGPJIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759527AbYGPJIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 05:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbYGPJIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 05:08:20 -0400
Received: from smtp19.orange.fr ([80.12.242.18]:64514 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbYGPJIT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 05:08:19 -0400
X-ME-UUID: 20080716090816690.A86FB1C0008C@mwinf1921.orange.fr
Message-ID: <487DBA74.3090800@cosmosbay.com>
Date: Wed, 16 Jul 2008 11:08:04 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Ian Jeffray <ian@jeffray.co.uk>
Cc: linux-kernel@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>,
       jacliburn@bellsouth.net, csnook@redhat.com, jeff@garzik.org
Subject: Re: sendfile() broken with 2.6.26 + Apache 2 ?
References: <487CD7A7.2080800@jeffray.co.uk> <487D893A.5080207@cosmosbay.com> <487DA388.3030104@jeffray.co.uk>
In-Reply-To: <487DA388.3030104@jeffray.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Jeffray a écrit :
> Hi Eric,
> 
> Thanks for directing me to a better list.
> 
> Further responses below:
> 
> Eric Dumazet wrote:
>> CC to netdev where this report might find better answers
>>
>> Ian Jeffray a écrit :
>>> All,
>>>
>>> I moved from kernel 2.6.25.4 to 2.6.26 yesterday and observed that
>>> large files sent via Apache2 are partially corrupt.
>>>
>>> This appears to be linked to sendfile() -- disabling the use of
>>> sendfile in the apache config (EnableSendfile Off) allows it to
>>> function as normal.
>>>
>>> My system is a simple Core2Duo running Debian lenny/sid; nothing
>>> special, and I have never observed problems like this before.
>>>
>>> The problem feels certainly related to sendfile() since the data
>>> reads correctly from disc in other programs, and via CIFS etc.
>>>
>>> The corruption happens part-way in to the file... I've no exact
>>> figure but it would seem like maybe 32KB -- I'm seeing broken
>>> PNGs served from Apache, where the top few dozen lines decode
>>> correctly, and the rest is garbage.
>>>
>>> I've made basically no configuration changes between 2.6.25.4 and
>>> 2.6.26 and have explicitly tried both enabling and disabling the
>>> new PAT support to no effect.
>>>
>>> This is completely repeatable and reproducible.
>>>
>>> Is anyone else seeing this broken behaviour?
>>>
>>
>>
>> What kind of network adapter are you using ? (lspci | grep -i ether)
> 
> 02:00.0 Ethernet controller: Attansic Technology Corp. L1 Gigabit 
> Ethernet Adapter (rev b0)
> 
> 
>> If you disable TCP segmentation offload on this NIC (ethtool -K eth0 
>> tso off) , is this problem still present ?
> 
> Wow.  That 'solves' the problem!  Great.
> 
> Does this therefore point to an attansic driver issue?
>


Yes, maybe related to commit 9d90fb1ac9d97da86e24d9ea947bf2a2f333829a 

In this patch, Jay Cliburn enabled TSO by default for atl1 driver.

This might be a driver problem, or a generic sendfile() problem, I dont know...




