Return-Path: <linux-kernel-owner+w=401wt.eu-S1765270AbXF2MGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765270AbXF2MGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 08:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761334AbXF2MGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 08:06:45 -0400
Received: from hermes.domdv.de ([193.102.202.1]:3526 "EHLO hermes.domdv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761296AbXF2MGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 08:06:44 -0400
Message-ID: <4684F5D3.8020506@domdv.de>
Date: Fri, 29 Jun 2007 14:06:43 +0200
From: Andreas Steinmetz <ast@domdv.de>
User-Agent: Mail/News 1.5.0.7 (X11/20060915)
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       netfilter-devel@lists.netfilter.org
Subject: Re: mss to pmtu clamping partially broken?
References: <4684E853.20900@domdv.de> <4684EF6A.7070109@trash.net> <4684F3D8.1080800@domdv.de> <4684F4FB.9070807@trash.net>
In-Reply-To: <4684F4FB.9070807@trash.net>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy wrote:
> Andreas Steinmetz wrote:
>> Patrick McHardy wrote:
>>
>>> Andreas Steinmetz wrote:
>>>
>>>> [...]
>>>> The tcpdump on the client shows that the mss of the incoming syn reply
>>>> packet is *NOT* clamped to the ppp interface mtu.
>>>
>>> You forgot to mention *how* you're clamping the MSS. Using
>>> TCPMSS? Do you have a rule for incoming packets?
>>>
>>
>> The relevant iptables commands I do use for masquerading and clamping are:
>>
>> iptables -t nat -A POSTROUTING -o ppp0 -j MASQUERADE
>> iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS \
>> 	--clamp-mss-to-pmtu
> 
> 
> Two things here:
> 
> - tcpdumps on ppp0 will show unclamped packets since they haven't
> been forwarded yet
> 

That is true, I know this.

> - assuming you have ethernet internally, the PMTU from your router
> to the internal hosts is 1500, so it won't do any clamping.
> 

Yep, internal PMTU is 1500, still the incoming packets are clamped to
1452 on the one line and not clamped on the other.

> Does that explain it?
> 
> A useful thing for TCPMSS for routers would be to clamp to the
> minimum of the PMTU of both directions. But thats not supported
> so far.
> 

I wonder, as somteimes it gets clamped. If it would never have been
clamped I wouldn't have asked.

-- 
Andreas Steinmetz                       SPAMmers use robotrap@domdv.de
