Return-Path: <linux-kernel-owner+w=401wt.eu-S1767453AbXCIS1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767453AbXCIS1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 13:27:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767456AbXCIS1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 13:27:07 -0500
Received: from allen.werkleitz.de ([80.190.251.108]:60846 "EHLO
	allen.werkleitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbXCIS1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 13:27:05 -0500
X-Greylist: delayed 2118 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Mar 2007 13:27:04 EST
Date: Fri, 9 Mar 2007 18:48:21 +0100
From: Johannes Stezenbach <js@linuxtv.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <20070309174821.GA31754@linuxtv.org>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015034.GG3441@stusta.de> <20070308123143.GF5149@mellanox.co.il> <Pine.LNX.4.64.0703080954220.10832@woody.linux-foundation.org> <20070308192554.GA2999@elte.hu> <20070308230705.GA4611@elte.hu> <Pine.LNX.4.64.0703081545110.10832@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703081545110.10832@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 87.162.102.116
Subject: Re: [2/6] 2.6.21-rc2: known regressions
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on allen.werkleitz.de)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2007, Linus Torvalds wrote:
> On Fri, 9 Mar 2007, Ingo Molnar wrote:
> > 
> > disabling the following radeonfb options in the .config made resume work 
> > again:
> 
> In general, don't even *try* to use radeonfb for suspend/resume.
> 
> I don't think it has ever worked, except on some very rare laptops 
> (largely PPC Macs) where people had enough information to set up the 
> PLL's.
> 
> I don't think the other framebuffer drivers are much better.
> 
> You're better off using the VGA console, and lettign X re-initialize the 
> graphics device. That generally at least has a reasonably good chance of 
> working.
> 
> Re-initializing graphics modes really is very hard. You can try with the 
> BIOS video hack (I forget the kernel command line to turn it on), but we 
> really do end up depending on X doing it better.

acpi_sleep=s3_bios has always worked for me on my ThinkPad T42p.

Even if one doesn't use the fb console at all, radeonfb apparently
is still required on some ThinkPad models to work around BIOS bugs:

http://www.thinkwiki.org/wiki/Problem_with_high_power_drain_in_ACPI_sleep#Radeon_GPU_not_powered_off


Johannes
