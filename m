Return-Path: <linux-kernel-owner+w=401wt.eu-S1753049AbYKGNn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbYKGNn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 08:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbYKGNno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 08:43:44 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:30756 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbYKGNnm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 08:43:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GRumIb+kAykv9Uojsfu6Cd4hbc3iD/j5NEXZklC3UVY1l3ptUnRErTJ/7EXsh93JOa
         Vmew/BRcG8ksob8VjuNChVl21Z0rQ9XyKlwFGgX9ZK1ArO//TERLb8vy7wg5np/j5WNJ
         NXwX71yDqxEVcyCFZvf0XFmjPrZCIHW9Wb7QE=
Message-ID: <6278d2220811070543p51ca2139t13aba28e6dba5ff4@mail.gmail.com>
Date: Fri, 7 Nov 2008 13:43:40 +0000
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Mikael Abrahamsson" <swmike@swm.pp.se>,
       "David Miller" <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       linux-net@vger.kernel.org,
       "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Subject: Re: time for TCP ECN defaulting to on?
In-Reply-To: <Pine.LNX.4.64.0811071341430.23792@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <6278d2220811040632u7a36d68ekad5de517fd0671bb@mail.gmail.com>
	 <alpine.DEB.1.10.0811052316210.10993@uplift.swm.pp.se>
	 <20081105.151015.206163697.davem@davemloft.net>
	 <alpine.DEB.1.10.0811070529550.10993@uplift.swm.pp.se>
	 <Pine.LNX.4.64.0811070931190.23284@wrl-59.cs.helsinki.fi>
	 <alpine.DEB.1.10.0811070854361.10993@uplift.swm.pp.se>
	 <Pine.LNX.4.64.0811071039480.23629@wrl-59.cs.helsinki.fi>
	 <alpine.DEB.1.10.0811071230310.10993@uplift.swm.pp.se>
	 <Pine.LNX.4.64.0811071341430.23792@wrl-59.cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 7, 2008 at 12:22 PM, Ilpo Järvinen
<ilpo.jarvinen@helsinki.fi> wrote:
> On Fri, 7 Nov 2008, Mikael Abrahamsson wrote:
>> On Fri, 7 Nov 2008, Ilpo Järvinen wrote:
>> > I think you partially miss the point here. In many cases not every
>> > single
>> > router has to _support_ ECN to get its benefits, not-supporting is not
>> > the
>> > problem in itself (though it would be nice to get that "fixed" as well)
>> > but
>> > breaking ecn-enabled connections. I suppose you didn't check that
>> > aspect?
>> > I'd guess those mentioned devices will interoperate just fine since one
>> > can
>> > mostly connect ok with ecn too besides rare exceptions rather than
>> > things
>> > being vice-versa.
>>
>> I don't understand. My point is that most of the ISP core equipment out
>> there
>> doesn't act on ECN rendering it mostly useless. The N in ECN renders
>> useless
>> because there is no device doing the *notification*. They'll just pass the
>> traffic without acting on it differently regardless if ECN is on or off.

I've been running with ECN enabled on all my client linux systems and
(personal) webservers for the past 6 or so years. When I've
encountered issues accessing particular hosts, I turn it and TCP
window scaling off, but invariably it is always another cause.

If most ECN-broken hardware is embedded consumer appliances (which are
generally short-lifespan and moving more and more to linux), then we
avoid hurting these users by enabling ECN per default when eg
CONFIG_IP_ADVANCED_ROUTER is set (to little direct benefit of course).
It's a start and a constructive idea; by doing this and documenting
it, we provide a wake-up call for vendors, laying the path for
enabling it for all types of host in a few years. Even enabling ECN
for -rc kernels will raise awareness.

Alternatively, an ECN-day could be publicised targeting the linux tech
community, where we can report failing networks/sites to a central
website to quantify actual potential negative impact.

But doing nothing is cyclic - when will the natural break suddenly occur?
-- 
Daniel J Blueman
