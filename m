Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbZFAIbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbZFAIbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 04:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbZFAIbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 04:31:06 -0400
Received: from outbound-mail-141.bluehost.com ([67.222.38.31]:47194 "HELO
	outbound-mail-141.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751570AbZFAIbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 04:31:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=LSfP9bNKKMSIKgnB8iU/oxiDubcf8Hl+jbgCqGtMx8xZJuk3sdFFSP8mjVfGuCD6w9nniIt7SO7I36TXdjZQ2/VZ1n8ZFdsKugDjhLEeQr4dUL2np+jXj+2QOlUw2xfn;
Date: Mon, 1 Jun 2009 09:31:00 +0100
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yu Zhao <yu.zhao@intel.com>
Cc: Grant Grundler <grundler@parisc-linux.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "marc.c.dionne@gmail.com" <marc.c.dionne@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: use fixed-up device class when configuring device
Message-ID: <20090601093100.47924ca0@jbarnes-x200>
In-Reply-To: <4A2333CF.2040601@intel.com>
References: <1243441505-5477-1-git-send-email-yu.zhao@intel.com>
	<20090529171956.GE28355@lackof.org>
	<4A2333CF.2040601@intel.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 158.43.2.102 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah I should have queued this for the last pull.  I'll send another
request with this patch as soon as Linus pulls.

Jesse

On Mon, 01 Jun 2009 09:50:07 +0800
Yu Zhao <yu.zhao@intel.com> wrote:

> Hi Jesse,
> 
> Can you please take this fix for 2.6.30 RC if possible? It fixes a 
> regression introduced by the SR-IOV patch series.
> 
> Thanks,
> Yu
> 
> Grant Grundler wrote:
> > On Thu, May 28, 2009 at 12:25:05AM +0800, Yu Zhao wrote:
> >> The device class may be changed after the early fixup. Need to
> >> re-read the class value from pci_dev when configuring the device.
> >> Otherwise some devices such as JMicron SATA controller won't work.
> > 
> > I looked at pci_setup_device() and was thinking pci_fixup_device()
> > should be called before pci_cfg_space_size() and thus avoid having
> > to setup local "class" variable twice. pci_cfg_space_size() only
> > seems to care if the device is a PCI_CLASS_BRIDGE_HOST (or not).
> > 
> > But dev->class has to be set up in any case and the current order
> > makes more sense to me.
> > 
> > Reviewed-by: Grant Grundler <grundler@parisc-linux.org>
> > 
> > thanks,
> > grant
> > 
> >> Tested-by: Marc Dionne <marc.c.dionne@gmail.com>
> >> Signed-off-by: Yu Zhao <yu.zhao@intel.com>
> >> ---
> >>  drivers/pci/probe.c |    2 ++
> >>  1 files changed, 2 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> >> index e3c3e08..f1ae247 100644
> >> --- a/drivers/pci/probe.c
> >> +++ b/drivers/pci/probe.c
> >> @@ -745,6 +745,8 @@ int pci_setup_device(struct pci_dev *dev)
> >>  
> >>  	/* Early fixups, before probing the BARs */
> >>  	pci_fixup_device(pci_fixup_early, dev);
> >> +	/* device class may be changed after fixup */
> >> +	class = dev->class >> 8;
> >>  
> >>  	switch (dev->hdr_type) {		    /* header
> >> type */ case PCI_HEADER_TYPE_NORMAL:		    /*
> >> standard header */ -- 
> >> 1.6.1
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe
> >> linux-pci" in the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

