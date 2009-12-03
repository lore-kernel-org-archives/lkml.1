Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbZLCVnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbZLCVnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 16:43:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbZLCVnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 16:43:15 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:55843 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbZLCVnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 16:43:14 -0500
Message-ID: <4B183059.4070109@nortel.com>
Date: Thu, 03 Dec 2009 15:40:41 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: netdev@vger.kernel.org, Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: seeing strange values for tcp sk_rmem_alloc
References: <4B15416A.2060202@nortel.com> <4B154B29.1030807@cosmosbay.com> <4B155252.1040604@nortel.com> <4B1557CC.4060503@gmail.com> <4B17ED8D.7050409@nortel.com> <4B17EF8E.60704@gmail.com>
In-Reply-To: <4B17EF8E.60704@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Dec 2009 21:43:17.0276 (UTC) FILETIME=[9FA8A5C0:01CA7461]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2009 11:04 AM, Eric Dumazet wrote:
> Chris Friesen a écrit :

>> Ah, that makes a difference.  But the results (see below) still
>> look odd.  For this test, /proc/sys/net/core/rmem_default is
>> 118784.  For some reason sk_rmem_alloc gets bumped by 16KB when I
>> only send 2KB of data, and it drops back down again every 6
>> packets.

> 
> Might be because you use loopback device ? ;)
> 
> ifconfig lo | grep MTU UP LOOPBACK RUNNING  MTU:16436  Metric:1
> 
> After a while (when hitting rcvbuf limit), tcp stack performs skb
> collapses, to reduce ram usage.

Looks like this is indeed the case, changing the loopback mtu to 8K
makes it increase in 8K increments.  This is quite unexpected, since for
UDP it only increases by the actual amount of the data being sent rather
than the size of the full MTU.

As it stands, it looks like sk_rmem_alloc isn't very useful.  Can you
point me to something that is more reflective of the actual space used
by the tcp socket?  I'd like something that increases monotonically with
received data and once it exceeds the configured size then the tcp stack
will start dropping packets.  Does such a thing exist, or is the tcp
stack just too complicated to easily obtain this sort of information?

Thanks for your help,

Chris
