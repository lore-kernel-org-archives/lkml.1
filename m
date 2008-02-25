Return-Path: <linux-kernel-owner+w=401wt.eu-S1759649AbYBYBov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759649AbYBYBov (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 20:44:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbYBYBon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 20:44:43 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:51372 "EHLO
	outbound7-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753483AbYBYBol convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 20:44:41 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0JWRU4T-02-2MC-01
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 03/10] PCI: AMD SATA IDE mode quirk
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Mon, 25 Feb 2008 09:43:59 +0800
Message-ID: <206C6845C72CAE439DC3D9D413C571A49663E6@ssuzexmb3.amd.com>
In-Reply-To: <20080222111105.GE16995@parisc-linux.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 03/10] PCI: AMD SATA IDE mode quirk
Thread-Index: Ach1Q6qEKLQTxUvvT4GAFqK2OWhiMwCC9IAg
References: <20080221234644.GA7128@kroah.com> <1203637660-7247-3-git-send-email-gregkh@suse.de> <20080222041733.GD16995@parisc-linux.org> <206C6845C72CAE439DC3D9D413C571A49662F8@ssuzexmb3.amd.com> <20080222111105.GE16995@parisc-linux.org>
From: "Cai, Crane" <Crane.Cai@amd.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>,
       <linux-pci@atrey.karlin.mff.cuni.cz>, <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@osdl.org>, "Andrew Morton" <akpm@osdl.org>
X-OriginalArrivalTime: 25 Feb 2008 01:43:59.0929 (UTC) FILETIME=[E4789A90:01C8774F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Feb 22, 2008 at 01:49:20PM +0800, Cai, Crane wrote:
> > > On Thu, Feb 21, 2008 at 03:47:33PM -0800, Greg 
> Kroah-Hartman wrote:
> > > > +static void __devinit quirk_amd_ide_mode(struct pci_dev *pdev)
> > > >  {
> > > > -	/* set sb600 sata to ahci mode */
> > > > -	if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE) {
> > > > -		u8 tmp;
> > > > +	/* set sb600/sb700/sb800 sata to ahci mode */
> > > > +	u8 tmp;
> > > >  
> > > > +	pci_read_config_byte(pdev, PCI_CLASS_DEVICE, &tmp);
> > > > +	if (tmp == 0x01) {
> > > >  		pci_read_config_byte(pdev, 0x40, &tmp);
> > > 
> > > This seems like a dis-improvement.  Why are we reading a 
> config byte 
> > > for something we already have in the pci_dev?
> > > Why are we now checking against 0x01 instead of a 
> symbolic constant?  
> > > Why are we no longer checking that this is PCI_BASE_CLASS_STORAGE?
> > It is a quirk. In pci_ids.h did have PCI_CLASS_STORAGE_IDE and 
> > PCI_BASE_CLASS_STORAGE, these can not represent the right 
> situation we 
> > want to check. 0x01 represents PCI_CLASS_STORAGE_IDE last 2 
> bit. Also 
> > because it is a quirk, I do not think we need to change 
> pci_ids.h. So 
> > 0x01 used.
> 
> You haven't explained what is wrong with the original code:
> 
> 	if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE) {
> 

When resume, this pdev->class is quirked, however BIOS has modified pci configuration too. Inconsistance occurs.

> > > Nothing in the changelog entry suggests why we now need 
> FIXUP_RESUME 
> > > entries when we didn't before.
> > > 
> > PCI configuration space will be changed by BIOS and then in 
> pci init 
> > and restore. So resume also needed.
> 
> That information needed to be in the changelog.

This info, is a normal info. If maintainer need us to added in source code. I preferred too. 
> --
> Intel are signing my paycheques ... these opinions are still 
> mine "Bill, look, we understand that you're interested in 
> selling us this operating system, but compare it to ours.  We 
> can't possibly take such a retrograde step."
> 
> 
> 

