Return-Path: <linux-kernel-owner+w=401wt.eu-S1760805AbXKAO4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760805AbXKAO4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 10:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754803AbXKAOz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 10:55:59 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:59238 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733AbXKAOz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 10:55:58 -0400
Message-ID: <4729E85D.4040505@oracle.com>
Date: Thu, 01 Nov 2007 07:53:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Trent Piepho <xyzzy@speakeasy.org>, v4l-dvb-maintainer@linuxtv.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [v4l-dvb-maintainer] bttv build error (CONFIG_NET=n)
References: <20071030221508.3139ea5c.randy.dunlap@oracle.com>	 <Pine.LNX.4.58.0710310345160.19072@shell4.speakeasy.net>	 <20071031092350.91eae067.randy.dunlap@oracle.com> <1193905709.8587.24.camel@gaivota>
In-Reply-To: <1193905709.8587.24.camel@gaivota>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab wrote:
> Randy,
> 
>>> The only reason the net stuff works, is because CONFIG_NET includes igmp.c,
>>> which can't be compiled as a module.  That means ip_compute_csum() will get
>>> pulled out of the lib.a file for igmp, and thus be present for the net modules
>>> that use it too.  If igmp could be turned off, made a module, or stopped using
>>> ip_compute_csum(), then the users of ip_compute_csum() that do depend on
>>> CONFIG_NET would have the same problem as bttv does.
>> Thanks for the analysis and summary.
>> (I'm still waiting for those lkml.org links to load... timed out)
>>
>>> It seems a shame to create a new ip checksum function in the bttv driver when
>>> a perfectly good one already exists and will already be present in just about
>>> every kernel out there.  Honestly, how common is NET=n and VIDEO_BT848=m
>>> outside of randconfig?
> 
> This might happen on embedded devices, like a set top box or a PVR,
> using a bttv hardware.
> 
>> so just adding "depends on NET" should be OK then?
> 
> Seems very weird to have bttv module dependent on NET, just because a
> checksum calculus function is defined there. 

Oh, I agree with that.  My comment above possibly needed a smiley.

> One possible solution would be to move this function to another place
> and having both NET, BTTV and other places selecting it.

I gave 3 possible solutions in the beginning email.  I would probably
just modify bttv to support osprey only when CONFIG_NET=y.

or fix the linking problem that Trent pointed out.

-- 
~Randy
