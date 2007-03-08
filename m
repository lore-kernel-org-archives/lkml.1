Return-Path: <linux-kernel-owner+w=401wt.eu-S1752414AbXCHSLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbXCHSLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 13:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbXCHSLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 13:11:21 -0500
Received: from smtp.osdl.org ([65.172.181.24]:56689 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413AbXCHSLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 13:11:20 -0500
Date: Thu, 8 Mar 2007 10:01:45 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Michael S. Tsirkin" <mst@mellanox.co.il>
cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
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
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [2/6] 2.6.21-rc2: known regressions
In-Reply-To: <20070308123143.GF5149@mellanox.co.il>
Message-ID: <Pine.LNX.4.64.0703080954220.10832@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
 <20070305015034.GG3441@stusta.de> <20070308123143.GF5149@mellanox.co.il>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[ Eric, Ingo, can you double-check the timer initialization after resume? 
  We appear to have several reports of date not advancing, and while this 
  could be some SATA issue, it could easily be a timer tick issue too ]

On Thu, 8 Mar 2007, Michael S. Tsirkin wrote:
> 
> Here's the status with -rc3: better, but still does not work as well as 2.6.20.

Ok. I think we mostly solved the irq-related stuff, but you might want to 
check whether you have CONFIG_NOHZ on or off and whether that makes a 
difference.

> 2. First disk access after resume takes a couple of minutes
>    (seemed instant with 2.6.20) during this time no new messages show on console

Yeah, there is some problem with SATA resume. It would be beautiful if the 
people who actually see this could narrow it down with bisection. "It 
works for me" is clearly the case for many people, but not all.

But before blaming SATA, check if you have NO_HZ enabled and whether 
disabling that makes it work ok. If timeouts don't work right (or are 
*extremely* slow) things that should be instant won't be.

> 3. When I switch to X (CTRL-ALT-F7), X hangs after drawing a couple of windows
>    after waiting for some 10 min, I rebooted.
>    no new messages showed up in /var/log/messages

I think this is likely just more of the disk being buggered, but it could 
again be related to NO_HZ (people report time not advancing, and that 
would make any X timeout taking forever, and you'd see exactly your 
behaviour).

		Linus
