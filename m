Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbZEUUOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbZEUUOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 16:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbZEUUOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 16:14:23 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44968 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbZEUUOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 16:14:23 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A15B5FE.3070207@s5r6.in-berlin.de>
Date: Thu, 21 May 2009 22:13:50 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090411 SeaMonkey/1.1.16
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux1394-devel@lists.sourceforge.net, linux-hotplug@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       fenlason@redhat.com
Subject: Re: [PATCH] ieee1394: eth1394: use "firewire%d" instead of "eth%d"
 as interface name
References: <tkrat.21c425cc195510c9@s5r6.in-berlin.de> <20090521.123403.13286908.davem@davemloft.net>
In-Reply-To: <20090521.123403.13286908.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Date: Thu, 21 May 2009 15:29:10 +0200 (CEST)
>> Change the initial name of IP-over-1394 networking interfaces from
>> "eth[0-9]+" to "firewire[0-9]+".
...
> I think the basis for this patch is completely bogus.
> 
> Device names are just that, names.  If you want to know "what it is"
> or "where it is" you use tools to determine that information.
> 
> If you make ethtool's get info command return something useful,
> then the user can see that it's a firewire interface and act
> accordingly, as can sophisticated confiruation applications.
> 
> I am completely against this patch.

Ethtool shows:
	driver: eth1394
	version:
	firmware-version:
	bus-info: ieee1394
And the sysfs representations of the netdevices have an fw-host* device 
in the parent device chain.

I agree that userland should read less into names as they are handed out 
by the kernel.  I am also aware that it depends on the use case what 
naming scheme can be considered useful, hence userspace needs to give 
his own names anyway, regardless of how the kernel named it.

But I mildly disagree with the notion that the kernel can't start off 
with more qualification of the names than merely ensuring their 
uniqueness.  Or the other way around:  Even an entirely meaningless 
prefix would be better than "eth..", or no prefix if that's possible, 
because eth suspiciously sounds like Ethernet with which the misnamed 
RFC 2734 driver eth1394 has very little to do.

However, how mild my disagreement is should be apparent from the fact 
that I didn't bother to suggest changing it before now, in 2009. :-)
-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/
