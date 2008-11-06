Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbYKFRsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbYKFRsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 12:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbYKFRr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 12:47:59 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:36687 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbYKFRr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 12:47:58 -0500
Date: Thu, 6 Nov 2008 10:47:41 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Greg KH <greg@kroah.com>
Cc: H L <swdevyid@yahoo.com>, Yu Zhao <yu.zhao@intel.com>,
       randy.dunlap@oracle.com, grundler@parisc-linux.org, achiang@hp.com,
       linux-pci@vger.kernel.org, rdreier@cisco.com,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       mingo@elte.hu, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
Message-ID: <20081106174741.GC11773@parisc-linux.org>
References: <20081106154351.GA30459@kroah.com> <894107.30288.qm@web45108.mail.sp1.yahoo.com> <20081106164919.GA4099@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106164919.GA4099@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 08:49:19AM -0800, Greg KH wrote:
> On Thu, Nov 06, 2008 at 08:41:53AM -0800, H L wrote:
> > I have not modified any existing drivers, but instead I threw together
> > a bare-bones module enabling me to make a call to pci_iov_register()
> > and then poke at an SR-IOV adapter's /sys entries for which no driver
> > was loaded.
> > 
> > It appears from my perusal thus far that drivers using these new
> > SR-IOV patches will require modification; i.e. the driver associated
> > with the Physical Function (PF) will be required to make the
> > pci_iov_register() call along with the requisite notify() function.
> > Essentially this suggests to me a model for the PF driver to perform
> > any "global actions" or setup on behalf of VFs before enabling them
> > after which VF drivers could be associated.
> 
> Where would the VF drivers have to be associated?  On the "pci_dev"
> level or on a higher one?
> 
> Will all drivers that want to bind to a "VF" device need to be
> rewritten?

The current model being implemented by my colleagues has separate
drivers for the PF (aka native) and VF devices.  I don't personally
believe this is the correct path, but I'm reserving judgement until I
see some code.

I don't think we really know what the One True Usage model is for VF
devices.  Chris Wright has some ideas, I have some ideas and Yu Zhao has
some ideas.  I bet there's other people who have other ideas too.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
