Return-Path: <linux-kernel-owner+w=401wt.eu-S1764924AbXF2MD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764924AbXF2MD0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 08:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760511AbXF2MDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 08:03:19 -0400
Received: from stinky.trash.net ([213.144.137.162]:43069 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759855AbXF2MDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 08:03:18 -0400
Message-ID: <4684F4FB.9070807@trash.net>
Date: Fri, 29 Jun 2007 14:03:07 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andreas Steinmetz <ast@domdv.de>
CC: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       netfilter-devel@lists.netfilter.org
Subject: Re: mss to pmtu clamping partially broken?
References: <4684E853.20900@domdv.de> <4684EF6A.7070109@trash.net> <4684F3D8.1080800@domdv.de>
In-Reply-To: <4684F3D8.1080800@domdv.de>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Steinmetz wrote:
> Patrick McHardy wrote:
> 
>>Andreas Steinmetz wrote:
>>
>>>[...]
>>>The tcpdump on the client shows that the mss of the incoming syn reply
>>>packet is *NOT* clamped to the ppp interface mtu.
>>
>>
>>You forgot to mention *how* you're clamping the MSS. Using
>>TCPMSS? Do you have a rule for incoming packets?
>>
> 
> 
> The relevant iptables commands I do use for masquerading and clamping are:
> 
> iptables -t nat -A POSTROUTING -o ppp0 -j MASQUERADE
> iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS \
> 	--clamp-mss-to-pmtu


Two things here:

- tcpdumps on ppp0 will show unclamped packets since they haven't
been forwarded yet

- assuming you have ethernet internally, the PMTU from your router
to the internal hosts is 1500, so it won't do any clamping.

Does that explain it?

A useful thing for TCPMSS for routers would be to clamp to the
minimum of the PMTU of both directions. But thats not supported
so far.

