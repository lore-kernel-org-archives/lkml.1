Return-Path: <linux-kernel-owner+w=401wt.eu-S933257AbXCLHWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257AbXCLHWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 03:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933535AbXCLHWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 03:22:11 -0400
Received: from ns2.suse.de ([195.135.220.15]:56876 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933257AbXCLHWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 03:22:08 -0400
Date: Mon, 12 Mar 2007 07:34:09 +0100
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
Message-ID: <20070312063409.GA30551@suse.de>
References: <20070308192554.GA2999@elte.hu> <20070308230705.GA4611@elte.hu> <Pine.LNX.4.64.0703081545110.10832@woody.linux-foundation.org> <20070309174821.GA31754@linuxtv.org> <20070309233508.GB2197@elf.ucw.cz> <20070310090121.GB15647@elte.hu> <20070310114301.GA30554@suse.de> <20070310151804.GA10627@elte.hu> <20070310220810.GF2758@elf.ucw.cz> <20070311082002.GA4013@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070311082002.GA4013@elte.hu>
X-Operating-System: openSUSE 10.3 (i586) Alpha2, Kernel 2.6.20-9-default
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2007 at 09:20:02AM +0100, Ingo Molnar wrote:
> 
> * Pavel Machek <pavel@suse.cz> wrote:
> > Unfortunately, these tend to crash the box when you pass wrong 
> > options, and I do not see easy way to test "can user see whats on 
> > display" automatically.
> 
> you could perhaps try what X's modesetting utility does: display a 
> dialog box that times out if it does not get clicked on, and reboot if 
> it did not get clicked on. Likewise, detect upon the next bootup that a 
> suspend-test was in progress (and didnt get back via normal resume), via 
> some temporary file. That way both the 'did not resume and i had to 
> power-cycle' and the 'resume did not restore my X' problems can be 
> handled.
> 
> Finally, when the correct options have been established (worse-case with 
> a small number of reboots and "yes, indeed the resume did not work fine" 
> clicks done upon bootup by the user), automatically fill in a webform in 
> firefox and ask the user to do a single click to submit that form.

There is ongoing work to make something like this happen, but it will
take some time (very probably the whitelist will end up in a HAL fdi-file
which gives the additional advantage that interested vendors can supply a
linux-"driver" for their notebooks which makes suspend "just work" (the
"driver" simply being a .fdi-file that lists the workaround for this
particular machine)

> techniques like that have more chance i think to get Linux 
> suspend/resume anywhere near to working. The current 'rely on the 
> developer' technique apparently does not work.

It is not too bad actually, i seem to be getting lots of whitelist
entries from people that are first time shell users, and i usually
walk them through the process in just one or two mails. But yes, it
does not scale well ;-)

I was already thinking about some more sophisticated "wildcard" matching,
something like "if it is a HP and it has an ATI gfx chip, and we do
not have an exact match, then do VBE_POST|VBE_MODE" or similar, which
would probably get many machines working fine (it turns out that almost
all new machines from a vendor with similar hardware need similar
workarounds, but for example the hp's with ATI need different quirks
than the hp's with intel. Only thinkpads seem to almost universally work
with s3_bios,s3_mode, with some x86_64 models being the exception).
Something like that should be pretty easy once the whitelist is kept
in HAL.
-- 
Stefan Seyfried

"Any ideas, John?"
"Well, surrounding them's out." 
