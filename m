Return-Path: <linux-kernel-owner+w=401wt.eu-S1753730AbZBFFdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbZBFFdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 00:33:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbZBFFdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 00:33:24 -0500
Received: from serv04.lahn.de ([213.239.197.57]:36036 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbZBFFdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 00:33:23 -0500
Date: Fri, 6 Feb 2009 06:33:20 +0100
From: Philipp Matthias Hahn <pmhahn@titan.lahn.de>
To: Yinghai Lu <yinghai@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Ayaz Abdulla <aabdulla@nvidia.com>, Jeff Garzik <jeff@garzik.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: Re: WOL with forcedeth broken since
	f55c21fd9a92a444e55ad1ca4e4732d56661bf2e
Message-ID: <20090206053320.GA4369@pmhahn.de>
Mail-Followup-To: Yinghai Lu <yinghai@kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Yinghai Lu <yhlu.kernel@gmail.com>,
	Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Ayaz Abdulla <aabdulla@nvidia.com>, Jeff Garzik <jeff@garzik.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jeff Garzik <jgarzik@redhat.com>
References: <a47yn9c9JrF.A.hz.L5YiJB@chimera> <86802c440901292253ie9e2a9dmb4580a3da1480c81@mail.gmail.com> <20090205232343.GA9455@pmhahn.de> <200902060113.31651.rjw@sisk.pl> <a47yn9c9JrF.A.hz.L5YiJB@chimera> <20090129063118.GA3586@pmhahn.de> <CGyEB0S4BpO.A.MFB.R5YiJB@chimera> <86802c440901292253ie9e2a9dmb4580a3da1480c81@mail.gmail.com> <20090205232343.GA9455@pmhahn.de> <86802c440902051535n118339bes88ae48a54ce4711a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902060113.31651.rjw@sisk.pl> <86802c440902051535n118339bes88ae48a54ce4711a@mail.gmail.com>
Organization: UUCP-Freunde Lahn e.V.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Fri, Feb 06, 2009 at 01:13:30AM +0100, Rafael J. Wysocki wrote:
...
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12614
> > > Subject		: WOL with forcedeth broken since f55c21fd9a92a444e55ad1ca4e4732d56661bf2e
...
> > Strage, at the moment I can't seem to reproduce the problem. I've
> > switched back to the version of 2.6.28.3 and now it seems to work.
> > I'll continue with tesing.
> 
> OK, but for now I'll close the bug as unreproducible.

Just this morning I had to use the reverted address to wake up my
desktop PC after 6 hours of poweroff.

Yesterdays tests were domething like the following:
	Grub: Linux "loglevel=9 ignore_loglevel break=modules"
	dmesg -c > /dev/null
	modprobe forcedeth
	dmesg
	ethtool -s eth0 wol g
	echo NMAC > /proc/acpi/wakeup
	reboot to Grub using Alt-SysRq-B
	Grub: "halt"
I have to reboot back to Grub, since doing a "poweroff" from initrd or
pressing Alt-SysRq-O seems to turn of WOL.

...
> The "echo NMAC > /proc/acpi/wakeup" thing shouldn't be necessary if you do
> "ethtool -s eth0 wol g".

Will try.

On Thu, Feb 05, 2009 at 03:35:25PM -0800, Yinghai Lu wrote:
> > Nether the less here's the output of dmesg:
> >        forcedeth: Reverse Engineered nFoce ethernet driver. Version 0.61.
> >        ACPI: PCI Interrupt Link [LMAC] enables at IRQ 23
> >        forcedeth: 0000:00:14.0: PCI INT A -> Link[LMAC] -> GSI 23 (level, low) -> IRQ 23
> >        forcedeth: 0000:00:14.0: setting latency timer to 64
> > *       nv_probe: MAC_ADDR_REV ELSE
> >        nv_probe: set workaround bit for reversed mac addr
> 
> that means your BIOS doesn't reverse mac addr.
> this is the one for new BIOS or old BIOS?

This is the new BIOS.

BYtE
Philipp Hahn
-- 
  / /  (_)__  __ ____  __ Philipp Hahn
 / /__/ / _ \/ // /\ \/ /
/____/_/_//_/\_,_/ /_/\_\ pmhahn@titan.lahn.de
