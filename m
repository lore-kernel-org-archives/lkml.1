Return-Path: <linux-kernel-owner+w=401wt.eu-S1757694AbYBVFyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694AbYBVFyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 00:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbYBVFyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 00:54:23 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:40411 "EHLO
	outbound3-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751439AbYBVFyW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 00:54:22 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0JWMLJ8-01-JHM-01
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 03/10] PCI: AMD SATA IDE mode quirk
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Fri, 22 Feb 2008 13:49:20 +0800
Message-ID: <206C6845C72CAE439DC3D9D413C571A49662F8@ssuzexmb3.amd.com>
In-Reply-To: <20080222041733.GD16995@parisc-linux.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 03/10] PCI: AMD SATA IDE mode quirk
Thread-Index: Ach1CeJor2nClCJpTZ63edokLvDMNQACWUVQ
References: <20080221234644.GA7128@kroah.com> <1203637660-7247-3-git-send-email-gregkh@suse.de> <20080222041733.GD16995@parisc-linux.org>
From: "Cai, Crane" <Crane.Cai@amd.com>
To: "Matthew Wilcox" <matthew@wil.cx>, "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: <linux-pci@atrey.karlin.mff.cuni.cz>, <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@osdl.org>, "Andrew Morton" <akpm@osdl.org>
X-OriginalArrivalTime: 22 Feb 2008 05:49:21.0167 (UTC) FILETIME=[ABC601F0:01C87516]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Feb 21, 2008 at 03:47:33PM -0800, Greg Kroah-Hartman wrote:
> > +static void __devinit quirk_amd_ide_mode(struct pci_dev *pdev)
> >  {
> > -	/* set sb600 sata to ahci mode */
> > -	if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE) {
> > -		u8 tmp;
> > +	/* set sb600/sb700/sb800 sata to ahci mode */
> > +	u8 tmp;
> >  
> > +	pci_read_config_byte(pdev, PCI_CLASS_DEVICE, &tmp);
> > +	if (tmp == 0x01) {
> >  		pci_read_config_byte(pdev, 0x40, &tmp);
> 
> This seems like a dis-improvement.  Why are we reading a 
> config byte for something we already have in the pci_dev?  
> Why are we now checking against 0x01 instead of a symbolic 
> constant?  Why are we no longer checking that this is 
> PCI_BASE_CLASS_STORAGE?
It is a quirk. In pci_ids.h did have PCI_CLASS_STORAGE_IDE 
and PCI_BASE_CLASS_STORAGE, these can not represent 
the right situation we want to check. 0x01 represents 
PCI_CLASS_STORAGE_IDE last 2 bit. Also because it 
is a quirk, I do not think we need to change pci_ids.h. So 0x01 
used. 
> > -DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, 
> > PCI_DEVICE_ID_ATI_IXP600_SATA, quirk_sb600_sata); 
> > -DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, 
> > PCI_DEVICE_ID_ATI_IXP700_SATA, quirk_sb600_sata);
> > +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, 
> > +PCI_DEVICE_ID_ATI_IXP600_SATA, quirk_amd_ide_mode); 
> > +DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_ATI, 
> > +PCI_DEVICE_ID_ATI_IXP600_SATA, quirk_amd_ide_mode); 
> > +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, 
> > +PCI_DEVICE_ID_ATI_IXP700_SATA, quirk_amd_ide_mode); 
> > +DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_ATI, 
> > +PCI_DEVICE_ID_ATI_IXP700_SATA, quirk_amd_ide_mode);
> 
> Nothing in the changelog entry suggests why we now need 
> FIXUP_RESUME entries when we didn't before.
> 
PCI configuration space will be changed by BIOS and then in pci
init and restore. So resume also needed.
> --
> Intel are signing my paycheques ... these opinions are still 
> mine "Bill, look, we understand that you're interested in 
> selling us this operating system, but compare it to ours.  We 
> can't possibly take such a retrograde step."
> 
> 

