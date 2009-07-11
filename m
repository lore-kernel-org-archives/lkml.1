Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbZGKT7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbZGKT7l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 15:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbZGKT7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 15:59:31 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:49448 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbZGKT7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 15:59:31 -0400
Date: Sat, 11 Jul 2009 21:59:11 +0200
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
Subject: Re: rfkill rework in 2.6.31-rc, hal/dbus access changes?
Message-ID: <20090711195911.GA31549@gamma.logic.tuwien.ac.at>
References: <20090711091427.GB14367@gamma.logic.tuwien.ac.at> <1247338473.9709.107.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247338473.9709.107.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcel, hi all,

On Sa, 11 Jul 2009, Marcel Holtmann wrote:
> > - formerly writing 0 or 1 to /sys/class/rfkill/rfkillN/state worked, now
> >   it returns access denied.
> 
> actually Johannes sent a patch to fix this. It will still return an
> error if the RFKILL switch is hard-blocked btw.

I found that and have just now rebooted into -rc2 with this patch
applied, and yes, it works again.

> > - access via Hal/Dbus (what I am doing) stopped working, too
> 
> Not the first time HAL broke in this area, because its RFKILL support is
> a bunch of hacked up scripts. Send a patch to the HAL mailing list.

Indeed *with* Johannes' patch also HAL/Dbus access works again, so I
don't have to dig into that again. Probably at the end of the line both
hal and sys access to the state file ended up in the same dead end which
was fixed by the patch.

So thanks, Johannes, all fine now.

> You could just go ahead and work on fixing HAL.

That is far out of my abilities, I was happy to hack a gnome applet in
python using hal/dbus, that fine.

> The /dev/rfkill interface is the only way to get a proper interface with

But reading from that file directly is not a piece of cake, at least I
haven't seen any specification of the format. I have downloaded the
rfkill user space utility and will try to use that one instead, but that
makes it more difficult due to access permission gamble.

So, /dev/rfkill and the rfkill user mode program is the way to go?

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
FROLESWORTH (n.)
Measure. The minimum time it is necessary to spend frowning in deep
concentration at each picture in an art gallery in order that everyone
else doesn't think you've a complete moron.
			--- Douglas Adams, The Meaning of Liff
