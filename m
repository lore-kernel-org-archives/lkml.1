Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbYKTS2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbYKTS2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 13:28:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbYKTS2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 13:28:41 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:10754 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbYKTS2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 13:28:40 -0500
X-BigFish: VPS-49(zz1432R14e0Q98dR1805M936fO9371Pzzzzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4925AC37.7080502@am.sony.com>
Date: Thu, 20 Nov 2008 10:28:07 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Will Newton <will.newton@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] init/main.c: Use ktime accessor function in initcall_debug
 code.
References: <87a5b0800811200647t4de76a2ah683ac6083014d061@mail.gmail.com>	 <4925A0BC.7050207@am.sony.com> <87a5b0800811200946m4b58db6aoe91bfc45c38982bb@mail.gmail.com>
In-Reply-To: <87a5b0800811200946m4b58db6aoe91bfc45c38982bb@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Nov 2008 18:28:08.0503 (UTC) FILETIME=[BC8A2C70:01C94B3D]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will Newton wrote:
> On Thu, Nov 20, 2008 at 5:39 PM, Tim Bird <tim.bird@am.sony.com> wrote:
>> Will Newton wrote:
>>> The initcall_debug code access the tv64 member of ktime. This won't work
>>> correctly for large deltas on platforms that don't use the scalar ktime
>>> implementation.
>> In principle I see no problem with this.  But as a matter of
>> practice it may be overkill.
> 
> Possibly, but it makes the code clearer I think.
> 
>> How big does the delta have to be for this to be a problem?
>> And how much overhead does ktime_to_ns() add?
> 
> Deltas over a second will be incorrect.

OK.  Good fix, then.

> I have serial8250_init taking
> 8 seconds at the moment, so that isn't unheard of.

This is likely the result of the emission of all
previously queued printks which occurs during serial8250_init()
(as a side effect of finally initializing the console).

I see this kind of long delay all the time.
If the 8 seconds is a bother, you might want
to use 'quiet' on the kernel command line.

I suspect you've already seen this page, but for future
readers of this thread, there's info on this at:
http://elinux.org/Disable_Console

> On scalar ktime architectures it should be zero, on others a multiply
> and an add (it's an inline). I wouldn't call it a fast path though.

OK.  You have my ACK.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

