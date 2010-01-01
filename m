Return-Path: <linux-kernel-owner+w=401wt.eu-S1752110Ab0AAWMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab0AAWMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 17:12:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716Ab0AAWMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 17:12:12 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:37891 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab0AAWMK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 17:12:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZUt/+C65UCwxDOrpQub2nDHpqc3Irh9yqOGEUJOjrCESFCtHpROaHEAgn32YCw7d/W
         V8043wMBhgG17IvypbLwD00GtYsMzNH2za/rBiWYO46JqkqM0JOpUN/OXW+HIpytX8Z2
         NBsCu3Dz506Xubw21aYd+mSQRJGfK0jhIABp8=
MIME-Version: 1.0
In-Reply-To: <1262364050-8540-1-git-send-email-linux@dominikbrodowski.net>
References: <20100101163811.GA8124@comet.dominikbrodowski.net>
	 <1262364050-8540-1-git-send-email-linux@dominikbrodowski.net>
Date: Fri, 1 Jan 2010 14:12:09 -0800
X-Google-Sender-Auth: 1b48e28d3cb8c53f
Message-ID: <86802c441001011412u1543c1afk6337cd6d3ea0f257@mail.gmail.com>
Subject: Re: [PATCH 1/2] resource: align functions now return start of 
	resource
From: Yinghai Lu <yinghai@kernel.org>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 1, 2010 at 8:40 AM, Dominik Brodowski
<linux@dominikbrodowski.net> wrote:
> As suggested by Linus, align functions should return the start
> of a resource, not void. An update of "res->start" is no longer
> necessary.
>
> Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Cc: Yinghai Lu <yhlu.kernel@gmail.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
> ---
>  arch/alpha/kernel/pci.c                 |    4 ++--
>  arch/arm/kernel/bios32.c                |    8 +++++---
>  arch/cris/arch-v32/drivers/pci/bios.c   |   14 ++++++--------
>  arch/frv/mb93090-mb00/pci-frv.c         |   14 ++++++--------
>  arch/ia64/pci/pci.c                     |    3 ++-
>  arch/mips/pci/pci.c                     |    4 ++--
>  arch/mips/pmc-sierra/yosemite/ht.c      |   10 +++++-----
>  arch/mn10300/unit-asb2305/pci-asb2305.c |   16 +++++++---------
>  arch/parisc/kernel/pci.c                |   10 +++++-----
>  arch/powerpc/kernel/pci-common.c        |   13 ++++++-------
>  arch/sh/drivers/pci/pci.c               |    6 +++---
>  arch/sparc/kernel/pci.c                 |    5 +++--
>  arch/sparc/kernel/pcic.c                |    5 +++--
>  arch/x86/pci/i386.c                     |   12 +++++-------
>  arch/xtensa/kernel/pci.c                |   11 +++++------
>  drivers/pci/bus.c                       |    6 ++++--
>  drivers/pcmcia/rsrc_mgr.c               |   12 ++++++------
>  drivers/pcmcia/rsrc_nonstatic.c         |   16 +++++++++-------
>  include/linux/ioport.h                  |    6 ++++--
>  include/linux/pci.h                     |    8 +++++---
>  kernel/resource.c                       |   14 +++++++++-----
>  21 files changed, 102 insertions(+), 95 deletions(-)
>
> diff --git a/arch/alpha/kernel/pci.c b/arch/alpha/kernel/pci.c
> index a91ba28..5cf111e 100644
> --- a/arch/alpha/kernel/pci.c
> +++ b/arch/alpha/kernel/pci.c
> @@ -126,7 +126,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, pcibios_fixup_final);
>  #define MB                     (1024*KB)
>  #define GB                     (1024*MB)
>
> -void
> +resource_size_t
>  pcibios_align_resource(void *data, struct resource *res,
>                       resource_size_t size, resource_size_t align)
>  {
> @@ -184,7 +184,7 @@ pcibios_align_resource(void *data, struct resource *res,
>                }
>        }
>
> -       res->start = start;
> +       return start;
>  }
>  #undef KB
>  #undef MB
> diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
> index 8096819..a7c85f8 100644
> --- a/arch/arm/kernel/bios32.c
> +++ b/arch/arm/kernel/bios32.c
> @@ -616,15 +616,17 @@ char * __init pcibios_setup(char *str)
>  * but we want to try to avoid allocating at 0x2900-0x2bff
>  * which might be mirrored at 0x0100-0x03ff..
>  */
> -void pcibios_align_resource(void *data, struct resource *res,
> -                           resource_size_t size, resource_size_t align)
> +resource_size_t pcibios_align_resource(void *data, struct resource *res,
> +                               resource_size_t size, resource_size_t align)
>  {
>        resource_size_t start = res->start;
>
>        if (res->flags & IORESOURCE_IO && start & 0x300)
>                start = (start + 0x3ff) & ~0x3ff;
>
> -       res->start = (start + align - 1) & ~(align - 1);
> +       start = (start + align - 1) & ~(align - 1);
> +
> +       return start;
>  }
>
>  /**
> diff --git a/arch/cris/arch-v32/drivers/pci/bios.c b/arch/cris/arch-v32/drivers/pci/bios.c
> index 77ee319..5811e2f 100644
> --- a/arch/cris/arch-v32/drivers/pci/bios.c
> +++ b/arch/cris/arch-v32/drivers/pci/bios.c
> @@ -41,18 +41,16 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
>        return 0;
>  }
>
> -void
> +resource_size_t
>  pcibios_align_resource(void *data, struct resource *res,
>                       resource_size_t size, resource_size_t align)
>  {
> -       if (res->flags & IORESOURCE_IO) {
> -               resource_size_t start = res->start;
> +       resource_size_t start = res->start;
>
> -               if (start & 0x300) {
> -                       start = (start + 0x3ff) & ~0x3ff;
> -                       res->start = start;
> -               }
> -       }
> +       if ((res->flags & IORESOURCE_IO) && (start & 0x300))
> +               start = (start + 0x3ff) & ~0x3ff;
> +
> +       return start

missed ; here?

YH
