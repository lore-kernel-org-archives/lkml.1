Return-Path: <linux-kernel-owner+w=401wt.eu-S1760866AbYBVLLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760866AbYBVLLS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 06:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbYBVLLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 06:11:08 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:38097 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbYBVLLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 06:11:07 -0500
Date: Fri, 22 Feb 2008 04:11:05 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: "Cai, Crane" <Crane.Cai@amd.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 03/10] PCI: AMD SATA IDE mode quirk
Message-ID: <20080222111105.GE16995@parisc-linux.org>
References: <20080221234644.GA7128@kroah.com> <1203637660-7247-3-git-send-email-gregkh@suse.de> <20080222041733.GD16995@parisc-linux.org> <206C6845C72CAE439DC3D9D413C571A49662F8@ssuzexmb3.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <206C6845C72CAE439DC3D9D413C571A49662F8@ssuzexmb3.amd.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 01:49:20PM +0800, Cai, Crane wrote:
> > On Thu, Feb 21, 2008 at 03:47:33PM -0800, Greg Kroah-Hartman wrote:
> > > +static void __devinit quirk_amd_ide_mode(struct pci_dev *pdev)
> > >  {
> > > -	/* set sb600 sata to ahci mode */
> > > -	if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE) {
> > > -		u8 tmp;
> > > +	/* set sb600/sb700/sb800 sata to ahci mode */
> > > +	u8 tmp;
> > >  
> > > +	pci_read_config_byte(pdev, PCI_CLASS_DEVICE, &tmp);
> > > +	if (tmp == 0x01) {
> > >  		pci_read_config_byte(pdev, 0x40, &tmp);
> > 
> > This seems like a dis-improvement.  Why are we reading a 
> > config byte for something we already have in the pci_dev?  
> > Why are we now checking against 0x01 instead of a symbolic 
> > constant?  Why are we no longer checking that this is 
> > PCI_BASE_CLASS_STORAGE?
> It is a quirk. In pci_ids.h did have PCI_CLASS_STORAGE_IDE 
> and PCI_BASE_CLASS_STORAGE, these can not represent 
> the right situation we want to check. 0x01 represents 
> PCI_CLASS_STORAGE_IDE last 2 bit. Also because it 
> is a quirk, I do not think we need to change pci_ids.h. So 0x01 
> used. 

You haven't explained what is wrong with the original code:

	if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE) {

> > Nothing in the changelog entry suggests why we now need 
> > FIXUP_RESUME entries when we didn't before.
> > 
> PCI configuration space will be changed by BIOS and then in pci
> init and restore. So resume also needed.

That information needed to be in the changelog.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
