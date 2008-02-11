Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbYBKF70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbYBKF70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 00:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbYBKF7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 00:59:18 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:57445 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbYBKF7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 00:59:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Qz8pVYh/YAAdGwDfCojD4OuAsAmlOTLipDerfW/1bLr24L3OATEunUONFGTBK+cPAGzrBsOP70ZVsq7MfBFPDqqbkTEdmdLPZhB/5O8idmem/HbPRkytmC4Vg7I/SXa2g9ct3CXqo3CHhoySVXdQrgB9+s4vrPa/IuRFb+T/h8Y=
Message-ID: <86802c440802102159p16a8b52fy16480edcf4b8ba24@mail.gmail.com>
Date: Sun, 10 Feb 2008 21:59:16 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: [PATCH] Change pci_raw_ops to pci_raw_read/write
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matthew Wilcox" <matthew@wil.cx>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Greg KH" <greg@kroah.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Tony Camuso" <tcamuso@redhat.com>,
       "Grant Grundler" <grundler@parisc-linux.org>,
       "Loic Prylli" <loic@myri.com>, "Adrian Bunk" <bunk@kernel.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Ivan Kokshaysky" <ink@jurassic.park.msu.ru>,
       "Greg KH" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       "Jeff Garzik" <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       "Martin Mares" <mj@ucw.cz>
In-Reply-To: <47AFB8AD.3010904@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080129025615.GC20198@parisc-linux.org>
	 <20080209124138.GA28967@parisc-linux.org>
	 <86802c440802092225u5a901ab2i66b952382a999fa@mail.gmail.com>
	 <20080210072116.GA12375@kroah.com>
	 <20080210145122.GC5299@parisc-linux.org>
	 <86802c440802101216t3b04c0b4y89a05ac9a04a0ac5@mail.gmail.com>
	 <alpine.LFD.1.00.0802101222560.2896@woody.linux-foundation.org>
	 <20080210204556.GG5299@parisc-linux.org>
	 <86802c440802101749h5af30b4dm1836f881a898652e@mail.gmail.com>
	 <47AFB8AD.3010904@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 10, 2008 6:53 PM, Robert Hancock <hancockr@shaw.ca> wrote:
>
> Yinghai Lu wrote:
> > On Feb 10, 2008 12:45 PM, Matthew Wilcox <matthew@wil.cx> wrote:
..
> >> I've attached the two patches that I believe are the ones we want.  We
> >> can (and should) fix quirk_intel_irqbalance separately.
> >
> > Andrew,
> >
> > those two patch just got into linus 2.6.25-rc1.
> >
> > I assume that you will drop
> > gregkh-pci-pci-make-pci-extended-config-space-a-driver-opt-in.patch in
> > -mm.
> >
> > please check some updated patches in -mm that could be affected. hope
> > it could save you some time
> >
> > x86-validate-against-acpi-motherboard-resources.patch
> > x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch
> > x86-mmconf-enable-mcfg-early.patch
> > x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron-v3.patch
>
> I don't think any of these patches are affected. They all affect whether
> to use MMCONFIG globally or not, regardless of whether not particular
> accesses will use it.

what i mean:

gregkh-pci-pci-make-pci-extended-config-space-a-driver-opt-in.patch is
not needed.

and

> > x86-validate-against-acpi-motherboard-resources.patch
> > x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch
> > x86-mmconf-enable-mcfg-early.patch
> > x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron-v3.patch
need some update because of changes by "Change pci_raw_ops to
pci_raw_read/write" patch.
such as pci_conf1_read became static...unreachable_devices() is gone..

YH
