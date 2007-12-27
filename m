Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbXL0TuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbXL0TuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 14:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbXL0TuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 14:50:05 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60604 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbXL0TuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 14:50:03 -0500
Date: Thu, 27 Dec 2007 11:47:32 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
Message-ID: <20071227114732.1442829e@laptopd505.fenrus.org>
In-Reply-To: <4773E7FB.2020000@shaw.ca>
References: <fa.m7tRTz/ymu3iMyLTO2aF1Tvaw24@ifi.uio.no>
	<fa.XrRLIuL4juNAXXaMPF3iY8FyWW8@ifi.uio.no>
	<fa.gv3MUHxQvd7EaG/0hhC9IzBvIlA@ifi.uio.no>
	<4773E7FB.2020000@shaw.ca>
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

On Thu, 27 Dec 2007 11:59:23 -0600
Robert Hancock <hancockr@shaw.ca> wrote:

> Arjan van de Ven wrote:
> >> 2) [non-minor] hmmmm.
> >>
> >> 	[jgarzik@core ~]$ lspci -n | wc -l
> >> 	23
> >>
> >> So I would have to perform 23 sysfs twiddles, before I could
> >> obtain a full and unabridged 'lspci -vvvxxx'?
> > 
> > not you as human, but "lspci" ought to yes.
> > 
> >> For the userspace interface, the most-often-used knob for
> >> diagnostic purposes will be the easiest one.  And that's
> > 
> > the easiest one is an option to lspci. Nothing more nothing less.
> > 
> > Making a global knob in kernel space is a lot more tricky, and in
> > addition really there's enough cases where userspace wants the one
> > device anyway Doing the "for each device I'm about to dump" in
> > lspci is pretty much as hard as doing the global one (if not
> > simpler)
> 
> So then if you have a system where MMCONFIG doesn't work and you're
> not using any devices that require extended config space, then doing
> lspci -vvvxxx will blow up the machine? Yuck.

ONLY in the case where you would have otherwise blown up at boot.
Lets face it; blowing up if the admin does "lspci -vvvxxx" with a clear 
message in dmesg about which device was enabled last is BY FAR preferable 
over just plain not booting.

In all cases where the kernel knows MMCONFIG is broken, no amount of pci_enable_ext_config()
(from drivers or sysfs) will enable MMCONFIG.

> 
> Still don't like this approach. It seems like (partially) covering up 
> problems rather than solving them.

It's containing them not so much covering. To the point that it becomes diagnosable
and that users have working systems by default.

> 


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
