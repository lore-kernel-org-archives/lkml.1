Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbZCLRVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbZCLRVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 13:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbZCLRVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 13:21:34 -0400
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:48681 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753575AbZCLRVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 13:21:33 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-12.arcor-online.net 0A4DA1B3B8D
From: Prakash Punnoor <prakash@punnoor.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] PCI fixes for 2.6.29
Date: Thu, 12 Mar 2009 18:23:57 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc7; KDE/4.2.1; x86_64; ; )
Cc: Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20090311043659.GC25995@parisc-linux.org> <alpine.LFD.2.00.0903111220200.32478@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903111220200.32478@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903121823.57701.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mittwoch 11 März 2009 20:22:56 Linus Torvalds wrote:
> On Tue, 10 Mar 2009, Matthew Wilcox wrote:
> > These are the PCI fixes that have been piling up for the last week while
> > Jesse's been on vacation.  I don't think there's anything questionable
> > here.  All the patches have been posted to linux-pci.
>
> Grrr. It doesn't even compile cleanly:
>
> drivers/pci/quirks.c: In function ‘ht_check_msi_mapping’:
> drivers/pci/quirks.c:2142: warning: ‘return’ with no value, in function
> returning non-void
>
> and yes, it's a real bug.
>
> I'm not happy.
>
> I assume the proper fix is this trivial one-liner, but people should
> double-check.
>
> Not pulled.

As I explained to Matthew Wilcox my small patch was incorrectly applied. It 
originally was in

static void __devinit __nv_msi_ht_cap_quirk(struct pci_dev *dev, int all)

I don't know who or how it moved into

static int __devinit ht_check_msi_mapping(struct pci_dev *dev)

where it breaks for obvious reasons.


>
> 		Linus
>
> ---
>  drivers/pci/quirks.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index a13f3d7..4ba55d0 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -2139,7 +2139,7 @@ static int __devinit ht_check_msi_mapping(struct
> pci_dev *dev)
>
>  	/* Enabling HT MSI mapping on this device breaks MCP51 */
>  	if (dev->device == 0x270)
> -		return;
> +		return 0;
>
>  	/* check if there is HT MSI cap or enabled on this device */
>  	pos = pci_find_ht_capability(dev, HT_CAPTYPE_MSI_MAPPING);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

