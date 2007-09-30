Return-Path: <linux-kernel-owner+w=401wt.eu-S1758450AbXI3RVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450AbXI3RVy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 13:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756910AbXI3RVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 13:21:47 -0400
Received: from rtr.ca ([76.10.145.34]:4716 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756898AbXI3RVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 13:21:46 -0400
Message-ID: <46FFDB29.9040400@rtr.ca>
Date: Sun, 30 Sep 2007 13:21:45 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Santiago Garcia Mantinan <manty@manty.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] (repost) Fix SMP poweroff hangs
References: <46FC20B7.4000606@rtr.ca> <200709281455.29069.rjw@sisk.pl> <46FD001A.3070309@rtr.ca> <200709281544.30497.rjw@sisk.pl> <46FD05B8.2040302@rtr.ca> <46FD0724.5060009@rtr.ca> <1190991316.18681.38.camel@chaos> <46FD5BAF.8040304@rtr.ca> <20070930090032.GA2405@pul.manty.net>
In-Reply-To: <20070930090032.GA2405@pul.manty.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Santiago Garcia Mantinan wrote:
> Doesn't fix for me!
> 
> I have an Athlon x2 running on a Asus A8N-E mobo which has an NForce 4
> chipset, I thought this patch would fix poweroff for me too, but it doesn't.
> 
> I'm seing this on 2.6.23-rc8 with and without your patch, here is what I get
> on the console:
> 
> Shutdown: hdd
> Shutdown: hda
> System halted.
> 
> Nothing else pops up.

I'd say your problem is more of a distro issue,
in that the method you are using to shutdown
is not actually requesting "poweroff".

That last mess above ("System halted.") comes from kernel_halt(),
rather than the expected message ("Power down.") from kernel_power_off().

So, try using the "poweroff" command instead of "halt",
or try using "halt -p".  If neither of those work,
then edit /etc/init.d/halt and hardcode the "-p" parameter
inside there onto the "halt" command line(s).

I had to do that frequently back in the Redhat/Fedora days.
I'm sure they have a nice GUI for it somewhere,
but at the time it was simpler to just edit the script.

Cheers
