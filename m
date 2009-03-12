Return-Path: <linux-kernel-owner+w=401wt.eu-S1757421AbZCLXJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421AbZCLXJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 19:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755673AbZCLXJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 19:09:17 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:41662 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607AbZCLXJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 19:09:16 -0400
Date: Thu, 12 Mar 2009 17:09:14 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] PCI fixes for 2.6.29
Message-ID: <20090312230914.GA11874@parisc-linux.org>
References: <20090311043659.GC25995@parisc-linux.org> <alpine.LFD.2.00.0903111220200.32478@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903111220200.32478@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 12:22:56PM -0700, Linus Torvalds wrote:
> On Tue, 10 Mar 2009, Matthew Wilcox wrote:
> > These are the PCI fixes that have been piling up for the last week while
> > Jesse's been on vacation.  I don't think there's anything questionable
> > here.  All the patches have been posted to linux-pci.
> 
> Grrr. It doesn't even compile cleanly:
> 
> drivers/pci/quirks.c: In function ?ht_check_msi_mapping?:
> drivers/pci/quirks.c:2142: warning: ?return? with no value, in function returning non-void
> 
> and yes, it's a real bug.

Sigh.  I just went back through my logs of what I did ... and it's all
my fault.  The patch from Prakash didn't apply cleanly, and rather than
kick it back to him and ask him to provide a patch that did, I tried to
apply it by hand.  And I got it wrong.

So I've adjusted it, and pushed out a new git tree:

The following changes since commit 16b71fdf97599f1b1b7f38418ee9922d9f117396:
  Samuel CUELLA (1):
        i810: fix kernel crash fix when struct fb_var_screeninfo is supplied

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/willy/pci.git fixes-20090312

Alex Chiang (2):
      PCIe: AER: during disable, check subordinate before walking
      PCIe: portdrv: call pci_disable_device during remove

Alexander Duyck (1):
      PCI: Add PCI quirk to disable L0s ASPM state for 82575 and 82598

Michael Ellerman (1):
      powerpc/pseries: The RPA PCI hotplug driver depends on EEH

Prakash Punnoor (2):
      pci: don't disable too many HT MSI mapping
      pci: Fix typo in message while disabling HT MSI mapping

 drivers/pci/hotplug/Kconfig        |    2 +-
 drivers/pci/pcie/aer/aerdrv_core.c |    3 +++
 drivers/pci/pcie/portdrv_pci.c     |    1 +
 drivers/pci/quirks.c               |   31 ++++++++++++++++++++++++++++++-
 4 files changed, 35 insertions(+), 2 deletions(-)


-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
