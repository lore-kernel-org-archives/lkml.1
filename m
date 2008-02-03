Return-Path: <linux-kernel-owner+w=401wt.eu-S934579AbYBCBWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934579AbYBCBWz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 20:22:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932109AbYBCBWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 20:22:42 -0500
Received: from mailgw.cvut.cz ([147.32.3.235]:47396 "EHLO mailgw.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932091AbYBCBWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 20:22:41 -0500
X-Greylist: delayed 1524 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Feb 2008 20:22:40 EST
Message-ID: <47A51168.5040301@vandrovec.name>
Date: Sat, 02 Feb 2008 16:57:12 -0800
From: Petr Vandrovec <petr@vandrovec.name>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.11) Gecko/20071119 Iceape/1.1.7 (Debian-1.1.7-1)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Unbreak sky2 on 88E8039 with current git
References: <20080202105243.GA14581@vana.vc.cvut.cz> <20080202120203.5387d1cb@extreme>
In-Reply-To: <20080202120203.5387d1cb@extreme>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> On Sat, 2 Feb 2008 11:52:43 +0100
> Petr Vandrovec <petr@vandrovec.name> wrote:
> 
>> Hello,
>>   since I synced my tree to Linus's one two days ago, sky2's packet receiption
>> dies almost instantly.  Device still transmits packets, but no receive.  
>> Fortunately fix is simple, unfortunately I do not know why fix works...
>>
>> Commit f03b865491c2f30f2a4d77cdafc69c978ceb38a0 (sky2: align IP header on Rx
>> if possible) stopped aligning receive buffers on devices which do not need
>> HANG_CHECK.  Unfortunately there is at least one device (mine, Yukon FE, rev 3)
>> which is not happy if receive buffer is not aligned.  I have no idea which
>> other chips/revisions are affected as well.
>>
>> Without patch 'ping -f -b 192.168.101.255' RX count stops incrementing in less
>> than 50 packets.  With patch in place it can run like before, for hours...
>> Box is an AMD rev F processor, with nVidia's MCP61 chipset.
>> 							Petr
> 
> I don't have a Yukon FE, but I believe that the Yukon FE does have a ram
> buffer, so you HANG_CHECK should be enabled for that device. You can check
> by running:
> 	ethtool -d eth0 | grep 'Ram Buffer'
> With ram buffer (like XL, EC)
> 	
> # ethtool -d eth0 | grep 'Ram Buffer'
> Ram Buffer                   0x18
> 
> No ram buffer (like EC-U, FE+, ...)
> # ethtool -d eth0 | grep 'Ram Buffer'
> Ram Buffer                   0x00

Some small one (if it is size):

gwy:~# ethtool -d eth0 | grep 'Ram'
Ram Buffer                   0x01

I've never observed hang on that device, and I have it for over year. I 
stress it sufficiently to kill EC rev 2 I have in the notebook when I 
copy some data between these two boxes, but this FE never hung.
							Petr

