Return-Path: <linux-kernel-owner+w=401wt.eu-S1765961AbXLRAfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765961AbXLRAfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 19:35:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762076AbXLRAfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 19:35:42 -0500
Received: from stinky.trash.net ([213.144.137.162]:40052 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761024AbXLRAfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 19:35:41 -0500
Message-ID: <476715DB.6050808@trash.net>
Date: Tue, 18 Dec 2007 01:35:39 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Thomas Graf <tgraf@suug.ch>
CC: Chris Friesen <cfriesen@nortel.com>, yoshfuji@linux-ipv6.org,
       dada1@cosmosbay.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: "ip neigh show" not showing arp cache entries?
References: <4760279E.1080203@nortel.com> <47602DD0.8070402@cosmosbay.com> <47605934.2060604@nortel.com> <20071213.070641.20411400.yoshfuji@linux-ipv6.org> <476696A5.1010101@nortel.com> <4766B99D.8060408@trash.net> <4766D261.1020005@nortel.com> <47670B88.4010906@trash.net> <20071218003312.GR11220@postel.suug.ch>
In-Reply-To: <20071218003312.GR11220@postel.suug.ch>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Graf wrote:
> * Patrick McHardy <kaber@trash.net> 2007-12-18 00:51
>> Chris Friesen wrote:
>>> Patrick McHardy wrote:
>>>
>>>> From a kernel perspective there are only complete dumps, the
>>>> filtering is done by iproute. So the fact that it shows them
>>>> when querying specifically implies there is a bug in the
>>>> iproute neighbour filter. Does it work if you omit "all"
>>> >from the ip neigh show command?
>>>
>>> Omitting "all" gives identical results.  It is still missing entries 
>>> when compared with the output of "arp".
>>
>> In that case the easiest way to debug this is probably if you
>> add some debugging to ip/ipneigh.c:print_neigh() since I'm
>> unable to reproduce this problem. A printf for all the filter
>> conditions (=> return 0) at the top should do.
> 
> Alternatively, you can download libnl and run
> 
> 	NLCB=debug src/nl-neigh-dump brief
> 
> and check if the netlink message is sent by the kenrel for the
> neighbour in question. 


It should be, according to Chris, "ip neigh show <ip>" does
show the missing entries, and in case of neighbour entries
all filtering is done in userspace.


