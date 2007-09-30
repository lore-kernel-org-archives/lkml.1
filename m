Return-Path: <linux-kernel-owner+w=401wt.eu-S1758754AbXI3RzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754AbXI3RzE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 13:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758030AbXI3Ryz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 13:54:55 -0400
Received: from ara.aytolacoruna.es ([212.51.63.12]:53123 "EHLO
	mx.aytolacoruna.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758024AbXI3Ryz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 13:54:55 -0400
Date: Sun, 30 Sep 2007 19:54:46 +0200
From: Santiago Garcia Mantinan <manty@manty.net>
To: Mark Lord <lkml@rtr.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] (repost) Fix SMP poweroff hangs
Message-ID: <20070930175446.GA2472@pul.manty.net>
References: <46FC20B7.4000606@rtr.ca> <200709281455.29069.rjw@sisk.pl> <46FD001A.3070309@rtr.ca> <200709281544.30497.rjw@sisk.pl> <46FD05B8.2040302@rtr.ca> <46FD0724.5060009@rtr.ca> <1190991316.18681.38.camel@chaos> <46FD5BAF.8040304@rtr.ca> <20070930090032.GA2405@pul.manty.net> <46FFDB29.9040400@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FFDB29.9040400@rtr.ca>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'd say your problem is more of a distro issue,
> in that the method you are using to shutdown
> is not actually requesting "poweroff".

> That last mess above ("System halted.") comes from kernel_halt(),
> rather than the expected message ("Power down.") from kernel_power_off().

> So, try using the "poweroff" command instead of "halt",
> or try using "halt -p".  If neither of those work,

Well it works ok with 2.6.22 powering off and saying so right before
powering off, with some references to ACPI. On 2.6.23-rc8 however it doesn't
seem to get that far.

I have followed the poweroff of my distro (Debian unstable) and on getting
to the end of rc 0 it calls halt with options -d -f -i -p. So it does call
it with the -p you asked for. BTW, this halt comes fom Debian's sysvinit
version 2.86.ds1-38.1 in case that matters, but as I said it is working ok
for .22.


> then edit /etc/init.d/halt and hardcode the "-p" parameter
> inside there onto the "halt" command line(s).

That init.d/halt is the one that is calling halt with -d -f -i -p already.

Regards...
-- 
Manty/BestiaTester -> http://manty.net
