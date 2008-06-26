Return-Path: <linux-kernel-owner+w=401wt.eu-S1760580AbYFZSCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760580AbYFZSCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758531AbYFZSCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:02:07 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:56727 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756505AbYFZSCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:02:04 -0400
Message-ID: <4863CC89.9070705@skyrush.com>
Date: Thu, 26 Jun 2008 11:06:17 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080620)
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UTC timestamp option for FAT filesystems
References: <4861D685.4070308@skyrush.com> <87od5pqh4o.fsf@basil.nowhere.org>	<4862DB28.3050001@skyrush.com> <48630286.2050006@skyrush.com>	<87wskck5wi.fsf@devron.myhome.or.jp> <48639863.808@skyrush.com>	<877iccxnwi.fsf@devron.myhome.or.jp> <4863B9AF.4080105@skyrush.com> <87zlp8w4br.fsf@devron.myhome.or.jp>
In-Reply-To: <87zlp8w4br.fsf@devron.myhome.or.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi wrote:
> I think we agreed to fix sys_tz is good thing.

Yep, but doesn't have to be fixed before adding a new option, since they
are separate issues and uses, I think.

> If so, I'd like to see "tz=xxx" or something for the future, instead of
> "utc", don't you think so? I really hate to add the random options.

Can you help be to understand what "tz=xxx" (if not =0) would be good
for?  It seems to me that either you want the "local time" functionality
(which deals, to a degree, with DST, in which case you use the existing
behavior) or you use tz=0 (which is the same as utc).

If someone were to, say, set "tz=-7", it would not work correctly with a
camera or with a Windows-written volume.

For a camera, since DST is not taken into account.  If you really want
to set your camera to local time and are willing to accept the inherent
issues, why not just use local time FAT behavior as it is now in Linux.

If you are talking about using a Windows FAT partition in a different
time zone, setting tz=xxx would not help either, since all files are
just written in local time whichever time zone the person was in (the
traveling laptop example).  Again, the only solution in that case is to
use the default local time behavior.

So, which cases benefit from tz=xxx that would not benefit from utc
(which is eseentially tz=0)?

					-Joe
