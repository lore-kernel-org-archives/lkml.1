Return-Path: <linux-kernel-owner+w=401wt.eu-S933320AbXK3HHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320AbXK3HHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 02:07:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757542AbXK3HGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 02:06:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36109 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873AbXK3HGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 02:06:49 -0500
Message-ID: <474FB608.4030508@zytor.com>
Date: Thu, 29 Nov 2007 23:04:40 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: =?UTF-8?B?IlBhdWwgUm9sbGFuZCAo44Od44O844Or44O744Ot44Op44OzKSI=?= 
	<rol@witbe.net>
CC: Michael Tokarev <mjt@tls.msk.ru>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: constant_tsc and TSC unstable
References: <20071129171142.56c7890a@tux.DEF.witbe.net>	<474F0D47.7020006@zytor.com>	<474F2E97.5080802@msgid.tls.msk.ru> <20071130075932.7f1f0974@tux.DEF.witbe.net>
In-Reply-To: <20071130075932.7f1f0974@tux.DEF.witbe.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Rolland (ポール・ロラン) wrote:
> 
>> Note that once TSC is disabled (it's using "jiffies" as far
>> as I can see), ntpd constantly speeds up and slows down the
>> clock, it jumps +/- 0.5sec every several minutes or hours -
>> I guess that's when ntpd process gets moved from one core
>> to another for whatever reason.  And an interesting thing
>> is that with 64bits kernel this TSC problem does not occur
>> on this very machine.
> Hmmmm.... That could make it a problem related to kernel rather than CPU.
>  
>> Something similar is reported on AMD X2 64 machines as well --
>> can't check right now.
> If I recall correctly, issues with AMD X2 where related to TSC being
> independant for each core and not constant (speed depending of C state).
> But the reason I raise the issue is that the Core2 reports constant TSC,
> so there is (IMHO) no reason for that.
> 

Well, "constant" doesn't mean "synchronized", but it might very well be 
that the Core2 could really benefit from synchronizing the TSCs manually 
like we used to.

On the other hand, I notice that most of the TSC warp values are 
relatively close to 2^32, so this could be a specific bug.

	-hpa

