Return-Path: <linux-kernel-owner+w=401wt.eu-S1756673AbXJCNv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbXJCNv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 09:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571AbXJCNvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 09:51:52 -0400
Received: from main.gmane.org ([80.91.229.2]:36895 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520AbXJCNvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 09:51:51 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: Re: [PATCH] Fallback to ipv4 if we try to add join IPv4 multicast
 group via   ipv4-mapped address.
Date: Wed, 03 Oct 2007 17:26:35 +0400
Message-ID: <4703988B.3010904@gmail.com>
References: <1191319182.28331.6.camel@doriath.ww600.siemens.net> <OFDC1D2E6E.2DCF75EA-ON88257368.0053513A-88257368.005586DC@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
Cc: netdev@vger.kernel.org
X-Gmane-NNTP-Posting-Host: iap-pxy-mow1.siemens.ru
User-Agent: IceDove 1.5.0.12 (X11/20070730)
In-Reply-To: <OFDC1D2E6E.2DCF75EA-ON88257368.0053513A-88257368.005586DC@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

David Stevens wrote:
> Dmitry,
>         Good catch; a couple comments:

Thank you for the response.

> 
>>     struct ipv6_pinfo *np = inet6_sk(sk);
>>     int err;
>> +   int addr_type = ipv6_addr_type(addr);
>> +
>> +   if (addr_type == IPV6_ADDR_MAPPED) {
>> +      __be32 v4addr = addr->s6_addr32[3];
>> +      struct ip_mreqn mreq;
>> +      mreq.imr_multiaddr.s_addr = v4addr;
>> +      mreq.imr_address.s_addr = INADDR_ANY;
>> +      mreq.imr_ifindex = ifindex;
>> +
>> +      return ip_mc_join_group(sk, &mreq);
>> +   }
> 
>         ipv6_addr_type() returns a bitmask, so you should use:
> 
>         if (addr_type & IPV6_ADDR_MAPPED) {

I just c'n'pasted the code that checks for mapped addresses. In most 
cases it's just ==, not bitmask operation.

> 
> Also, you should have a blank line after the "mreq" declaration.

ok.

> 
> Ditto for both in ipv6_mc_sock_drop().


> I don't expect the multicast source filtering interface will
> behave well for mapped addresses, either. The mapped multicast
> address won't appear to be a multicast address (and return
> error there), and all the source filters would have to be
> v4mapped addresses and modify the v4 source filters for this
> to do as you expect. So, there's more to it (and it may be a
> bit messy) to support mapped multicast addresses fully. I'll
> think about that part some more.


Didn't have time to test it throughly. I've only checked that call 
succeeds and that all necessary igmp are sent. I hope, this weekend I'll 
have more time to check.

--
With best wishes
Dmitry Baryshkov

