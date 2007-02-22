Return-Path: <linux-kernel-owner+w=401wt.eu-S1945932AbXBVBKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945932AbXBVBKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 20:10:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945931AbXBVBKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 20:10:50 -0500
Received: from tim.rpsys.net ([194.106.48.114]:58182 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932935AbXBVBKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 20:10:48 -0500
Subject: Re: no backlight on radeon after recent kernel "upgrade"s
From: Richard Purdie <rpurdie@rpsys.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Alex Romosan <romosan@sycorax.lbl.gov>,
       Yaroslav Halchenko <kernel@onerussian.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net,
       James Simmons <jsimmons@infradead.org>
In-Reply-To: <20070222005122.GA7928@khazad-dum.debian.net>
References: <20070219044616.GC25659@washoe.onerussian.com>
	 <20070219000412.acad13de.akpm@linux-foundation.org>
	 <1171876788.6046.3.camel@localhost.localdomain>
	 <877iub9mu2.fsf@sycorax.lbl.gov>
	 <1172097718.5790.29.camel@localhost.localdomain>
	 <20070221231706.GA3336@khazad-dum.debian.net>
	 <1172103159.5790.45.camel@localhost.localdomain>
	 <20070222005122.GA7928@khazad-dum.debian.net>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 01:10:16 +0000
Message-Id: <1172106616.5790.90.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 22:51 -0200, Henrique de Moraes Holschuh wrote:
> On Thu, 22 Feb 2007, Richard Purdie wrote:
> > I have a thinkpad with Intel GM graphics ;-). I need it to work so I try
> > not to experiment too much on it. I've just tried the ibm-acpi driver
> > and it doesn't work well :-(.
> 
> 2.6.21-rc, or 2.6.20? 

2.6.21-rc1

> If it is in 2.6.21, could you give me a report of how
> it fares on 2.6.20?

Maybe next week. I'm away over the weekend and I need it working now ;-).

> > * 'echo 0 > brightness' lowered the intensity but by a level or two, not
> > set it to level 0. A couple of more attempts and it did jump from 7 -> 1
> > and so on, it seems erratic.
> 
> I know it used to work fine before 2.6.20.  Let me check...  works fine on a
> T43, 2.6.20 (Radeon X300).  I need more data to fix it :-)

The following sequence is reproducible:

echo 7 > brightness (repeat until actual_brightness reads 7)
echo 0 > brightness (brightness reads 0, actual_brightness reads 4)
echo 0 > brightness (brightness reads 0, actual_brightness reads 0)

I suspect this is interference from software on the machine as it does
show an onscreen display when I change the values in sysfs and the
values on the OSD don't match what's really going on.  The
actual_brightness does match the screen.

I guess this just means we need to get userspace to agree on one method
of access for this kind of thing. It makes me wondering where the
hardware brightness keys fit into things though...

> > actual_brightness always seems to be correct, as does brightness so it
> > looks like its not updating the hardware correctly.
> 
> Well, if you have the ACPI video module loaded, unload it.  Does it work
> now?

No change if unloaded.

Cheers,

Richard

