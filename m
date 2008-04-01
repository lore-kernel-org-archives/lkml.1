Return-Path: <linux-kernel-owner+w=401wt.eu-S1758472AbYDALVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472AbYDALVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 07:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756423AbYDALVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 07:21:37 -0400
Received: from smtp.nokia.com ([192.100.105.134]:39252 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035AbYDALVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 07:21:36 -0400
Message-ID: <47F219B0.6020109@nokia.com>
Date: Tue, 01 Apr 2008 14:17:04 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
CC: Artem Bityutskiy <dedekind@yandex.ru>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       LKML <linux-kernel@vger.kernel.org>, joern@lazybastard.org
Subject: Re: UBIFS vs Logfs (was [RFC PATCH] UBIFS - new flash file system)
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com> <alpine.LNX.1.10.0803311428270.2554@fbirervta.pbzchgretzou.qr> <47F0DD49.7010302@nokia.com> <20080331132047.GA31660@logfs.org> <47F1C78D.2050300@yandex.ru> <47F1CE9D.4080709@nokia.com> <20080401092548.GC7465@logfs.org> <47F202CD.4000804@yandex.ru> <20080401105104.GE7465@logfs.org>
In-Reply-To: <20080401105104.GE7465@logfs.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Apr 2008 11:20:56.0519 (UTC) FILETIME=[74700D70:01C893EA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> Fair enough.
> 
> The obvious downside of all this is depending on UBI, which has a linear
> scan.  My goal was to avoid the linear scan completely.  It is a harder
> goal and I haven't reached it yet.  Imo it is reachable and I will
> continue going in that direction.

Yes, it was our core design decision. One of the reasons, we were not sure
this is technically possible to do on bare flashes. I mean, it just looked
so complex to have all in one, so we figured that was a good split, where
you can cut on big work on two smaller separate ones. The benefit of this
is obvious - we have created a complete system, which is not perfect though
and have scalability issues.

Our point is that UBI is scalable enough for the time being.

I wrote some documentation about this in UBI FAQ and UBIFS FAQ:
http://www.linux-mtd.infradead.org/doc/ubifs.html#L_scalability

We can now improve scalability of UBI without affecting UBIFS - it has some
potential. And we may develop UBI2 which would be more much more scalable,
but this is a big project and we are not planning to do this so far. Others
could do.

So in other words, using UBI allowed us to get a finished system faster. I
meets our's and many other people's requirements, although it has issues if
you try to use it on really huge flashes, like 64GiB. That's a drawback.
But the good thing is that this would require re-working UBI layer, without
complete re-working of UBIFS. 

> You picked the route of using UBI, which makes a lot of stuff easier.
> It is a fair approach and I don't mind you taking it.  It has drawbacks,
> but so has everything else.
Agree.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
