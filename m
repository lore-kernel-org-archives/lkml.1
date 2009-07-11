Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbZGKVMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbZGKVMa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 17:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754266AbZGKVMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 17:12:23 -0400
Received: from senator.holtmann.net ([87.106.208.187]:52932 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201AbZGKVMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 17:12:22 -0400
Subject: Re: rfkill rework in 2.6.31-rc, hal/dbus access changes?
From: Marcel Holtmann <marcel@holtmann.org>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <20090711195911.GA31549@gamma.logic.tuwien.ac.at>
References: <20090711091427.GB14367@gamma.logic.tuwien.ac.at>
	 <1247338473.9709.107.camel@localhost.localdomain>
	 <20090711195911.GA31549@gamma.logic.tuwien.ac.at>
Content-Type: text/plain
Date: Sat, 11 Jul 2009 14:12:25 -0700
Message-Id: <1247346745.9709.129.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Norbert,

> > > - formerly writing 0 or 1 to /sys/class/rfkill/rfkillN/state worked, now
> > >   it returns access denied.
> > 
> > actually Johannes sent a patch to fix this. It will still return an
> > error if the RFKILL switch is hard-blocked btw.
> 
> I found that and have just now rebooted into -rc2 with this patch
> applied, and yes, it works again.
> 
> > > - access via Hal/Dbus (what I am doing) stopped working, too
> > 
> > Not the first time HAL broke in this area, because its RFKILL support is
> > a bunch of hacked up scripts. Send a patch to the HAL mailing list.
> 
> Indeed *with* Johannes' patch also HAL/Dbus access works again, so I
> don't have to dig into that again. Probably at the end of the line both
> hal and sys access to the state file ended up in the same dead end which
> was fixed by the patch.
> 
> So thanks, Johannes, all fine now.
> 
> > You could just go ahead and work on fixing HAL.
> 
> That is far out of my abilities, I was happy to hack a gnome applet in
> python using hal/dbus, that fine.
> 
> > The /dev/rfkill interface is the only way to get a proper interface with
> 
> But reading from that file directly is not a piece of cake, at least I
> haven't seen any specification of the format. I have downloaded the
> rfkill user space utility and will try to use that one instead, but that
> makes it more difficult due to access permission gamble.

There is no gamble with the access permission. Unix access permission
are quite clear. Actually the sysfs state file here is the gamble since
you don't know what you get. Actually HAL has no idea what happened
after writing to that file. Either is it soft-block, hard-block, did it
work or even when the RFKILL is active.

Also the specification is in the rfkill.h header file including what you
can expect. It can't be simpler than poll/read/write.

> So, /dev/rfkill and the rfkill user mode program is the way to go?

Yes that is the way to go.

Regards

Marcel


