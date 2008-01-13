Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbYAMSmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbYAMSmX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 13:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbYAMSmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 13:42:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34570 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbYAMSmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 13:42:11 -0500
Date: Sun, 13 Jan 2008 10:41:24 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Loic Prylli <loic@myri.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <greg@kroah.com>,
       Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Tony Camuso <tcamuso@redhat.com>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
Message-ID: <20080113104124.022cd0a5@laptopd505.fenrus.org>
In-Reply-To: <478A5727.3000102@myri.com>
References: <alpine.LFD.1.00.0801111156230.3148@woody.linux-foundation.org>
	<20080111201716.GO18741@parisc-linux.org>
	<alpine.LFD.1.00.0801111224090.3148@woody.linux-foundation.org>
	<20080111204228.GP18741@parisc-linux.org>
	<alpine.LFD.1.00.0801111311170.3148@woody.linux-foundation.org>
	<20080111211753.GR18741@parisc-linux.org>
	<alpine.LFD.1.00.0801111326120.3148@woody.linux-foundation.org>
	<20080111213803.GS18741@parisc-linux.org>
	<20080111235856.GA16079@jurassic.park.msu.ru>
	<20080112002638.GA18710@kroah.com>
	<20080112144030.GA19279@jurassic.park.msu.ru>
	<20080112094557.71f5382a@laptopd505.fenrus.org>
	<478A5727.3000102@myri.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jan 2008 13:23:35 -0500
Loic Prylli <loic@myri.com> wrote:

Matthew pointed a patch that basically does what you suggested; only one comment on your mail left after that:

> 
> 2) the pci_enable_ext_config() function and dev->ext_cfg_space field, 
> sysfs interface should be removed from the patch.  There has never
> been a problem reporting crashes or any undefined behaviour while
> trying to access ext-conf-space, all the problems where *using
> mmconfig to access legacy-conf-space*.


This entirely misses the point of why I made the patch. The point is NOT
that devices are buggy. The point is that right now, 99.99% of the machines
out there do NOT need extended config space (no matter how it gets accessed),
yet at the same time they suffered from it's issues for... what 2 years now?
The point of my patch was to make people who don't need extended config space,
not have to deal with it anymore.

Note: There is not a 100% overlap between "need" and "will not be used in 
the patches that use legacy for < 256". In the other patches posted, 
extended config space will be used in cases where it won't be with my 
patch. (Most obvious one is an "lspci -vx" from automated scripts). 
Is  that a problem? We've had 2 years of mess, with one not-enough patch after another.
There still are problems TODAY (eg im 2.6.24-rc7). The patch that falls back
to an alternative method for below 256 is no doubt a step in the right direction. 
(although I'm not all that happy about mixing access types, it's not provably incorrect)
Is it enough? I'm not sure. Only time can tell I suppose, but the risk side is that
if it is not enough, users who don't need the extended config space for functionality
will suffer the bugs AGAIN.

So in short, my approach was NOT about "fix PCI", it is about "fix the user experience".
It's a stopgap for sure, until the underlying mechanism gets reliable. It's been 2 years.....
maybe this next step is "it", maybe it isn't.

