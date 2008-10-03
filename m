Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbYJCS5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbYJCS5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 14:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbYJCS5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 14:57:46 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:9047 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbYJCS5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 14:57:45 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Vincent Legoll" <vincent.legoll@gmail.com>
Subject: Re: [PATCH] PCI probing debug message uniformization
Date: Fri, 3 Oct 2008 12:57:42 -0600
User-Agent: KMail/1.9.9
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <4727185d0809291403w38422338p3ffe2a1c27c39939@mail.gmail.com> <4727185d0810030214t69666ea4qa2e9960283406270@mail.gmail.com> <4727185d0810031113w2967fef7qa102d6ec4a89311e@mail.gmail.com>
In-Reply-To: <4727185d0810031113w2967fef7qa102d6ec4a89311e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200810031257.42457.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 October 2008 12:13:14 pm Vincent Legoll wrote:
> On Fri, Oct 3, 2008 at 11:14 AM, Vincent Legoll
> <vincent.legoll@gmail.com> wrote:
> > On Thu, Oct 2, 2008 at 8:59 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> >> On Thursday 02 October 2008 12:46:28 pm Jesse Barnes wrote:
> >>> Bjorn, how does this jive with the various other debug harmonization patches
> >>> you've been putting together & reviewing?
> >>
> >> I think it's great.  The only nit I would change is to use
> >> "[%#llx-%#llx]" as we do in pci_request_region().
> >>
> >> Bjorn
> >
> > Thanks for the review, I'll post an updated version this evening.
> 
> Here is the updated version, with an extra case from drivers/pci/pcie/aspm.c,
> please review for the slight wording change in the message. It's currently
> running, so is partly tested (It didn't ran through all cases on my HW)

It'll be easier for Jesse if you include the proper changelog again
with just a 1-2 line sample of the changed messages.  BTW, the "--"
before your sig confused my mailer into not quoting the patch itself,
hence the screwed up formatting below.

> -                       printk("Pre-1.1 PCIe device detected, "
> -                               "disable ASPM for %s. It can be
> enabled forcedly" -                               " with
> 'pcie_aspm=force'\n", pci_name(pdev));
> +                       dev_printk(KERN_INFO, &child_dev->dev,
> "disabling ASPM" +                               " on pre-1.1 PCIe
> device. It can be enabled" +                               "
> forcedly with 'pcie_aspm=force'\n");

dev_info() is exactly equivalent to dev_printk(KERN_INFO).  I usually
use dev_info(), though I'm a bit ambivalent because it's nice to be
able to grep for "printk".  Anyway, maybe you can correct the grammar
of "enabled forcedly" to something like "you can enable with ..." when
you re-post with the changelog.

(Note that dev_dbg() is NOT exactly equivalent to dev_printk(KERN_DEBUG),
so you can't change all of them.  dev_printk(KERN_DEBUG) is always
compiled in, while dev_dbg() is only compiled in when "DEBUG" is defined.)

Bjorn
