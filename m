Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbYFZCog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbYFZCog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 22:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbYFZCo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 22:44:26 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:43382 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbYFZCo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 22:44:26 -0400
Message-ID: <48630286.2050006@skyrush.com>
Date: Wed, 25 Jun 2008 20:44:22 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080620)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UTC timestamp option for FAT filesystems
References: <4861D685.4070308@skyrush.com> <87od5pqh4o.fsf@basil.nowhere.org> <4862DB28.3050001@skyrush.com>
In-Reply-To: <4862DB28.3050001@skyrush.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Peterson wrote:
>> Also even if it worked it seems very limited. If you do that why not
>> have an option to set an arbitary time zone offset?
> 
> Yes, I thought about also providing an option that lets the user specify the
> offset at mount - this may be useful for other scenarios (like moving Windows
> disks between time zones), but the UTC option, itself, is very useful in that it
> let's one use UTC on FAT devices, which is the least problematic way to do
> things (e.g. for digital cameras, etc.).

After thinking about this some more, I actually do not see much point in
allowing an arbitrary offset on FAT.  Only two modes make sense: local
time (current default) and UTC (new proposed option).  Here's the
reason: in "local time" mode (the default in Linux and Windows), a FAT
filesystem records just that to the disk: local time.  For example, on
Windows, it doesn't matter which time zone is in use; a file written at
12:00 will still show a time of 12:00 even if the time zone is changed
on the system.  If a user with a Windows laptop travels around, changing
the time zone, files saved at noon in one time zone will appear to have
the same time when in another.  This does not make sense in a "real
time" sense (it would be possible, for example, to have a file written
later but with an earlier timestamp if the user crosses a time zone
boundary to the west (and sets the time zone) just before saving the
second file).  Such a typical traveling Windows user will have files
saved in many different time zones, so there would be no meaning to
setting an arbitrary time zone offset when mounting such a volume.  The
files on the volume would just have to considered stamped in "local
time", wherever the user happened to be.

Linux's implementation of FAT "local time" mode does this as well.  It
simply adds to a timestamp exactly what the userland level will subtract
when displaying the time, making that timestamp appear as it is
numerically on the disk, in local time.

So FAT filesystem timestamps make sense in one of two modes for a given
volume: local time or UTC.  The former handles volumes used under
Windows well, and the latter would be extremely useful for other devices
which use FAT filesystems but need to have a more sensible "real" time
format (like, as I pointed out, digital cameras).

						-Joe
