Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbZEQAPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbZEQAPw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 20:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388AbZEQAPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 20:15:42 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:62242 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbZEQAPm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 20:15:42 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0905161644350.3301@localhost.localdomain>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera> <alpine.LFD.2.01.0905161644350.3301@localhost.localdomain>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sun, 17 May 2009 02:15:20 +0200
Message-ID: <ac3eb2510905161715m7d42879bqdc0d59c465521e99@mail.gmail.com>
Subject: Re: 2.6.30-rc6: Reported regressions from 2.6.29
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 17, 2009 at 02:01, Linus Torvalds
<torvalds@linux-foundation.org> wrote:

>        [   10.428691] Error: Driver 'rtc_cmos' is already registered, aborting...
>
> but the driver doesn't really care whether that succeeded or not, but then
> the platform_driver_probe fails (because the thing is already in use), so
> then it ends up unregistering something that never got registered in the
> first place.
>
> I think this is strictly speaking a bug in driver_unregister(), which is
> too fragile. If you unregister a drivert that wasn't registered, we
> shouldn't oops.
>
> But we could certainly do it at the rtc-cmos.c level too, and just not
> unregister it if the registration failed. My gut feel is that we should
> aim for the core driver helpers to be less fragile, though - we'll always
> have driver bugs.

In:
 driver_remove_file()
we try to access the private part:
 sysfs_remove_file(&drv->p->kobj, ...
and that is NULL, for an unregistered driver, I would expect.

I'm looking into it.

Kay
