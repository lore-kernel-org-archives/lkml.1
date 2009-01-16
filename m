Return-Path: <linux-kernel-owner+w=401wt.eu-S936395AbZAPSAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936395AbZAPSAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 13:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760160AbZAPSAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 13:00:06 -0500
Received: from nxgate.netxen.com ([38.99.60.130]:9954 "EHLO nxexch.unminc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755820AbZAPSAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 13:00:05 -0500
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Jan 2009 13:00:05 EST
Message-ID: <4970C9E0.6030702@netxen.com>
Date: Fri, 16 Jan 2009 09:54:40 -0800
From: Dhananjay Phadke <dhananjay@netxen.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: David Miller <davem@davemloft.net>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [build bug] drivers/net/netxen/netxen_nic_main.c:1189: error:
 implicit declaration of function 'ipv6_hdr'
References: <20090115.160159.262623707.davem@davemloft.net> <20090116103209.GA9122@elte.hu>
In-Reply-To: <20090116103209.GA9122@elte.hu>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I guess I need to explicitly include <linux/ipv6.h>.
I will follow up with a patch to fix this.

-Dhananjay

Ingo Molnar wrote:
> * David Miller <davem@davemloft.net> wrote:
> 
>>       netxen: fix endianness in firmware commands
>>       netxen: fix ipv6 offload and tx cleanup
>>       netxen: fix link speed reporting for some boards
>>       netxen: firmware init fix
>>       netxen: cleanup mac list on driver unload
>>       netxen: hold tx lock while sending firmware commands
>>       netxen: handle dma mapping failures
> 
> One of these causes frequent build failures on x86, on today's -git:
> 
>  drivers/net/netxen/netxen_nic_main.c:1189: error: implicit declaration of function 'ipv6_hdr'
>  drivers/net/netxen/netxen_nic_main.c:1189: error: invalid type argument of '->'
> 
> i suspect the key aspect is:
> 
> # CONFIG_IPV6 is not set
> 
> 	Ingo
