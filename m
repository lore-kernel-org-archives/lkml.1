Return-Path: <linux-kernel-owner+w=401wt.eu-S934063AbYD1Ne5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934063AbYD1Ne5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 09:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765843AbYD1Neu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 09:34:50 -0400
Received: from mail.windriver.com ([147.11.1.11]:54664 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763455AbYD1Neu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 09:34:50 -0400
Message-ID: <4815D275.40405@windriver.com>
Date: Mon, 28 Apr 2008 08:34:45 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kgdb over ethernet?
References: <alpine.LNX.1.10.0804251837410.20150@fbirervta.pbzchgretzou.qr> <481215B7.9020503@windriver.com> <alpine.LNX.1.10.0804261729140.20150@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0804261729140.20150@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Apr 2008 13:34:45.0751 (UTC) FILETIME=[9F62E070:01C8A934]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Friday 2008-04-25 19:32, Jason Wessel wrote:
>> Jan Engelhardt wrote:
>>> the DocBook files for the recently-merged kgdb mention kgdboe, as does
>>> the doc on kgdb.sf.net, but I do not see kgdboe anywhere in the source.
>>> Is oe actually merged? I'm kinda short on rs232...
>> Well if you have at least one you have enough because you can share kgdb
>> with the console.
>
> kgdb is running, though I wonder why breakpoints are not seemingly hit.
>
> (gdb) b vfs_readdir
> cBreakpoint 2 at 0xc0270c11: file fs/readdir.c, line 23.
> (gdb) c
> Continuing.
>
> Then I issued ls -l on tty1 (kgdb is on ttyS0), but it did not
> happen to stop at vfs_readdir, though I would assume vfs_readdir
> was entered as part of /bin/ls.
> Ideas?

I know very little about what vmware may or may not be doing here.

I tried your test with the tip of the kernel tree this morning with a
arch=i386 kernel and it seems to work fine on real HW and qemu.  You
might consider checking if the kgdb regression tests pass.  You can
change your .config to have:

CONFIG_KGDB_TESTS=y
CONFIG_KGDB_TESTS_ON_BOOT=y
CONFIG_KGDB_TESTS_BOOT_STRING="V1F100"

This will verify if the kgdb core is work correctly on your platform,
and if some part fails we can go from there.  Depending on if vmware
implements HW breakpoints the HW breakpoint tests could certainly
fail.  As an example, qemu does not implement HW breakpoints so those
particular tests always fail, but the failure does not kill the kernel
and the test suite simply moves on to the next test.

Jason.
