Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbYFYX4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbYFYX4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 19:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbYFYX4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 19:56:31 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:50912 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbYFYX4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 19:56:30 -0400
Message-ID: <4862DB28.3050001@skyrush.com>
Date: Wed, 25 Jun 2008 17:56:24 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071119)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UTC timestamp option for FAT filesystems
References: <4861D685.4070308@skyrush.com> <87od5pqh4o.fsf@basil.nowhere.org>
In-Reply-To: <87od5pqh4o.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> The time zone handling seems racy. e.g. consider the case DST 
> changes on that day. You convert before the switch over 
> and suddenly the time offset is different.

Are you saying that the tz code is racy in general (I saw the following thread
that you responded to as well):

	http://marc.info/?l=linux-kernel&m=115954057716441&w=2

Or are you saying that the proposed "utc" option makes things racy?

All the "utc" option does (with this patch) is disable application of the
kernel's "tz_minuteswest" offset, so using it actually should remove races with
a DST switch, right?

> I'm actually not sure someone in user space is even updating the kernel
> idea of the timezone for DST on a switch (generally it was assumed it's some
> obsolete BSD concept and that all real programs only use the 
> user space glibc implementation that knows all the rules). So 
> DST might not be supported at all.

I am not sure about that either (i.e. whether tz_minuteswest is altered on DST
changes or if it is only changed at boot).

And I think you are right that the kernel's idea of timezone (i.e.
"tz_minuteswest") is basically obsolete ("man gettimeofday" talks about this).

> Also even if it worked it seems very limited. If you do that why not
> have an option to set an arbitary time zone offset?

Yes, I thought about also providing an option that lets the user specify the
offset at mount - this may be useful for other scenarios (like moving Windows
disks between time zones), but the UTC option, itself, is very useful in that it
let's one use UTC on FAT devices, which is the least problematic way to do
things (e.g. for digital cameras, etc.).

						-Joe
