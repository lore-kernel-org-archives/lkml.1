Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbZBEXX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbZBEXX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 18:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbZBEXXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 18:23:49 -0500
Received: from serv04.lahn.de ([213.239.197.57]:45830 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761AbZBEXXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 18:23:48 -0500
Date: Fri, 6 Feb 2009 00:23:43 +0100
From: Philipp Matthias Hahn <pmhahn@titan.lahn.de>
To: Yinghai Lu <yhlu.kernel@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Ayaz Abdulla <aabdulla@nvidia.com>, Jeff Garzik <jeff@garzik.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: Re: WOL with forcedeth broken since
	f55c21fd9a92a444e55ad1ca4e4732d56661bf2e
Message-ID: <20090205232343.GA9455@pmhahn.de>
Mail-Followup-To: Yinghai Lu <yhlu.kernel@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Ayaz Abdulla <aabdulla@nvidia.com>, Jeff Garzik <jeff@garzik.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jeff Garzik <jgarzik@redhat.com>
References: <a47yn9c9JrF.A.hz.L5YiJB@chimera> <CGyEB0S4BpO.A.MFB.R5YiJB@chimera> <20090129063118.GA3586@pmhahn.de> <86802c440901292253ie9e2a9dmb4580a3da1480c81@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CGyEB0S4BpO.A.MFB.R5YiJB@chimera> <86802c440901292253ie9e2a9dmb4580a3da1480c81@mail.gmail.com>
Organization: UUCP-Freunde Lahn e.V.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Thu, Jan 29, 2009 at 10:53:40PM -0800, Yinghai Lu wrote:
> can not find the reason why the WOL doesn't work...
> 
> please post
> 1. boot log for just after AC is pluged-in... ===> you should have
> "nv_probe: set workaround bit for reversed mac addr"
> 2. and boot log after boot from WOL...==> you have have "nv_probe: set
> workaround bit for reversed mac addr" too.

On Wed, Feb 04, 2009 at 11:58:53AM +0100, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12614
> Subject		: WOL with forcedeth broken since f55c21fd9a92a444e55ad1ca4e4732d56661bf2e
> Submitter	: Philipp Matthias Hahn <pmhahn@titan.lahn.de>
> Date		: 2009-01-29 6:31 (7 days old)
> References	: http://marc.info/?l=linux-kernel&m=123321232825316&w=4
> Handled-By	: Yinghai Lu <yinghai@kernel.org>
> Patch		: http://marc.info/?l=linux-kernel&m=123330459229248&w=4

Strage, at the moment I can't seem to reproduce the problem. I've
switched back to the version of 2.6.28.3 and now it seems to work.
I'll continue with tesing.

Some additional data:
The BIOS-upgrade tool (Afud408.exe) resets the MAC address. I had to run
the tool a second time to re-programm the MAC-address using its /M
option. I useed the unreversed MAC-address back than.
I also tried the reversed address once, but after that forcedeth.c
complained about a wrong MAC-address.

If I completely turn off the power (pull the plug), WOL doesn't work,
even when it's enabled in the BIOS.

Only after I'v started Linux, do "echo NMAC > /proc/acpi/wakeup" and
"ethtool -s eth0 wol g" does it work again.

Nether the less here's the output of dmesg:
        forcedeth: Reverse Engineered nFoce ethernet driver. Version 0.61.
        ACPI: PCI Interrupt Link [LMAC] enables at IRQ 23
        forcedeth: 0000:00:14.0: PCI INT A -> Link[LMAC] -> GSI 23 (level, low) -> IRQ 23
        forcedeth: 0000:00:14.0: setting latency timer to 64
*       nv_probe: MAC_ADDR_REV ELSE
        nv_probe: set workaround bit for reversed mac addr
        forcedeth: 0000:00:14.0: ifname eth0, PHY OUI 0x732 @ 1, addr 00:19:db:f2:e1:35
        forcedeth: 0000:00:14.0: highdma pwrctl timirq gbit lnktim desc-v3
The line maked * was inserted by me in the source file for my debugging.

BYtE
Philipp Hahn
-- 
  / /  (_)__  __ ____  __ Philipp Hahn
 / /__/ / _ \/ // /\ \/ /
/____/_/_//_/\_,_/ /_/\_\ pmhahn@titan.lahn.de
