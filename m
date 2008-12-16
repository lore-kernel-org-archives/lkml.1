Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbYLPTfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbYLPTfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:35:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbYLPTfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:35:17 -0500
Received: from outbound-mail-306.bluehost.com ([67.222.53.252]:55551 "HELO
	outbound-mail-306.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751329AbYLPTfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:35:16 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=JxwMou1D1zjx+fqpSg4cE4PaKlpkorhTlyMdI+7SmR3IXURx1Fsce9+lXPMltZS9z1nx0OuqSgMEsExmRlQshNUI2xd/LUqSNeOGU773v0KFrjmbXIQInXq7ediNOvZ0;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH] fakephp: Allocate PCI resources before adding 
 =?iso-8859-15?q?the=09device?=
Date: Tue, 16 Dec 2008 11:33:33 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: Trent Piepho <xyzzy@speakeasy.org>, "Darrick J. Wong" <djwong@us.ibm.com>,
       Alex Chiang <achiang@hp.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-pci" <linux-pci@vger.kernel.org>
References: <20081125212422.22631.69619.stgit@elm3a70.beaverton.ibm.com> <Pine.LNX.4.58.0811281303230.30153@shell4.speakeasy.net> <200812011808.31906.eike-kernel@sf-tec.de>
In-Reply-To: <200812011808.31906.eike-kernel@sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812161133.33894.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 1, 2008 9:08 am Rolf Eike Beer wrote:
> Trent Piepho wrote:
> > On Fri, 28 Nov 2008, Rolf Eike Beer wrote:
> > > Trent Piepho wrote:
> > > > On Wed, 26 Nov 2008, Darrick J. Wong wrote:
> > > > > On Wed, Nov 26, 2008 at 03:55:35PM -0700, Alex Chiang wrote:
> > > > > > > Maybe it's different on powerpc then?  My pseudo-hotplugable
> > > > > > > device is also the only thing connected to the PCI-E host bus
> > > > > > > controller. At boot the controller is empty and so I think some
> > > > > > > code to enable its BARs gets skipped.  But without the
> > > > > > > pci_enable_device(), I get this:
> > > > > > >
> > > > > > > 01:00.0 Signal processing controller: Freescale Semiconductor
> > > > > > > Inc Aurora Nexus Trace Interface Flags: fast devsel, IRQ 255
> > > > > > > Memory at 40000000 (64-bit, prefetchable) [disabled] [size=4K]
> > > > >
> > > > >                            Are you referring to this? ^^^^^^^^^^
> > > > >
> > > > > Without seeing the raw dump of the PCI config space, it looks to me
> > > > > like the memory space enable bit of the PCICMD register is unset.
> > > > > Probably the device driver should call pci_enable_device() at init
> > > > > time, though I suppose you did say earlier that there is no driver.
> > > >
> > > > Yes, that's it.  It seems like since the BARs are normally enabled
> > > > after a device is scanned at boot time that they should also be
> > > > enabled when a device is found by a fakephp rescan.  So I thought it
> > > > seemed reasonable to put pci_enable_device() in fakephp.
> > >
> > > No, pci_enable_device() will be called by the device driver. The
> > > hotplug drivers have nothing to do with that.
> >
> > I guess you didn't read the part about there not being a device driver?
>
> I read it, but that's the way a kernel works: if you want to talk to a
> device, get a driver. You can write a rather minimal one that does only
> pci_enable_device() on probe and pci_disable_device() on remove. Try the
> one posted by Chris Wright in "[PATCH 2/2] PCI: pci-stub module to reserve
> pci device" as a starting point.

Ok, so sounds like Darrick's original patch gets a NAK?  I guess the fakephp 
vs. dummyphp vs. new interface stuff can be dealt with in another thread...
-- 
Jesse Barnes, Intel Open Source Technology Center

