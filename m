Return-Path: <linux-kernel-owner+w=401wt.eu-S1755615AbYGJHLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbYGJHLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 03:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbYGJHLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 03:11:38 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:24176 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbYGJHLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 03:11:38 -0400
Message-ID: <4875B627.9020209@msgid.tls.msk.ru>
Date: Thu, 10 Jul 2008 11:11:35 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25: random stalls on certain hardware - regression?
References: <4873E27C.6050504@msgid.tls.msk.ru> <200807091032.14786.oliver@neukum.org> <48748340.1060603@msgid.tls.msk.ru> <200807091337.32118.oliver@neukum.org>
In-Reply-To: <200807091337.32118.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:

[hard hangs in 2.6.25+ may be related to select()]
> 
> select() but not necessary the first call. I've got a report which seems
> to indicate a rogue pointer while building the poll table. You might
> strace a test programm and see whether it hangs in select() if it manages
> to trigger the lockup.

I wrote a small program that opens/closes tcp and unix sockets at random,
does listen() on them and select()s them with zero timeout, with short
sleep()s in between - so that most of the time it will be in sleep(),
and only for a short time in select() and other syscalls.  So if strace
will show it hanged in sleep() (most "active") we can't prove anything,
and if it will hand in select().... well... we can't prove anything
either, really... ;)  I think.  Today night it hanged again, now with
2.6.26-pre9 kernel, but I wasn't able to see the strace output unfortunately.
Will re-try again tonight.

The question here is if it all really worth the effort.  The thing is that
we cant prove anything either way, because if it were hanged in sleep() it
may be due to some OTHER program were in "bad" select() at that time, or
if strace showed it hanged in select(), it may be that some other part of
the system hanged at that time (but this is less likely still, as select()
timeframe is very small compared with sleep() timeframe).

Thanks!

/mjt
