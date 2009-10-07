Return-Path: <linux-kernel-owner+w=401wt.eu-S1758059AbZJGSns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059AbZJGSns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 14:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbZJGSnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 14:43:47 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:54518 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbZJGSnq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 14:43:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LZrg5fWVOmXg8okwynQQ3eKE8bE0gC39TrzuuRG0UUj9lip/9LzXNFPLFSlmclxpuz
         CsN+aO1LpXhxnudmQ6s0d7/ouMV69KNrZWfy5Zn+zaqWijHiQh1RQzXGIH54WGJT0ST6
         ViCHNStpK656gYyeHpocWwikr/unlqEp1k9Kw=
MIME-Version: 1.0
In-Reply-To: <20091006213349.4272.65914.stgit@bob.kio>
References: <20091006213259.4272.68068.stgit@bob.kio>
	 <20091006213349.4272.65914.stgit@bob.kio>
Date: Wed, 7 Oct 2009 11:43:09 -0700
Message-ID: <86802c440910071143y7ba8b0f8y9efff738eba9d30b@mail.gmail.com>
Subject: Re: [PATCH 5/7] x86/PCI: print resources consistently with %pRt
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 6, 2009 at 2:33 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> This uses %pRt to print additional resource information (type, size,
> prefetchability, etc.) consistently.
>
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> ---
>  arch/x86/pci/acpi.c |   14 +++++++++++---
>  arch/x86/pci/i386.c |   12 +++++-------
>  2 files changed, 16 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
> index 2297280..4d4f1df 100644
> --- a/arch/x86/pci/acpi.c
> +++ b/arch/x86/pci/acpi.c
> @@ -7,6 +7,7 @@
>  #include <asm/pci_x86.h>
>
>  struct pci_root_info {
> +       struct acpi_device *bridge;
>        char *name;
>        unsigned int res_num;
>        struct resource *res;
> @@ -107,12 +108,18 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
>        res->child = NULL;
>
>        if (insert_resource(root, res)) {
> -               printk(KERN_ERR "PCI: Failed to allocate 0x%lx-0x%lx "
> -                       "from %s for %s\n", (unsigned long) res->start,
> -                       (unsigned long) res->end, root->name, info->name);
> +               dev_err(&info->bridge->dev, "can't allocate %pRt\n", res);

better to keep that root name ?

YH
