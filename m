Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbYJ0HIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbYJ0HIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 03:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbYJ0HIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 03:08:05 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:57780 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbYJ0HIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 03:08:04 -0400
Date: Mon, 27 Oct 2008 01:07:45 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: "Zhao, Yu" <yu.zhao@intel.com>
Cc: Yu Zhao <yu.zhao@uniscape.net>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       Rakib Mullick <rakib.mullick@gmail.com>
Subject: Re: [PATCH] pci: Fixing drivers/pci/search.c compilation warning.
Message-ID: <20081027070745.GY26094@parisc-linux.org>
References: <b9df5fa10809280816u23ef3021k7eee287a237b72ae@mail.gmail.com> <20080928163211.GR27204@parisc-linux.org> <20081021011308.GA3889@parisc-linux.org> <490467CD.3000402@uniscape.net> <20081026183412.GX26094@parisc-linux.org> <49053313.9080706@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49053313.9080706@intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 11:18:43AM +0800, Zhao, Yu wrote:
> Matthew Wilcox wrote:
> >Yes, that's why pci_find_device() is deprecated.  But it doesn't also
> >need to be buggy ;-)
> 
> How about pci_get_bus_and_slot()? People would meet the problem with it 
> anyway.

What problem with it?  It's documented to return the device with an
increased refcount, and the implementation appears to do exactly that:

struct pci_dev * pci_get_bus_and_slot(unsigned int bus, unsigned int devfn)
{
        struct pci_dev *dev = NULL;

        while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
                if (pci_domain_nr(dev->bus) == 0 &&
                   (dev->bus->number == bus && dev->devfn == devfn))
                        return dev;
        }
        return NULL;
}

Are you saying some users of it neglect to decrement the refcount before
disposing of the device?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
