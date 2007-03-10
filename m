Return-Path: <linux-kernel-owner+w=401wt.eu-S1751457AbXCJJC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbXCJJC5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 04:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbXCJJC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 04:02:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60651 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbXCJJCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 04:02:52 -0500
Date: Sat, 10 Mar 2007 10:01:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@suse.cz>
Cc: Johannes Stezenbach <js@linuxtv.org>,
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
       Ash Milsted <thatistosayiseenem@gawab.com>, dmitry.torokhov@gmail.com,
       linux-input@atrey.karlin.mff.cuni.cz,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [2/6] 2.6.21-rc2: known regressions
Message-ID: <20070310090121.GB15647@elte.hu>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015034.GG3441@stusta.de> <20070308123143.GF5149@mellanox.co.il> <Pine.LNX.4.64.0703080954220.10832@woody.linux-foundation.org> <20070308192554.GA2999@elte.hu> <20070308230705.GA4611@elte.hu> <Pine.LNX.4.64.0703081545110.10832@woody.linux-foundation.org> <20070309174821.GA31754@linuxtv.org> <20070309233508.GB2197@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309233508.GB2197@elf.ucw.cz>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@suse.cz> wrote:

> > Even if one doesn't use the fb console at all, radeonfb apparently 
> > is still required on some ThinkPad models to work around BIOS bugs:
> > 
> > http://www.thinkwiki.org/wiki/Problem_with_high_power_drain_in_ACPI_sleep#Radeon_GPU_not_powered_off
> 
> 
> s2ram should be able to work around this, it has parts from 
> radeontool. (suspend.sf.net).

i'm wondering, do you have any idea how Windows handles the 
suspend/resume quirks problem area? Do they "curse BIOS vendors and 
maintain a large DB of DMI-driven exceptions", or do they perhaps have 
some fundamentally better approach than us? If it's the former, then we 
might as well try to bring more automatism (and more of your database) 
into the kernel itself.

btw., the s2ram database seems quite a bit spotty:

 $ ./s2ram -n
 Machine is unknown.
 This machine can be identified by:
     sys_vendor   = "System manufacturer"
     sys_product  = "System Product Name"
     sys_version  = "System Version"
     bios_version = "ASUS A8N-E ACPI BIOS Revision 1008"

 $ ./s2ram -n
 Machine is unknown.
 This machine can be identified by:
    sys_vendor   = "Hewlett-Packard "
    sys_product  = "compaq nx9030 (PG630ET#ABD)       "
    sys_version  = "Rev 1           "
    bios_version = "F.15    "
 See http://en.opensuse.org/S2ram for details.

even at the link above i didnt find any clear algorithm about how to 
extend the quirks-list and the white-list - while i expect that most 
people experience what i did: that s2ram doesnt know their boxes. 
(otherwise they would not visit that URL at all i suspect)

	Ingo
