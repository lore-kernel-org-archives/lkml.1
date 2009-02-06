Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbZBFG71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbZBFG71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 01:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbZBFG7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 01:59:19 -0500
Received: from serv04.lahn.de ([213.239.197.57]:57435 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbZBFG7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 01:59:18 -0500
Date: Fri, 6 Feb 2009 07:59:12 +0100
From: Philipp Matthias Hahn <pmhahn@titan.lahn.de>
To: Yinghai Lu <yinghai@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Ayaz Abdulla <aabdulla@nvidia.com>, Jeff Garzik <jeff@garzik.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: Re: WOL with forcedeth broken since
	f55c21fd9a92a444e55ad1ca4e4732d56661bf2e
Message-ID: <20090206065912.GA3614@pmhahn.de>
Mail-Followup-To: Yinghai Lu <yinghai@kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Yinghai Lu <yhlu.kernel@gmail.com>,
	Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Ayaz Abdulla <aabdulla@nvidia.com>, Jeff Garzik <jeff@garzik.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jeff Garzik <jgarzik@redhat.com>
References: <86802c440901292253ie9e2a9dmb4580a3da1480c81@mail.gmail.com> <20090205232343.GA9455@pmhahn.de> <200902060113.31651.rjw@sisk.pl> <a47yn9c9JrF.A.hz.L5YiJB@chimera> <20090129063118.GA3586@pmhahn.de> <CGyEB0S4BpO.A.MFB.R5YiJB@chimera> <86802c440901292253ie9e2a9dmb4580a3da1480c81@mail.gmail.com> <20090205232343.GA9455@pmhahn.de> <86802c440902051535n118339bes88ae48a54ce4711a@mail.gmail.com> <20090206053320.GA4369@pmhahn.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090206053320.GA4369@pmhahn.de>
Organization: UUCP-Freunde Lahn e.V.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again!

On Fri, Feb 06, 2009 at 06:33:20AM +0100, Philipp Matthias Hahn wrote:
> Just this morning I had to use the reverted address to wake up my
> desktop PC after 6 hours of poweroff.

I did some structured tesing:

1. WOL does _not_ work at all when I do:
	(grub) boot into initrd
	(initrd) modprobe forcedeth
	(initrd) ethtool -s eth0 wol g
*	(initrd) poweroff

2. WOL does _not_ work at all when I do:
	(grub) boot into initrd
	(initrd) modprobe forcedeth
	(initrd) ethtool -s eth0 wol g
*	(initrd) Alt-SysRq-O

3. WOL works using the _un-reversed_ MAC when I do:
	(grub) boot into initrd
	(initrd) modprobe forcedeth
	(initrd) ethtool -s eth0 wol g
*	(initrd) Alt-SysRq-B
*	(grub) halt

4. WOL works using the _reversed_ MAC when I do:
	(grub) boot into initrd
	(initrd) modprobe forcedeth
	(initrd) ethtool -s eth0 wol g
	(initrd) exit
*	(Debian) poweroff

If I do the poweroff from linux (either initrd or Debian), forcedeth
seems to display some messages just before poweroff. I'll try to get
hands on a Serial-USB-Converter and a NULL-modem-cable to capture it,
since my laptop is legacy-free :-(

BYtE
Philipp Hahn

PS: initrd is actually initramfs, before somebody wonders.
-- 
  / /  (_)__  __ ____  __ Philipp Hahn
 / /__/ / _ \/ // /\ \/ /
/____/_/_//_/\_,_/ /_/\_\ pmhahn@titan.lahn.de
