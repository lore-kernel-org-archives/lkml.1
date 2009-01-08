Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbZAHQvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbZAHQvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 11:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbZAHQve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 11:51:34 -0500
Received: from proxy2.bredband.net ([195.54.101.72]:44145 "EHLO
	proxy2.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbZAHQvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 11:51:33 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiI3AIi9ZUlT46GbPGdsb2JhbACUBgEBAQEeFwu6bYV1
Message-ID: <49662F08.4070607@rubidium.dyndns.org>
Date: Thu, 08 Jan 2009 17:51:20 +0100
From: Magnus Danielson <magnus@rubidium.dyndns.org>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: "M. Warner Losh" <imp@bsdimp.com>
CC: davidn@davidnewall.com, david@lang.hm, hancockr@shaw.ca,
       kyle@moffetthome.net, slashdot@jameshallam.info, goodgerster@gmail.com,
       mayer@ntp.isc.org, linux-kernel@vger.kernel.org,
       ntpwg@lists.ntp.isc.org, pretzalz@techhouse.org,
       burdell@iruntheinter.net, linasvepstas@gmail.com, nick@nick-andrew.net,
       jeff@kosowsky.org, magnus@rubidium.dyndns.org
Subject: Re: [ntpwg] Bug: Status/Summary of slashdot leap-second crash on
 new years 2008-2009
References: <49642674.9080703@ntp.isc.org>	<3ae3aa420901062052h75fcab11n8ce45c41ac0e4cd2@mail.gmail.com>	<49647E0F.9030008@davidnewall.com> <20090107.102434.-1980908153.imp@bsdimp.com>
In-Reply-To: <20090107.102434.-1980908153.imp@bsdimp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

M. Warner Losh skrev:
> In message: <49647E0F.9030008@davidnewall.com>
>             David Newall <davidn@davidnewall.com> writes:
> : Linas Vepstas wrote:
> : > Currently, the Linux kernel keeps time in UTC. This means
> : > that it must take special actions to tick twice when a leap
> : > second comes by.
> : 
> : Except it doesn't have to tick twice.  Refer to
> : http://lkml.org/lkml/2009/1/7/78 in which I show that a time_t (what
> : time() returns) counts leap seconds (According to Bernstein this is what
> : UTC means), and using zoneinfo, the library processes leap seconds
> : correctly.
> 
> This is *NOT* POSIX time_t.  In order to be posix compliant, you can't
> do what Bernstein suggests.  You can be non-complaint and deal it with
> zoneinfo.

You are free to keep your core time in whatever form you wish, but if 
you want your time_t to be POSIX compatible when accessed over POSIX 
interfaces you would need to honour the POSIX time_t mapping. While 
POSIX tried to avoid the leapsecond issue, the mapping they do perform 
has a peculiar effect on what happends on time_t if you also want to 
honour the UTC to time_t mapping while accepting UTC from external sources.

> : I just realised that the Notes in man 2 time are confusing and probably
> : unnecessary.  Suffice to say that (assuming correctly configured
> : zoneinfo) time() returns the number of seconds elapsed since start 1970.
> 
> That's not POSIX complaint.

It just *appears* to be the number of "seconds" since 1970. This 
appearence is important to some and causing a greif to others.

Cheers,
Magnus
