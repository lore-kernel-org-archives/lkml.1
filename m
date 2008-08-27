Return-Path: <linux-kernel-owner+w=401wt.eu-S1752976AbYH0R11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbYH0R11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 13:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbYH0R1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 13:27:16 -0400
Received: from smtp20.orange.fr ([193.252.22.31]:36935 "EHLO smtp20.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbYH0R1P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 13:27:15 -0400
X-ME-UUID: 20080827172710626.990221C00083@mwinf2024.orange.fr
Message-ID: <48B58E6B.1030302@cosmosbay.com>
Date: Wed, 27 Aug 2008 19:27:07 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: Rick Jones <rick.jones2@hp.com>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Denys Fedoryshchenko <denys@visp.net.lb>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: loaded router, excessive getnstimeofday in oprofile
References: <200808220457.40892.denys@visp.net.lb> <20080826201406.GA24827@2ka.mipt.ru> <48B46B48.7030609@cosmosbay.com> <20080826205158.GA15266@2ka.mipt.ru> <87vdxmr53f.fsf@basil.nowhere.org> <48B57BD3.5050206@hp.com> <20080827162735.GW26610@one.firstfloor.org> <48B58586.3080806@hp.com> <20080827165635.GY26610@one.firstfloor.org>
In-Reply-To: <20080827165635.GY26610@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen a écrit :
> On Wed, Aug 27, 2008 at 09:49:10AM -0700, Rick Jones wrote:
>> Andi Kleen wrote:
>>>> Those banks really want to crank down on latency - to the point they 
>>>> start disabling interrupt coalescing.  I bet they'd toss anything out 
>>>> they could to shave another microsecond.
>>>
>>> This change would actually likely lower their latency.
>> I'm guessing you mean increase their latency?  I agree, it could - 
>> depends entirely on the PPS in production I suspect.
> 
> No, moving the time stamps into the socket decreases latency
> for all packets that don't need time stamps. And they likely 
> have some packets which don't need time stamps too.
> 
> As a secondary effect if they use a RT kernel it might
> be also beneficial to do the (depending on the platform)
> costly time stamp in the lower priority socket context
> than in the high priority interrupt thread.
>

Doing the expensive timestamping in a possibly delayed thread (ie some milliseconds
 after hardware notification) is wrong/useless.

Better use plain xtime instead of getnstimeofday() in this case.

We could provide a sysctl setting so that admin can chose between precise timestamps
(current behavior) or fast but low resolution timestamping (xtime based)





