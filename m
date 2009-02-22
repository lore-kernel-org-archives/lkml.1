Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbZBVVEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbZBVVEw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 16:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbZBVVEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 16:04:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57533 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbZBVVEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 16:04:42 -0500
Message-ID: <49A1BC28.9020402@zytor.com>
Date: Sun, 22 Feb 2009 12:57:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rodolfo Giometti <giometti@linux.it>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 1/1] LinuxPPS core support.
References: <1234274752-29847-1-git-send-email-giometti@linux.it> <1234274752-29847-2-git-send-email-giometti@linux.it> <20090222203933.GA18914@elte.hu>
In-Reply-To: <20090222203933.GA18914@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>
>> Common use is the combination of the NTPD as userland program 
>> with a GPS receiver as PPS source to obtain a wallclock-time 
>> with sub-millisecond synchronisation to UTC.
> 
> Hm. I was looking at this stuff with the prospect of adding it 
> to the timer tree, but i'm really struggling with a few 
> fundamental questions.
> 
> The most basic one is: why do we need this?
> 
> The main purpose of your current patchset seems to be to deliver 
> interrupt timestamps to user-space, where it will in essence be 
> used to feed new adjtimex adjustments via ntpd.
> 
> I.e. the whole thing comes around in a circle in the end, but 
> via user-space, where jitter will only increase.
> 
> Why not cut out the jittery middle man and add some intelligent 
> API to register PPS interrupt sources straight with the NTP 
> code, and let those IRQ timestamps be fed _directly_ into our 
> time adjustment code?
> 

Well, let's be fair here... the kernel-user space time model involving
ntpd has been very carefully developed over a period of over a decade.
It's known to work.  The userspace involvement isn't just about feeding
the data to the local clock, but also -- or perhaps primarily so -- to
keep the timing inside ntpd calibrated, as that is the time that will be
provided to the outside world.

There is a real benefit to using the model designed for and expected by
ntpd, too.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

