Return-Path: <linux-kernel-owner+w=401wt.eu-S1760725AbZGINFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760725AbZGINFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 09:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756453AbZGINFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 09:05:23 -0400
Received: from smtp.nokia.com ([192.100.105.134]:27070 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117AbZGINFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 09:05:22 -0400
Message-ID: <4A55EAF9.9070907@nokia.com>
Date: Thu, 09 Jul 2009 16:04:57 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Jens Axboe <jens.axboe@oracle.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 00/18] periodic write-back timer optimization
References: <20090709084822.12122.79749.sendpatchset@localhost.localdomain> <871voq6nh6.fsf@basil.nowhere.org>
In-Reply-To: <871voq6nh6.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 09 Jul 2009 13:05:02.0245 (UTC) FILETIME=[DEDA3550:01CA0095]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Artem Bityutskiy <Artem.Bityutskiy@nokia.com> writes:
> 
>> The patches attempt to optimize the periodic write-back and stop it when
>> there are no dirty data. IOW, we do not want the thread to wake up every
>> 5 seconds (by default), find there is nothing to do, and so on.
> 
> Is waking up every 5 seconds really a problem?

Yes, it is. In OMAP3 we may switch the core and most of peripherals
to off and we may stay in off and consume really few power. And waking
up from off every 5 seconds for no good reason is bad.

> The normal rule of thumb is iirc that longer sleep times than a few hundred
> ms give dimishing returns in terms of power saving.

I think our pm guys measured this on OMAP3 and it translates to
~hour of idle mode. And yes, this is bad for devices which
run from battery.

> A simple way might be simple to batch the timer better with other timers.

I agree. There is a lot of work in this direction. There are many
places where we could use range hrtimers or deferrable timers
and improve PM. But I consider this to be the second level of
optimization. The first level is to get rid of unneeded events
completely.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
