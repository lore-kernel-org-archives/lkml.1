Return-Path: <linux-kernel-owner+w=401wt.eu-S1030872AbXCHXI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030872AbXCHXI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 18:08:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030874AbXCHXI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 18:08:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38947 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030872AbXCHXIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 18:08:55 -0500
Date: Fri, 9 Mar 2007 00:07:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Michael S. Tsirkin" <mst@mellanox.co.il>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>, pavel@suse.cz,
       linux-pm@lists.osdl.org, lenb@kernel.org, linux-acpi@vger.kernel.org,
       luming.yu@intel.com, Arkadiusz Miskiewicz <arekm@maven.pl>,
       Konstantin Karasyov <konstantin.a.karasyov@intel.com>,
       Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net,
       Thomas Meyer <thomas.mey@web.de>, Meelis Roos <mroos@linux.ee>,
       Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>,
       Janosch Machowinski <jmachowinski@gmx.de>, vladimir.p.lebedev@intel.com,
       Ash Milsted <thatistosayiseenem@gawab.com>, dmitry.torokhov@gmail.com,
       linux-input@atrey.karlin.mff.cuni.cz,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [2/6] 2.6.21-rc2: known regressions
Message-ID: <20070308230705.GA4611@elte.hu>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015034.GG3441@stusta.de> <20070308123143.GF5149@mellanox.co.il> <Pine.LNX.4.64.0703080954220.10832@woody.linux-foundation.org> <20070308192554.GA2999@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070308192554.GA2999@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> Thomas found a new twist to this today: applying the patch below 
> (which turns on ATA_DEBUG) made the SATA problem go away on his 
> laptop. Michael, could you try this patch, does it change the behavior 
> of your laptop in any way?

Here's another suspend/resume artifact: one of my boxes wouldnt resume, 
it hangs at:

[    1.456633] pci 0000:00:18.2: resuming
[    1.456641] pci 0000:00:18.3: resuming
[    1.456648] 8139too 0000:05:07.0: resuming
[    1.456667] radeonfb 0000:01:00.0: resuming

the box is pingable but otherwise no console and it's hung as well. [I 
got the log above via netconsole]

disabling the following radeonfb options in the .config made resume work 
again:

 CONFIG_FB_RADEON=y
 CONFIG_FB_RADEON_I2C=y
 CONFIG_FB_RADEON_BACKLIGHT=y

	Ingo
