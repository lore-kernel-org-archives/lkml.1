Return-Path: <linux-kernel-owner+w=401wt.eu-S1751845AbYANFFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbYANFFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 00:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750732AbYANFFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 00:05:40 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35490 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbYANFFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 00:05:39 -0500
Date: Sun, 13 Jan 2008 21:05:01 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: tcamuso@redhat.com
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <greg@kroah.com>,
       Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Loic Prylli <loic@myri.com>,
       Prarit Bhargava <prarit@redhat.com>,
       "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>,
       "Schoeller, Patrick (Linux - Houston, TX)" <Patrick.Schoeller@hp.com>,
       Bhavana Nagendra <bnagendr@redhat.com>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
Message-ID: <20080113210501.4584e4d2@laptopd505.fenrus.org>
In-Reply-To: <478AD713.8060204@redhat.com>
References: <alpine.LFD.1.00.0801111224090.3148@woody.linux-foundation.org>
	<alpine.LFD.1.00.0801111311170.3148@woody.linux-foundation.org>
	<20080111211753.GR18741@parisc-linux.org>
	<alpine.LFD.1.00.0801111326120.3148@woody.linux-foundation.org>
	<20080111213803.GS18741@parisc-linux.org>
	<20080111235856.GA16079@jurassic.park.msu.ru>
	<20080112002638.GA18710@kroah.com>
	<20080112144030.GA19279@jurassic.park.msu.ru>
	<20080112094557.71f5382a@laptopd505.fenrus.org>
	<20080112214911.GA20102@jurassic.park.msu.ru>
	<20080112150120.05f93768@laptopd505.fenrus.org>
	<47895767.3090503@redhat.com>
	<20080112164006.6f6f7bc2@laptopd505.fenrus.org>
	<47896B3B.2000108@redhat.com>
	<20080112204248.29abb1dd@laptopd505.fenrus.org>
	<478A075F.7010503@redhat.com>
	<20080113090311.0a9a1db5@laptopd505.fenrus.org>
	<478A8268.6020107@redhat.com>
	<20080114005434.48340f84@lxorguk.ukuu.org.uk>
	<20080113173331.617ac935@laptopd505.fenrus.org>
	<478AD713.8060204@redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jan 2008 22:29:23 -0500
Tony Camuso <tcamuso@redhat.com> wrote:

> . There is no need to provide different PCI config access
>    mechanisms at device granularity, since the PCI config access
>    mechanism between the CPU and the Northbridge is opaque to
>    the devices. PCI config mechanisms only need to differ at
>    the Northbridge level.

This ignores the "lets make it not matter for the 99% of the users" case.
> 
> . If the system is capable of conf1, then PCI config access
>    at offsets < 256 should be confined to conf1. This solution
>    is most effective for existing and legacy systems.

not "conf1" but "what the platform thinks is the best method for < 256".

We have this nice abstraction for the platform to select the best method... we should use it.

And still, it's another attempt to get this fixed (well.. it's been 2 years in the coming so far, maybe this will
be the last one, maybe it will not be... we'll see I suppose, but it sucks to be a user who doesn't 
need any of the functionality that the extended config space provides in theory but gets to suffer more of the issues)

I'm all in favor of making this more reliable, but really..
we've thought it was fixed time and time again over the last two years. Please consider
limiting the scope of the damage as well.




-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
