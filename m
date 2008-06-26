Return-Path: <linux-kernel-owner+w=401wt.eu-S1759479AbYFZOiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479AbYFZOiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 10:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbYFZOh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 10:37:57 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:37159 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbYFZOhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 10:37:55 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Joe Peterson <joe@skyrush.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UTC timestamp option for FAT filesystems
References: <4861D685.4070308@skyrush.com> <87od5pqh4o.fsf@basil.nowhere.org>
	<4862DB28.3050001@skyrush.com> <48630286.2050006@skyrush.com>
	<87wskck5wi.fsf@devron.myhome.or.jp> <48639863.808@skyrush.com>
Date: Thu, 26 Jun 2008 23:37:49 +0900
In-Reply-To: <48639863.808@skyrush.com> (Joe Peterson's message of "Thu, 26
	Jun 2008 07:23:47 -0600")
Message-ID: <877iccxnwi.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Peterson <joe@skyrush.com> writes:

> Since the camera does not have a concept of time zone, the camera's
> clock, itself, would show UTC.  You are correct that one could, instead,
> choose an arbitrary time offset when setting the camera's clock, and if
> an option existed in Linux to always use this fixed offset on mount, the
> Linux timestamp could be correct in this case as well.

It means the timestamp of FAT on the camera is just wrong.

> However, there are some issues I see with choosing to do this:
>
> 1) It is more confusing than using UTC (the user, in essence, is
> defining a new absolute reference time similar to UTC but not UTC (and
> that matches his local time, at least for 1/2 the year).
>
> 2) If the user moves, either the camera and mount offset could be left
> at the "wrong" setting that would now be less meaningful than UTC, or
> the user could change both.
>
> 3) When the daylight saving time switch happens, the camera's time will
> now be wrong, even though the Linux time will still be OK - they will
> differ by 1 hour unless corrected.  If the camera could (and did) adjust
> for DST automatically, then this would give a bad Linux time and
> potentially go unnoticed until the fixed offset were corrected (note
> that my camera does not ever auto-adjust; I'm not sure if any can).
>
> So in cases 2 and 3, the user would end up needing to change the offset,
> perhaps twice a year.  This is one thing I am trying to avoid by just
> using UTC.  Using UTC as the "fixed offset" is the only one that makes
> sense in that if one is to choose some arbitrary "universal time", it
> might as well be UTC (and there are no DST issues with UTC).

Of course, UTC is right design for on disk format. But, this is FAT, the
writing UTC means you modified the design of FAT. It is not a correct
option, it is just a hack like I said, right?

However, I can accept that hack for many broken devices on realworld,
but, the modifying design is not right option. Do you see what I want
to say?

>> It will be specified the timezone of FAT on one disk. So, the timestamp
>> is right for specified timezone on Windows always, on Linux should be
>> always right...
>> 
>> No?
>
> Not really.  Here's an example:
>
> 1) Create a folder on FAT in Windows in winter at local 12:00
> 2) Create a folder on FAT in Windows in summer at local 12:00
> 3) Notice that in Windows, they both will read "12:00"
> 4) Mount the volume under Linux with the default "local time" behavior,
>    and you will notice the times are off by one hour (because Linux
>    adjusts both by the same offset in the kernel, but userland
>    correctly adjusts them differently due to different DST status)

Yes. And sys_tz is wrong and needs to fix.

> So, if one were to, instead of UTC, use an arbitrary "fixed" offset when
> mounting a FAT partition, the same issue would occur

Yes. To store localtime, complex one is needed.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
