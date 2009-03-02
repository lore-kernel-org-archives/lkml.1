Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797AbZCBUeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbZCBUeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 15:34:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbZCBUd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 15:33:56 -0500
Received: from colo.lackof.org ([198.49.126.79]:56977 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbZCBUdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 15:33:55 -0500
Date: Mon, 2 Mar 2009 13:33:40 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/6] Rewrite MSI-HOWTO
Message-ID: <20090302203340.GA9302@colo.lackof.org>
References: <1235410082-5016-1-git-send-email-matthew@wil.cx> <1235410082-5016-2-git-send-email-matthew@wil.cx> <20090227061525.GA9883@colo.lackof.org> <20090227121443.GL16891@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090227121443.GL16891@parisc-linux.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 27, 2009 at 05:14:43AM -0700, Matthew Wilcox wrote:
> On Thu, Feb 26, 2009 at 11:15:25PM -0700, Grant Grundler wrote:
> > ...
> > > +3. Why use MSIs?
> > > +
> > > +There are three reasons why using MSIs can give an advantage over
> > > +traditional pin-based interrupts.
> > ...
> > > +PCI devices can only support a single pin-based interrupt per function.
> > 
> > Related to this is a 4th reason: distribute workload across CPUs
> > and enables construction of efficient, multi-queue devices.
> > Care to mention that?
> 
> That's true for MSI-X, but not for MSIs in general.  Workload is already
> distributed across CPUs with round-robin interrupts.  I'm inclined to
> leave out this level of detail.

I'm Ok with omitting it.

AFAICT "round-robin" was a behavior of older kernels.
All the x86 platforms I've looked at direct the MSI to exactly
one CPU.

> 
> > > +The MSI-X capability is much more flexible than the MSI capability.
> > > +It supports up to 2048 interrupts, each of which can be separately
> > > +assigned.
> > 
> > Nothing describes "assignment" below or what is meant by "assigned".
> > My guess is you wanted to differentiate MSIX from MSI with:
> >   ... and each MSIX can be directed at a different CPU.
> 
> I think 'each of which can be controlled separately' might work better.
> For example, they're individually maskable which isn't (necessarily)
> true of plain MSI.

Sounds good to me.


...
> > The description for MSI is correct. But Linux will only allocate one
> > MSI as noted in an earlier section. This section implies more could
> > be allocated when using MSI and that won't happen.
> > 
> > IIRC, for AHCI perf you were working on a patch to change that and
> > it should probably update this text at the same time when the
> > behavior changes.
> 
> Did you see this is patch 1/6?  ;-)

yes....after I hit send and continued reviewing the rest of the patches. ;)

>  I removed the description of
> pci_enable_msi_block() from this patch, but missed updating this
> paragraph.  By patch 6/6, this paragraph is true.

Yup - agreed.

> > ...
> > > +5.3. Disabling MSIs on a single device
> > > +
> > > +Some devices are known to have faulty MSI implementations.  Usually this
> > > +is handled in the individual device driver but occasionally it's necessary
> > > +to handle this with a quirk.  Some drivers have an option to disable MSIs;
> > > +this is deprecated.
> > 
> > "this" is ambiguous. My guess is "quirks to disable MSI for a device is
> > deprecated" since recently some drivers have added module parameters to
> > disable MSI.
> 
> Having an option to disable MSI is deprecated.  That doesn't mean that
> individual driver authors aren't selfish and short-sighted.

Ok. Here's a suggestion on how to say that:
Driver options to disable MSI are deprecated and will be removed in the future.

But anything you like better is fine with me.

> > Should mention "fgrep MSI /proc/interrupts" to see if any devices have
> > MSI in use?
> 
> Yes, you're right.
> 
> > > +Then, lspci -t gives the list of bridges above a device.  Reading
> > > +/sys/bus/pci/devices/*/msi_bus will tell you whether MSI are enabled (1)
> > > +or disabled (0).  If 0 is found in any of the msi_bus files belonging
> > > +to bridges between the PCI root and the device, MSIs are disabled.
> > > +
> > > +It is also worth checking whether the device driver supports MSIs.
> > 
> > Suggestions on how to check?
> 
> 'eg has calls to pci_enable_msi(), pci_enable_msix() or
> pci_enable_msi_block()'?

Yeah, that should work.
Anyone reading this doc has obviously found a source tree. ;)

> > Conversely, one can easily check if the driver has MSI disabled by default
> > and MSI can be enabled.  e.g. use "modinfo mvsas" to check driver parameters.
> 
> I'm not going to give examples of bad practise.

*nod* I agree it would encourage use and should not be included.
 
cheers,
grant

> > Reviewed-by: Grant Grundler <grundler@parisc-linunx.org>
> 
> Thanks.
> 
> -- 
> Matthew Wilcox				Intel Open Source Technology Centre
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."
