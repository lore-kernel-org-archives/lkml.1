Return-Path: <linux-kernel-owner+w=401wt.eu-S1759414AbYAaFFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759414AbYAaFFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 00:05:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbYAaFFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 00:05:05 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:46621 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbYAaFFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 00:05:01 -0500
Date: Thu, 31 Jan 2008 06:05:00 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] net driver fixes
Message-ID: <20080131050500.GA30989@uranus.ravnborg.org>
References: <20080130094440.GA4652@havoc.gtf.org> <20080130102116.GA20846@uranus.ravnborg.org> <20080130224711.GA24133@electric-eye.fr.zoreil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130224711.GA24133@electric-eye.fr.zoreil.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 11:47:11PM +0100, Francois Romieu wrote:
> Sam Ravnborg <sam@ravnborg.org> :
> [...]
> > > -static struct pci_device_id sis190_pci_tbl[] __devinitdata = {
> > > +static struct pci_device_id sis190_pci_tbl[] = {
> > >  	{ PCI_DEVICE(PCI_VENDOR_ID_SI, 0x0190), 0, 0, 0 },
> > >  	{ PCI_DEVICE(PCI_VENDOR_ID_SI, 0x0191), 0, 0, 1 },
> > >  	{ 0, },
> > 
> > The __devinitdata is OK, it is the following _devinitdata that had
> > to be _devinitconst.
> 
> Strangely enough, removing the devinitdata from the sis190_pci_tbl
> silents the error message here. Do you have an explanation ?
gcc compalins if you add const and non-const data to the same section
which is the case in this driver.

The bug are exposed now where __devinitdata are no longer an empty define.

	Sam
