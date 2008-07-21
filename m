Return-Path: <linux-kernel-owner+w=401wt.eu-S1755084AbYGUVvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbYGUVvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 17:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbYGUVv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 17:51:27 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:60443 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751014AbYGUVv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 17:51:26 -0400
Message-ID: <488504D9.5090100@lwfinger.net>
Date: Mon, 21 Jul 2008 16:51:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: David Miller <davem@davemloft.net>, mingo@elte.hu, ischram@telenet.be,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, j@w1.fi
Subject: Re: [crash] BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000370
References: <4884F3D7.4070604@lwfinger.net>	<20080721.134608.75595942.davem@davemloft.net>	<4884F6E9.6090809@trash.net> <20080721.140120.135667045.davem@davemloft.net> <4884FA3F.70109@trash.net> <48850121.9090106@trash.net>
In-Reply-To: <48850121.9090106@trash.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy wrote:
> Patrick McHardy wrote:
>> David Miller wrote:
>>> Maybe something like the following should do it?
>>
>>
>> It looks correct in any case. I'm not sure whether it fixes
>> this lockdep warning though, according to the backtrace and
>> module list its b43 and dev_mc_sync in net/mac80211/main.c
>> that are causing the error, which don't seem to be included
>> in your patch. I'm unable to find where it previously
>> initialized the xmit_lock lockdep class though, so I must
>> be missing something :)
> 
> This is what I was missing, we're setting a lockdep class
> by default depending on dev->type. This patch combined
> with yours should fix all addr_list_lock warnings.

No cigar yet. I tried davem's patch first, then yours on top of his. I still get 
both the recursive locking and the kernel warning.

BTW, wireless doesn't work but if I plug in the wire, then networking is OK. It 
seems to be in mac80211, which is strange because I routinely run the latest 
wireless-testing kernel, and all the wireless bits should be there already.

I'm still plugging away at the bisection. I think I got away from the kernel 
that won't build.

Larry
