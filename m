Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbXFYTtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbXFYTtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 15:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbXFYTtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 15:49:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46677 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbXFYTtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 15:49:17 -0400
Subject: Re: [PATCH 1/2] [RESEND] PCI: read revision ID by default
From: Arjan van de Ven <arjan@infradead.org>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       grundler@parisc-linux.org, davem@davemloft.net, davej@redhat.com
In-Reply-To: <46800E35.9030209@intel.com>
References: <20070625031918.4711.2705.stgit@localhost.localdomain>
	 <20070625100109.35b4c327@the-village.bc.nu>  <46800E35.9030209@intel.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 25 Jun 2007 12:48:29 -0700
Message-Id: <1182800909.2696.3.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-25 at 11:49 -0700, Kok, Auke wrote:
> Alan Cox wrote:
> > On Sun, 24 Jun 2007 20:19:18 -0700
> > Auke Kok <auke-jan.h.kok@intel.com> wrote:
> > 
> >> Currently there are 97 occurrences where drivers need the pci
> >> revision ID. We can do this once for all devices. Even the pci
> >> subsystem needs the revision several times for quirks. The extra
> >> u8 member pads out nicely in the pci_dev struct.
> >>
> >> Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
> > 
> > Seems worth caching yes. Care needed changing the other uses however
> > that the revision isn't changeable on the hardware in some magic fashion.
> 
> if that happens the device could also change pci ID... I don't think we can 
> guard against that kind of abuse anyway. While this is perfectly possible (e.g. 
> network cards carrying this info in their eeproms), we should still be OK with 
> the core patch, but the device driver itself needs to pull the information 
> manually from the device using the pci_get_config_byte() method.


the other thing btw is that this approach allows us to use quirks and
the like to fix up "crap".

Maybe a good rule-of-thumb (and as with any other rule of thumb there
are exceptions): Drivers should NEVER touch the standard part of PCI
config space without going through a specific PCI layer API for the
value they want.



