Return-Path: <linux-kernel-owner+w=401wt.eu-S1757070AbYLPQA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070AbYLPQA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 11:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758449AbYLPQAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 11:00:42 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:33877 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757939AbYLPQAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 11:00:41 -0500
Date: Tue, 16 Dec 2008 16:00:12 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: JosephChan@via.com.tw, linux-kernel@vger.kernel.org
Subject: Re: [Patch 2/3] via-sdmmc: via-sdmmc.c
Message-ID: <20081216160012.GE12431@fluff.org.uk>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB808520F3B@exchtp03.taipei.via.com.tw> <200812161431.42387.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812161431.42387.arnd@arndb.de>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 02:31:42PM +0100, Arnd Bergmann wrote:
> On Tuesday 16 December 2008, JosephChan@via.com.tw wrote:
> > VIA MSP SD/MMC card reader driver of via-sdmmc
> 
> The code looks very nice, good work.
> 
> > +static void via_save_pcictrlreg(struct via_crdr_chip *vcrdr_chip)
> > +{
> > +	struct pcictrlreg *pm_pcictrl_reg;
> > +	void __iomem *addrbase;
> > +
> > +	pm_pcictrl_reg = &(vcrdr_chip->pm_pcictrl_reg);
> > +	addrbase = vcrdr_chip->pcictrl_mmiobase;
> > +
> > +	pm_pcictrl_reg->pciclkgat_reg = readb(addrbase + PCICLKGATT_REG);
> > +	pm_pcictrl_reg->pciclkgat_reg |=
> > +	    PCI_CLKGATT_POWSEL | PCI_CLKGATT_POWOFF;
> > +	pm_pcictrl_reg->pcimscclk_reg = readb(addrbase + PCIMSCCLK_REG);
> > +	pm_pcictrl_reg->pcisdclk_reg = readb(addrbase + PCISDCCLK_REG);
> > +	pm_pcictrl_reg->pcidmaclk_reg = readb(addrbase + PCIDMACLK_REG);
> > +	pm_pcictrl_reg->pciintctrl_reg = readb(addrbase + PCIINTCTRL_REG);
> > +	pm_pcictrl_reg->pciintstatus_reg = readb(addrbase + PCIINTSTATUS_REG);
> > +	pm_pcictrl_reg->pcitmoctrl_reg = readb(addrbase + PCITMOCTRL_REG);
> > +}
> 
> Since you already define the data structure for the save area, how about
> using it for the register accesses as well? You could drop all the PCI*_REG
> macro definitions and do

GAH! NO, I belive Linus has very clear views about using structures
to define register layouts (and I share them).
 
> struct pcictrlreg __iomem *pcr = vcrdr_chip->pcictrl_mmiobase;
> pm_pcictrl_reg->pcisdclk_reg = readb(&pcr->pcisdclk_reg);

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
