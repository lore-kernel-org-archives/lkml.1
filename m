Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824AbYABRzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbYABRzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 12:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbYABRzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 12:55:33 -0500
Received: from mail.tmr.com ([64.65.253.246]:34247 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbYABRzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 12:55:32 -0500
Message-ID: <477BD52C.8030104@tmr.com>
Date: Wed, 02 Jan 2008 13:17:16 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Jose de la Mancha <hidalgoj@free.fr>
CC: linux-kernel@vger.kernel.org
Subject: Re: RAID timeout parameter accessibility request
References: <C39DDD66.F5A0%hidalgoj@free.fr>
In-Reply-To: <C39DDD66.F5A0%hidalgoj@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jose de la Mancha wrote:
> Hi everyone. I'm sorry but I'm not currently subscribed to this list (I've
> been sent here by the listmaster), so please CC me all your
> answers/comments. Thanks in advance.
> 
> SHORT QUESTION :
> In a Debian-controlled RAID array, is there a parameter that handles the
> timeout before a non-responding drive is dropped from the array ? Can this
> timeout become user-adjustable in a future build ?
> 
> EXPLANATIONS :
> As you might know, if you install and use a "desktop edition" hard drive in
> a RAID array, the drive may not work correctly. This is caused by the normal
> error recovery procedure that a desktop edition hard drive uses : when an
> error is found on a desktop edition hard drive, the drive will enter into a
> deep recovery cycle to attempt to repair the error, recover the data from
> the problematic area, and then reallocate a dedicated area to replace the
> problematic area. This process can take up to 120 seconds depending on the
> severity of the issue.
> 
> The problem is that most RAID controllers allow a very short amount of time
> (7-15 seconds) for a hard drive to recover from an error. If a hard drive
> takes too long to complete this process, the drive will be dropped from the
> RAID array !
> 
> Of course there are "RAID edition" hard drives with a feature called TLER
> (Time Limited Error Recovery) which stops the hard drive from entering into
> a deep recovery cycle. The hard drive will only spend 7 seconds to attempt
> to recover. This means that the hard drive will not be dropped from a RAID
> array. But these "special" hard drives are way too expensive IMHO just for a
> small firmware-based feature.
> 
I'm not sure "way too expensive" is appropriate. I'm using Seagate 320GB 
"NS" drives instead of "AS" models, and at the time I bought them they 
were $100 vs. $95 and are now $95 vs. $85. Other sizes and vendors have 
similar price points. A 10-15% premium seems reasonable for the 
firmware, faster access, and a general assurance that the drive is 
intended for 7/24 use.

On a small home array the cost is minimal, and if you are running 
desktop drives in huge arrays 7/24 you probably are doing other cost 
cutting tradeoffs to reliability, it's a choice.

> There would be an easy way to allow users to use "ordinary" hard drives in a
> Debian software-controlled RAID array. So here's my request : I suppose
> there is a parameter that handles the default timeout before a drive is
> dropped from the RAID array. I don't know if this parameter is hardcoded,
> but it would be nice if it was user-adjustable. This way, we could simply
> set up this parameter to 120 seconds or more (instead of 7-15) and we
> wouldn't have any more problems with using desktop "edition hard" drives in
> a RAID array.
> 
> What do you think ? Can it be done in a future build ?
> 
Just in general I agree, I'd like to see the error reported back up and 
let the user make the decision. One of the benefits of Linux is that it 
lets you make your own decisions, even bad ones. Windows assumes it owns 
the computer, you're an idiot, and it will let you use your computer if 
you do it their way.

> I really hope that you'll be able to help, because I guess a lot of people
> can be concerned by this issue.
> 
Not so much, with rewrites of sectors where possible this problem is 
less common than it was. But I agree on the drive kicking option, more 
control is good. However, the timeout should be in the driver, not in 
the raid code, that's where it belongs. The kernel copes with errors 
better than having a drive go practice self-gratification for minutes at 
a time.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
