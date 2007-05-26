Return-Path: <linux-kernel-owner+w=401wt.eu-S1762393AbXEZS2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762393AbXEZS2o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 14:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbXEZS2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 14:28:37 -0400
Received: from colo.lackof.org ([198.49.126.79]:41938 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554AbXEZS2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 14:28:36 -0400
Date: Sat, 26 May 2007 12:28:28 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Roland Dreier <rdreier@cisco.com>, Greg KH <greg@kroah.com>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCIE
Message-ID: <20070526182828.GA7080@colo.lackof.org>
References: <20070523155958.GA5282@kroah.com> <4654AB40.6060208@gmail.com> <adaejl79rh0.fsf@cisco.com> <4654BC10.2000808@gmail.com> <adazm3v89hv.fsf@cisco.com> <4654C85B.6060505@gmail.com> <adatzu385g1.fsf@cisco.com> <46561287.8020103@gmail.com> <ada1wh560u1.fsf@cisco.com> <46584C30.4030206@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46584C30.4030206@gmail.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2007 at 07:03:12PM +0400, Manu Abraham wrote:
> Roland Dreier wrote:
> >  > I am now wondering whether the usage of MSI would help in this case and
> >  > that i should be using enable_msi before request_irq ?
> > 
> > MSI interrupts are never shared.  So if pci_enable_msi() succeeds, you
> > can be sure that the interrupts you get with that IRQ number are
> > coming from your device.
> > 
> 
> i presume then i shouldn't be using IRQF_SHARED, if using MSI.

I'm not sure...but my guess is not. Who ever "just knows", could you
please submit a patch to Documentation/MSI-HOWTO.txt ?

> Another question would be if the device supports multiple messages, MSIX
> should be used ?

Yes. Assuming the device supports multiple MSI-X messages.


> In such a context, if i request for say more than the messages that i
> need, say i request 16 messages, but use only 1 or 2, that does bear any
> consequences ?

Yes. One is allocating IRQ vectors from a finite number of vectors.
But this normally isn't a problem until one gets to larger machines that
have more than 4-8 PCI-e or PCI-X slots.

Typically, one will limit the number of vectors to the number of CPUs
in the system or to how many different events the device can signal.

> > But using MSI does not work on all systems, so your driver needs to
> > work with standard (possibly shared) INTx interrupts too.  And you
> > should probably provide at least a module flag to disable the use of
> > MSI, to avoid problems on buggy systems.
> 
> I should probably look for CONFIG_PCI_MSI and check whether the system
> supports MSI pci_enable_msi() ?

pci_enable_msi() will fail if the system doesn't support MSI or something
else goes wrong with the call (e.g. already setup).

hth,
grant
