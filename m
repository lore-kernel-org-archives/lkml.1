Return-Path: <linux-kernel-owner+w=401wt.eu-S1753305AbYKGLjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbYKGLjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 06:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYKGLjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 06:39:03 -0500
Received: from swm.pp.se ([212.247.200.143]:56573 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbYKGLjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 06:39:01 -0500
Date: Fri, 7 Nov 2008 12:38:59 +0100 (CET)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
cc: David Miller <davem@davemloft.net>, daniel.blueman@gmail.com,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       linux-net@vger.kernel.org
Subject: Re: time for TCP ECN defaulting to on?
In-Reply-To: <Pine.LNX.4.64.0811071039480.23629@wrl-59.cs.helsinki.fi>
Message-ID: <alpine.DEB.1.10.0811071230310.10993@uplift.swm.pp.se>
References: <6278d2220811040632u7a36d68ekad5de517fd0671bb@mail.gmail.com> <alpine.DEB.1.10.0811052316210.10993@uplift.swm.pp.se> <20081105.151015.206163697.davem@davemloft.net> <alpine.DEB.1.10.0811070529550.10993@uplift.swm.pp.se>
 <Pine.LNX.4.64.0811070931190.23284@wrl-59.cs.helsinki.fi> <alpine.DEB.1.10.0811070854361.10993@uplift.swm.pp.se> <Pine.LNX.4.64.0811071039480.23629@wrl-59.cs.helsinki.fi>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
Organization: People's Front Against WWW
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-137064504-1445617518-1226057771=:10993"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---137064504-1445617518-1226057771=:10993
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15; FORMAT=flowed
Content-Transfer-Encoding: 8BIT

On Fri, 7 Nov 2008, Ilpo Järvinen wrote:

> I think you partially miss the point here. In many cases not every 
> single router has to _support_ ECN to get its benefits, not-supporting 
> is not the problem in itself (though it would be nice to get that 
> "fixed" as well) but breaking ecn-enabled connections. I suppose you 
> didn't check that aspect? I'd guess those mentioned devices will 
> interoperate just fine since one can mostly connect ok with ecn too 
> besides rare exceptions rather than things being vice-versa.

I don't understand. My point is that most of the ISP core equipment out 
there doesn't act on ECN rendering it mostly useless. The N in ECN renders 
useless because there is no device doing the *notification*. They'll just 
pass the traffic without acting on it differently regardless if ECN is on 
or off.

> The most crucial components are anyway the points of congestion, I don't know 
> enough isp topologies but I suppose those core routers are not the ones where 
> towards subscribers device traffic congests?

There can be congestion anywhere in the network, best would be if all 
routers supported it. My problem with ECN is that the most advanced 
routers do not support it, it's useless with L2/L3 switches (as they have 
very small buffers, there is "nothing" to do WRED on), so that leaves 
potential implementation by either DSLAM/BRAS vendors (where Cisco BRAS 
does support it but it needs to be enabled by the ISP) or the SOHO devices 
which run Linux and might implement it, but I'd rather see them do active 
queue management at all (fair-queue for instance) before asking them to do 
ECN. Of course, if users start to ask for ECN and we get fair-queue at the 
same time, all the better. One very common congestion point is definitely 
the upstream connection of someones cable or DSL modem.

> I doubt it any worse than with eg. timestamps.

According to <http://www.imperialviolet.org/binary/ecntest.pdf> it's 0.5% 
of hosts that drop packets when ECN is enabled. It's a substantial part of 
the Internet. Yes, not doing blackhole detection might get these hosts 
fixed faster, but at the expense of more end user hurt.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
---137064504-1445617518-1226057771=:10993--
