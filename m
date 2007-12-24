Return-Path: <linux-kernel-owner+w=401wt.eu-S1752847AbXLXVXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbXLXVXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 16:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbXLXVWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 16:22:51 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:54243 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbXLXVWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 16:22:50 -0500
Date: Mon, 24 Dec 2007 14:22:46 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Loic Prylli <loic@myri.com>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver opt-in issue
Message-ID: <20071224212246.GF1695@parisc-linux.org>
References: <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org> <476DDFEE.3010009@garzik.org> <alpine.LFD.0.9999.0712222034150.21557@woody.linux-foundation.org> <476DE98F.2010009@garzik.org> <476DF1A6.3060900@myri.com> <476DF5BE.5030004@garzik.org> <20071223110337.GA25441@jurassic.park.msu.ru> <alpine.LFD.0.9999.0712230925240.21557@woody.linux-foundation.org> <476F6047.50100@garzik.org> <alpine.LFD.0.9999.0712241036040.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712241036040.21557@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 24, 2007 at 10:51:22AM -0800, Linus Torvalds wrote:
> The *second* problem is entirely a kernel internal issue. It's the one 
> that causes us the biggest issues right now, but it's also the one that 
> will not impact user space at all once if is fixed. So once we do the 
> *early* probing using anything but mmconfig accesses, we can then much 
> more easily enable mmconfig later, and by the time the user does anything 
> like "lspci -vvvxxxx", we could do those mmconfig accesses.

I had a nice idea to fix this ... will post a patch to do that later.

> I also suspect that we *may* want to use a separate file for the extended 
> config. Right now, things like lspci read the config space by accessing 
> a file like
> 
> 	/sys/bus/pci/devices/0000:00:00.0/config
> 
> and I'm not at all sure we want to extend that one past the first 256 
> bytes of config space. Why? Because I don't want old programs that may not 
> know how dangerous the rest of the space is to read extended config space 
> by mistake when they don't know how to parse it anyway.

Unless we're talking about crazy, crazy programs that blindly open and
read every file in sysfs as root (yes, they exist, and they already cause
problems simply by reading past the first 64 bytes of config space which
causes problems for, eg, sym53c875 cards), non-root accesses are already
restricted to the first 64 bytes, so it's no more of a problem than it
currently is.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
