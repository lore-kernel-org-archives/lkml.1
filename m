Return-Path: <linux-kernel-owner+w=401wt.eu-S1758719AbZE2Qxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719AbZE2Qxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 12:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbZE2Qxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 12:53:30 -0400
Received: from complete.lackof.org ([198.49.126.79]:55603 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbZE2Qx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 12:53:29 -0400
Date: Fri, 29 May 2009 10:53:31 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tejun Heo <tj@kernel.org>, linux-pci@vger.kernel.org,
       Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       towerlexa@gmx.de
Subject: Re: Who's responsible for configuring CLS on a cardbus device?
Message-ID: <20090529165331.GD28355@lackof.org>
References: <4A1BE904.8080302@kernel.org> <20090526142300.73d466d0@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526142300.73d466d0@lxorguk.ukuu.org.uk>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 02:23:00PM +0100, Alan Cox wrote:
...
> > This is solvable by simply setting CLS to the correct value but who's
> > job is it?  For non-hotplug devices, this is configured by the BIOS
> > (at least on PC), so for hotplug devices I think falls on the lap of
> > the PCI code but I'm not sure.  If this is something which the
> > sata_sil driver should be responsible for, is there an established way
> > to determine the proper CLS value?
> 
> Currently its handled by pci_set_mwi() but there isn't actually a more
> direct way to do this.

There isn't for the drivers because BIOS is supposed to set
PCI_CACHE_LINE_SIZE.

If the BIOS isn't setting PCI_CACHE_LINE_SIZE, the arch specific
pci support should be checking PCI_CACHE_LINE_SIZE and/or setting
it in pcibios_set_master().

hth,
grant
