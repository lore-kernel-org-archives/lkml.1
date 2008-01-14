Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbYANQCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbYANQCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 11:02:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbYANQCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 11:02:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42348 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbYANQCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 11:02:33 -0500
Date: Mon, 14 Jan 2008 08:01:50 -0800
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
Message-ID: <20080114080150.23ace331@laptopd505.fenrus.org>
In-Reply-To: <478B7E62.9070700@redhat.com>
References: <alpine.LFD.1.00.0801111224090.3148@woody.linux-foundation.org>
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
	<20080113210501.4584e4d2@laptopd505.fenrus.o! rg>
	<478B5D0D.7060808@redhat.com>
	<20080114064614.22081ff3@laptopd505.fenrus.org>
	<478B7E62.9070700@redhat.com>
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

On Mon, 14 Jan 2008 10:23:14 -0500
Tony Camuso <tcamuso@redhat.com> wrote:

> Arjan van de Ven wrote:
> > On Mon, 14 Jan 2008 08:01:01 -0500
> > Tony Camuso <tcamuso@redhat.com> wrote:
>  >>
> >> If we're going to differentiate MMCONFIG from
> >> some other access mechanism, it only needs to be done at the
> >> Northbridge level. Devices are electrically ignorant of the
> >> protocol used between CPU and Northbridge to get the Northbridge
> >> to assert config cycles on the bus.
> > 
> > Again this is about having systems that don't need extended config
> > space not use it. At all. The only way to do that is have the
> > drivers say they need it, and not use it otherwise. It has NOTHING
> > to do with how things are wired up. It's pure a kernel level policy
> > decision about whether to use extended config space AT ALL.
> > 
> 
> The problem with compelling device drivers to determine the PCI
> config mechanism is that it must be forced upon arches that
> have no PCI configuration quirks or don't even use the same
> PCI config mechanisms as x86.

it's not pci_enable_mmconf(), it's pci_enable_extended_config_space... it's independent of the mechanism!

> 
> I don't think that's a good policy.
> 
> Better to confine arch-specific quirks to the arch-specific code
> whenever possible.
> 


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
