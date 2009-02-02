Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577AbZBBKfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbZBBKfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 05:35:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbZBBKfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 05:35:33 -0500
Received: from marvin.heresymail.org ([87.106.62.5]:40220 "EHLO
	marvin.heresymail.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbZBBKfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 05:35:32 -0500
Message-ID: <4986CC6D.4090904@walrond.org>
Date: Mon, 02 Feb 2009 10:35:25 +0000
From: Andrew Walrond <andrew@walrond.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: David Miller <davem@davemloft.net>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.28 headers break kbd and net-tools userspace builds
References: <20090122191239.GA16347@uranus.ravnborg.org> <20090126.210835.181389836.davem@davemloft.net> <alpine.LSU.2.00.0901271143490.3147@fbirervta.pbzchgretzou.qr> <20090128.122924.106238702.davem@davemloft.net> <alpine.LSU.2.00.0901300510310.22910@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LSU.2.00.0901300510310.22910@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey guys. A gentle nudge...

My distro scripts build the

    glibc
    iproute2
    iputils
    kbd
    lm_sensors
    net-tools
    strace

packages and others against every new release of linux and linux-stable, 
(hence my initial report).
Right now I'm stalled at the 2.6.27.? headers so can't do any more 
testing until this is resolved.

Andrew Walrond

Jan Engelhardt wrote:
> On Wednesday 2009-01-28 21:29, David Miller wrote:
>   
>>> On Tuesday 2009-01-27 06:08, David Miller wrote:
>>>       
>>>> The fly in the ointment is linux/if_tunnel.h
>>>>
>>>> We export a structure there for a userland interface which
>>>> uses "struct iphdr".
>>>>
>>>> Because of that, we are faced with the difficult choice between
>>>> defining the structure (as we do) in linux/ip.h or using some ugly
>>>> __KERNEL__ ifdefs in linux/if_tunnel.h to conditionally include
>>>> netinet/ip.h instead. :-/
>>>>
>>>> Really, I have no idea what to do about this as the problem has
>>>> existed for so long.
>>>>         
>>> I think in the long term, exported structs should probably
>>> have a "kernel_" prefix, much like userspace libraries use
>>> such prefixes to (try to) guard against simple name clashes.
>>>       
>> This is a reasonable rule for future interfaces, but won't
>> help us here on this one.[...]
>> Really, we page a huge price these days because the relationship
>> between glibc's and the kernel's userland header exports in the
>> past has been anti-social at best.
>>
>>     
> Yeah I just had to notice >:-(
>
> IPPROTO_MH is only defined in linux/in6.h, but inclusion of it:
>
> /usr/include/linux/in6.h:31: error: redefinition of ■struct in6_addr■
> /usr/include/linux/in6.h:52: error: redefinition of ■struct sockaddr_in6■
> /usr/include/linux/in6.h:60: error: redefinition of ■struct ipv6_mreq■
>
> Ick. That's even worse than tunnels.
>
>   

