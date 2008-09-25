Return-Path: <linux-kernel-owner+w=401wt.eu-S1753965AbYIYQUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbYIYQUv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 12:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbYIYQUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 12:20:42 -0400
Received: from outbound-mail-23.bluehost.com ([69.89.21.18]:52240 "HELO
	outbound-mail-23.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752286AbYIYQUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 12:20:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=lox6hAfQ/e7pBnRhA09Pd7h37TlSQb6uB7Riaj2KSBPrrTtS4+wO4sUbN2J/Y6Epds7d5PWkzLfNIfHNn1XUI4MxxsLn/6Hk3LYG6EmZxSySALcVCTLkr3Um5KMx8xh9;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH 3/7] pci: using %pF in quirks.c
Date: Thu, 25 Sep 2008 09:20:06 -0700
User-Agent: KMail/1.9.9
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
References: <1222308277-10984-1-git-send-email-yhlu.kernel@gmail.com> <1222308277-10984-3-git-send-email-yhlu.kernel@gmail.com> <200809250856.57716.bjorn.helgaas@hp.com>
In-Reply-To: <200809250856.57716.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809250920.07653.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 25, 2008 7:56 am Bjorn Helgaas wrote:
> On Wednesday 24 September 2008 08:04:33 pm Yinghai Lu wrote:
> > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> > ---
> >  drivers/pci/quirks.c |    3 +--
> >  1 files changed, 1 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> > index 1f26712..addf2db 100644
> > --- a/drivers/pci/quirks.c
> > +++ b/drivers/pci/quirks.c
> > @@ -1689,8 +1689,7 @@ static void pci_do_fixups(struct pci_dev *dev,
> > struct pci_fixup *f, struct pci_f if ((f->vendor == dev->vendor ||
> > f->vendor == (u16) PCI_ANY_ID) && (f->device == dev->device || f->device
> > == (u16) PCI_ANY_ID)) { #ifdef DEBUG
> > -			dev_dbg(&dev->dev, "calling ");
> > -			print_fn_descriptor_symbol("%s\n", f->hook);
> > +			dev_dbg(&dev->dev, "calling %pF\n", f->hook);
> >  #endif
> >  			f->hook(dev);
> >  		}
>
> I posted a similar patch already:
>   http://lkml.org/lkml/2008/8/22/178
>
> Maybe mine was too complicated because it touched more files at once.
> Regardless, we need to remove the #ifdef DEBUG because it's no longer
> necessary.

Yeah you sent it to Andrew and it touched several files; maybe I shouldn't 
have ignored it. :)

Anyway I'll fix up the #ifdefs in my linux-next branch.

Thanks,
Jesse
