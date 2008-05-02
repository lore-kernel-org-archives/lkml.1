Return-Path: <linux-kernel-owner+w=401wt.eu-S935334AbYEBPiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935334AbYEBPiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759250AbYEBPiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:38:16 -0400
Received: from mail.AKNET.ru ([77.246.241.226]:50269 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490AbYEBPiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:38:15 -0400
Message-ID: <481B355B.9040200@aknet.ru>
Date: Fri, 02 May 2008 19:38:03 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Linux kernel <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: patch	driver-core-warn-about-duplicate-driver-names-on-the-same-bus.patch
 added to gregkh-2.6 tree
References: <12094266793898@kroah.org>	<4816A888.9000802@aknet.ru>	<20080429045849.GA6348@suse.de>	<s5habjdvt6z.wl%tiwai@suse.de>	<481776EA.5010200@aknet.ru>	<s5h7ief7sw3.wl%tiwai@suse.de>	<4818B057.4080803@aknet.ru> <s5hk5ic3ilu.wl%tiwai@suse.de>
In-Reply-To: <s5hk5ic3ilu.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Takashi Iwai wrote:
> And this won't work in most cases.  People don't want to replace the
> existing pcspkr driver with snd-pcsp.  They don't want to load the
> sound subsystem on their systems just because of beep.
Why should they? They may just stick with
pcspkr driver if they want.

> If you compare pcspkr.c and pcsp_input.c, it's found that the only
> essential difference is the additional check at the head of the event
> handler:
> 	if (atomic_read(&pcsp_chip.timer_active) || !pcsp_chip.pcspkr)
> 		return 0;
> If this can be added dynamically to input pcspkr.c, no big point to
> have duped codes.
Another point is PM callbacks. Somehow
snd-pcsp will have to register them with
pcspkr.

> Distros usually make input-pcspkr as built-in, not as module.
> So, snd-pcsp is practically unusable on standard kernels of major
> distros as is, unfortunately...
Oh, that's really bad, I didn't know
they do. For what reason? And how then
people disable the beeps?
Btw, could you please name a few? At
least Fedora has it as a module.

OK, I'll see about using pcspkr.c. But
it looks like the needed hooks won't be
too small (call to disable the beeps and
a call to register the PM callbacks) and
unlikely to be accepted upstream...
