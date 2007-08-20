Return-Path: <linux-kernel-owner+w=401wt.eu-S1756607AbXHTKBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607AbXHTKBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 06:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbXHTKBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 06:01:36 -0400
Received: from smtp-101-monday.noc.nerim.net ([62.4.17.101]:4264 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751448AbXHTKBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 06:01:35 -0400
Date: Mon, 20 Aug 2007 12:02:58 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_SUSPEND and power consumption
Message-ID: <20070820120258.7d090cc4@hyperion.delvare>
In-Reply-To: <200708192242.43819.rjw@sisk.pl>
References: <20070819153259.2c96b904@hyperion.delvare>
	<200708192242.43819.rjw@sisk.pl>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Sun, 19 Aug 2007 22:42:43 +0200, Rafael J. Wysocki wrote:
> On Sunday, 19 August 2007 15:32, Jean Delvare wrote:
> > Hi all, hi Rafael,
> > 
> > Running kernel 2.6.23-rc3-git1, I noticed yesterday that my CPU (AMD
> > Sempron 2600+) was running at a much lower temperature when
> > CONFIG_SUSPEND was enabled.
> 
> Hm, interesting.
> 
> > The temperature difference was quite significant, about 6 degrees Celsius at
> > idle. Measuring the power consumption of my system confirmed that the energy
> > savings were real: with CONFIG_SUSPEND=n, the system consumes 80 W of power
> > (idle), while with CONFIG_SUSPEND=y, the system consumes only 69 W (idle)!
> > Can anyone explain how this works?
> 
> I can't.
> 
> > I didn't expect CONFIG_SUSPEND to make any difference before actually
> > switching the system to standby or suspend state.
> 
> Yes, that's the expected behavior.
> 
> > I tried the same trick on two Intel motherboards I use for testing, but
> > this option didn't seem to make any difference in the power consumption
> > for these.
> 
> Do you have CONFIG_HIBERNATION set?  If not, please see if setting it instead
> of CONFIG_SUSPEND leads to the same result on the affected box (ie. running
> at lower temperatures).

I've made some more tests. More importantly, the additional power
consumption comes from my (new) external hard disk drive. When it's not
connected, the system consume 69 W at idle, regardless of the config
options.

I guess that the drive was being autosuspended (by CONFIG_USB_SUSPEND)
only when CONFIG_SUSPEND was set. But as I found that my drive never
comes back from autosuspend, it's now blacklisted, and my system
consumes 80 W again even with CONFIG_SUSPEND=y.

If I rmmod "ehci-hcd" then the power consumption is back to 69 W. This
confirms that this is really USB-related. I have to admit that I did
not expect an external drive to eat that much power from the system,
especially when not used. I am told that VIA chips are notoriously bad
at this kind of things. I'll try the same external drive on an Intel
system later today.

The last mystery remaining is how USB "activity" can cause my CPU to
heat. I would expect the south bridge to heat, not the CPU.

Thanks,
-- 
Jean Delvare
