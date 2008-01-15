Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbYAOMWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbYAOMWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 07:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbYAOMWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 07:22:07 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:41963 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbYAOMWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 07:22:04 -0500
Date: Tue, 15 Jan 2008 05:22:01 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>, Greg KH <greg@kroah.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]PCIE ASPM support - takes 2
Message-ID: <20080115122200.GW18741@parisc-linux.org>
References: <1200367276.20538.1.camel@sli10-desk.sh.intel.com> <20080115041943.GS18741@parisc-linux.org> <1200373622.20869.2.camel@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200373622.20869.2.camel@sli10-desk.sh.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 01:07:02PM +0800, Shaohua Li wrote:
> > > +
> > > +/* Called after ACPI is enabled */
> > > +static int __init acpi_pcie_support_init(void)
> > > +{
> > > +	pcie_aspm_init();
> > > +	return 0;
> > > +}
> > > +fs_initcall(acpi_pcie_support_init);
> > 
> > Is there any reason to put this in here instead of just making
> > pcie_aspm_init an initcall?
> yes, this will evaluate some ACPI methods, so must be called after ACPI
> is initialized, which is a sub_system call

I wasn't saying that you should change it from being an fs_initcall.  I
was saying that you might want to consider deleting this function and
adding

fs_initcall(pcie_aspm_init);

in the file that defines pcie_aspm_init.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
