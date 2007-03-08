Return-Path: <linux-kernel-owner+w=401wt.eu-S1161274AbXCHXzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161274AbXCHXzG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 18:55:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161268AbXCHXzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 18:55:05 -0500
Received: from smtp.osdl.org ([65.172.181.24]:43628 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161227AbXCHXzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 18:55:01 -0500
Date: Thu, 8 Mar 2007 15:49:17 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: "Michael S. Tsirkin" <mst@mellanox.co.il>, Adrian Bunk <bunk@stusta.de>,
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
In-Reply-To: <20070308230705.GA4611@elte.hu>
Message-ID: <Pine.LNX.4.64.0703081545110.10832@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
 <20070305015034.GG3441@stusta.de> <20070308123143.GF5149@mellanox.co.il>
 <Pine.LNX.4.64.0703080954220.10832@woody.linux-foundation.org>
 <20070308192554.GA2999@elte.hu> <20070308230705.GA4611@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Mar 2007, Ingo Molnar wrote:
> 
> disabling the following radeonfb options in the .config made resume work 
> again:

In general, don't even *try* to use radeonfb for suspend/resume.

I don't think it has ever worked, except on some very rare laptops 
(largely PPC Macs) where people had enough information to set up the 
PLL's.

I don't think the other framebuffer drivers are much better.

You're better off using the VGA console, and lettign X re-initialize the 
graphics device. That generally at least has a reasonably good chance of 
working.

Re-initializing graphics modes really is very hard. You can try with the 
BIOS video hack (I forget the kernel command line to turn it on), but we 
really do end up depending on X doing it better.

Some day we may have modesetting support in the kernel for some graphics 
hw, right now it's pretty damn spotty.

		Linus
