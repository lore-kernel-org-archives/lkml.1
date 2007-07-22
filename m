Return-Path: <linux-kernel-owner+w=401wt.eu-S1759531AbXGVO2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531AbXGVO2T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 10:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbXGVO2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 10:28:12 -0400
Received: from tim.rpsys.net ([194.106.48.114]:45591 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbXGVO2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 10:28:10 -0400
Subject: Re: MMC/SD Root filesystem suspend/resume problems
From: Richard Purdie <rpurdie@rpsys.net>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20070722160534.3ccfc8f9@poseidon.drzeus.cx>
References: <1184860419.29634.10.camel@localhost.localdomain>
	 <20070719190309.28708be8@poseidon.drzeus.cx>
	 <1185110313.6819.8.camel@localhost.localdomain>
	 <20070722160534.3ccfc8f9@poseidon.drzeus.cx>
Content-Type: text/plain
Date: Sun, 22 Jul 2007 15:28:00 +0100
Message-Id: <1185114480.6819.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-22 at 16:05 +0200, Pierre Ossman wrote:
> On Sun, 22 Jul 2007 14:18:33 +0100
> Richard Purdie <rpurdie@rpsys.net> wrote:
> > I enabled the MMC_UNSAFE_RESUME option and the problems I was seeing
> > was "fixed". I think having this option is a bad idea (in its current
> > form) as it doesn't actually stop filesystem corruption.
> > 
> > With the option disabled, if a filesystem is mounted when you suspend
> > my tests show the filesystem is corrupted. At least if the option is
> > enabled, the filesystem is only corrupted if you remove the card
> > whilst suspended which is more preferable.
> 
> I disagree. With this option you get silent corruption, without you get
> noisy corruption. And I would always prefer the latter, even if it
> increases the risk of it happening.

Corruption is corruption and it shouldn't happen if we can avoid it. It
happens with complete certainty in one case and only happens in the
other if the user does something which is a fairly obvious bad idea
(which is documented as such).

> > I guess the solution would be to abort the suspend if mounted systems
> > were detected and the option was disabled? Alternatively the option
> > could be "auto" enabled only for mounted systems maybe with a printk
> > warning?
> 
> This is a general problem for all removable/hotpluggable storage. So
> sticking it in the MMC block device would be the wrong layer IMO.

It is however if the MMC layer is going to add Kconfig options which
corrupt things, it can add things to start fixing things too. If those
things can be adapted into more generic code paths, so much the better.

> Until the filesystems can be made to store something sane on disk
> before the suspend, I'd say this is best handled in user space. Let the
> user space tools refuse to initiate the suspend as long as any
> removable devices are mounted.

Given I can suspend the device with "echo mem > /sys/power/state", that
implies we need to fix echo? ;-)

> > Of course the best solution would be to have filesystems support
> > suspend/resume requests since other subsystems like pcmcia also suffer
> > this problem and would benefit from this but I accept that teaching
> > filesystems this is more difficult.
> > 
> 
> Doesn't mean we shouldn't do it. 

Agreed.

> And if we keep papering over the problems, you reduce the motivation
> of fixing this properly.

Maybe although I don't like existing functionality being broken even if
its less than ideal.

Regards.

Richard

