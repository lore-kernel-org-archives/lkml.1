Return-Path: <linux-kernel-owner+w=401wt.eu-S1766681AbXCJLo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766681AbXCJLo3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 06:44:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752820AbXCJLo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 06:44:28 -0500
Received: from ns1.suse.de ([195.135.220.2]:54440 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819AbXCJLo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 06:44:26 -0500
Date: Sat, 10 Mar 2007 12:43:01 +0100
From: Stefan Seyfried <seife@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@suse.cz>, Johannes Stezenbach <js@linuxtv.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>, linux-pm@lists.osdl.org,
       lenb@kernel.org, linux-acpi@vger.kernel.org, luming.yu@intel.com,
       Arkadiusz Miskiewicz <arekm@maven.pl>,
       Konstantin Karasyov <konstantin.a.karasyov@intel.com>,
       Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net,
       Thomas Meyer <thomas.mey@web.de>, Meelis Roos <mroos@linux.ee>,
       Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>,
       Janosch Machowinski <jmachowinski@gmx.de>, vladimir.p.lebedev@intel.com,
       Ash Milsted <thatistosayiseenem@gawab.com>, dmitry.torokhov@gmail.com
Subject: Re: [2/6] 2.6.21-rc2: known regressions
Message-ID: <20070310114301.GA30554@suse.de>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015034.GG3441@stusta.de> <20070308123143.GF5149@mellanox.co.il> <Pine.LNX.4.64.0703080954220.10832@woody.linux-foundation.org> <20070308192554.GA2999@elte.hu> <20070308230705.GA4611@elte.hu> <Pine.LNX.4.64.0703081545110.10832@woody.linux-foundation.org> <20070309174821.GA31754@linuxtv.org> <20070309233508.GB2197@elf.ucw.cz> <20070310090121.GB15647@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070310090121.GB15647@elte.hu>
X-Operating-System: openSUSE 10.3 (i586) Alpha2, Kernel 2.6.20-9-default
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2007 at 10:01:21AM +0100, Ingo Molnar wrote:
> 
> * Pavel Machek <pavel@suse.cz> wrote:
> > s2ram should be able to work around this, it has parts from 
> > radeontool. (suspend.sf.net).
> 
> i'm wondering, do you have any idea how Windows handles the 
> suspend/resume quirks problem area? Do they "curse BIOS vendors and 
> maintain a large DB of DMI-driven exceptions", or do they perhaps have 
> some fundamentally better approach than us? If it's the former, then we 
> might as well try to bring more automatism (and more of your database) 
> into the kernel itself.

I think that in windows, you simply install the "HP nx$FOOBAR intel graphics
driver" on a nx$FOOBAR machine, and the "ASUS $FOOBAR ATI graphics driver"
on an ASUS $FOOBAR machine etc. Those drivers are mostly stock intel/ATI/
whoever drivers, but with the little bit of extra knowledge on how to wake
up the graphics chip.

And there is no console mode in Windows. If you restrict yourself to
"it works from X", many machines do not need workarounds.
 
> btw., the s2ram database seems quite a bit spotty:
> 
>  $ ./s2ram -n
>  Machine is unknown.
>  This machine can be identified by:
>      sys_vendor   = "System manufacturer"
>      sys_product  = "System Product Name"
>      sys_version  = "System Version"
>      bios_version = "ASUS A8N-E ACPI BIOS Revision 1008"
> 
>  $ ./s2ram -n
>  Machine is unknown.
>  This machine can be identified by:
>     sys_vendor   = "Hewlett-Packard "
>     sys_product  = "compaq nx9030 (PG630ET#ABD)       "
>     sys_version  = "Rev 1           "
>     bios_version = "F.15    "
>  See http://en.opensuse.org/S2ram for details.
> 
> even at the link above i didnt find any clear algorithm about how to 
> extend the quirks-list and the white-list - while i expect that most 
> people experience what i did: that s2ram doesnt know their boxes. 
> (otherwise they would not visit that URL at all i suspect)

Ok. To be honest, you are the first reporter that seems to have read the
documentation above, but not understood what to do.

So i'll put it into even simpler steps:

 - get the current version of s2ram
 - boot your system with init=/bin/bash, mount /proc and /sys
 - try the s2ram options in the combinations listed on the above page
 - as soon as you find an option that works, please retry it from a
   full booted system (including X)
 - if it still works, please report the options used and the output of
   "s2ram -n" to the suspend-devel mailinglist.

i might consider reworking the documentation if there are more reports
about problems with the procedure.
-- 
Stefan Seyfried

"Any ideas, John?"
"Well, surrounding them's out." 
