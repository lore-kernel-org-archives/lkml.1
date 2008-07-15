Return-Path: <linux-kernel-owner+w=401wt.eu-S1761525AbYGOTNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761525AbYGOTNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756707AbYGOTNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:13:32 -0400
Received: from hpsmtp-eml17.kpnxchange.com ([213.75.38.117]:5307 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758475AbYGOTNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:13:31 -0400
From: Frans Pop <elendil@planet.nl>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel, use it in more drivers.
Date: Tue, 15 Jul 2008 21:13:27 +0200
User-Agent: KMail/1.9.9
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Linus Torvalds <torvalds@linux-foundation.org>, jeff@garzik.org,
       arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080715180535.GA6080@khazad-dum.debian.net> <1216146057.27455.325.camel@shinybook.infradead.org>
In-Reply-To: <1216146057.27455.325.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807152113.28762.elendil@planet.nl>
X-OriginalArrivalTime: 15 Jul 2008 19:13:29.0126 (UTC) FILETIME=[DD484C60:01C8E6AE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 July 2008, David Woodhouse wrote:
> On Tue, 2008-07-15 at 15:05 -0300, Henrique de Moraes Holschuh wrote:
> > I believe I read in the previous thread that some distros are already
> > using /lib/firmware/<kernel version>/.
> >
> > There was also the suggestion of moving the entire set of
> > kernel-packaged firmware to /lib/modules/<kernel version>/firmware,
> > probably while keeping /lib/firmware as a second place to look for
> > firmware so that we don't hose any system.
>
> You can do that right now; I expect Ubuntu will, since their userspace
> already looks like that. You just need to set $(INSTALL_FW_PATH) when
> you install the firmware (or modules).

With the disclaimer that I really haven't researched this all that much I 
think we'll end up finding that a multi-level model is needed.

Something like:
- /lib/firmware: intended for externally provided firmware and local
  overrides; try to load from there first (version checks may fail)
- /lib/modules/firmware: not sure if this level is necessary, but
  could be useful for e.g. firmware for out-of-tree drivers
- /lib/modules/$kver/firmware or
  /lib/modules/$kver/$modulepath: firmware built (and possibly packaged
  together with the kernel

Some scheme like this would introduce at least some sanity when it comes 
to keeping control of what is installed and provided (and may therefore 
be removed) by what and to avoid the question "how the hell did that file 
get there and do I still actually need it with my current kernels?".

It sounds to me like $(INSTALL_FW_PATH) is a good start, but maybe even 
too flexible as it does not define a standard: it allows user spaces of 
different distros to diverge which at some point will create its own 
nightmares.
It's also not flexible enough as it only supports a single location for 
firmware while clearly there can be different sources of firmware.

Cheers,
FJP
