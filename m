Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbYFZPqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbYFZPqG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 11:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbYFZPpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 11:45:54 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:47023 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbYFZPpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 11:45:54 -0400
Message-ID: <4863B9AF.4080105@skyrush.com>
Date: Thu, 26 Jun 2008 09:45:51 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080620)
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UTC timestamp option for FAT filesystems
References: <4861D685.4070308@skyrush.com> <87od5pqh4o.fsf@basil.nowhere.org>	<4862DB28.3050001@skyrush.com> <48630286.2050006@skyrush.com>	<87wskck5wi.fsf@devron.myhome.or.jp> <48639863.808@skyrush.com> <877iccxnwi.fsf@devron.myhome.or.jp>
In-Reply-To: <877iccxnwi.fsf@devron.myhome.or.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi wrote:
>> Since the camera does not have a concept of time zone, the camera's
>> clock, itself, would show UTC.  You are correct that one could, instead,
>> choose an arbitrary time offset when setting the camera's clock, and if
>> an option existed in Linux to always use this fixed offset on mount, the
>> Linux timestamp could be correct in this case as well.
> 
> It means the timestamp of FAT on the camera is just wrong.

I am not sure what you mean.

> Of course, UTC is right design for on disk format. But, this is FAT, the
> writing UTC means you modified the design of FAT. It is not a correct
> option, it is just a hack like I said, right?

I do not consider this modifying the design of FAT.  FAT does not have
the concept of time zone, DST, or UTC.  It is just a date/time (stamped
on the volume with no info about what that means).  It is customary to
say these times are in local time, and Windows happens to use it as if
it's straight local time (Linux tries to emulate this).  But using FAT
to store UTC instead is not changing the design, it is just using it
differently.  I agree this would not be a good idea when sharing a
volume with Windows, but for cameras, e.g., why not?

I do see what you are saying, in that the semantics of using FAT imply
using local time, but I'm not sure this is reason enough to not allow
someone to adjust how they use the timestamps.  After all, if someone in
Iceland, Morocco, or Algeria writes a file to a FAT filesystem using
Windows, those timestamps *will* be equivalent to UTC.  There is an
inherent problem with using local time anyway (since someone receiving a
disk has no idea which time zone was used when writing the file), so I'm
not sure why it would be wrong to adjust how a particular volume is used.

> However, I can accept that hack for many broken devices on realworld,
> but, the modifying design is not right option. Do you see what I want
> to say?

If it is a hack (and I do not consider it to be so), I still do not see
why the utc option is a design change - how else would you get the
desired behavior?

> Yes. And sys_tz is wrong and needs to fix.

I agree it would be good to fix this, but it is probably not trivial,
and this is a completely independent issue (even if it were fixed,
things like dealing with DST or moving around with a camera are still
problematic).

Also, as I understand it, sys_tz is obsolete, but is still used for
these legacy things, meaning a new way to flag something as "local time"
should probably be used ultimately to fix the sys_tz issue.

>> So, if one were to, instead of UTC, use an arbitrary "fixed" offset when
>> mounting a FAT partition, the same issue would occur
> 
> Yes. To store localtime, complex one is needed.

Right, and I see that as a separate issue.  Back to your original point,
I do not see that letting a user specify a "fixed" arbitrary offset has
any advantage.

Summary: I believe it would be nice if the current local time mode were
fixed to match Windows behavior, but it would also be handy to have the
utc option for situations where that has advantages.

						-Joe
