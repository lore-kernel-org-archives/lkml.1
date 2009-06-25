Return-Path: <linux-kernel-owner+w=401wt.eu-S1759391AbZFYQJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391AbZFYQJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 12:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757895AbZFYQJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 12:09:00 -0400
Received: from mail-yx0-f186.google.com ([209.85.210.186]:61375 "EHLO
	mail-yx0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428AbZFYQJA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 12:09:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jL2jyUkykMY7f42c2gywcSLf0dodZfEf5XQz5nUM+z84kmSPxmzSw1i8L8f6TV0fbc
         Ypnvafr3JAYAYlVW66Dw4CIze+7dLrOIneGlfQNGwQ8IaK/CVYdwGYD7etSB5Ow9sEAZ
         bImBj4A8K/8MLOau6T6eGiPir1jY9mPSf4uAk=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0906251548300.2760@troy-laptop>
References: <alpine.LFD.2.00.0906251548300.2760@troy-laptop>
Date: Fri, 26 Jun 2009 00:02:07 +0800
Message-ID: <b6a2187b0906250902xede3041p599e538099340a04@mail.gmail.com>
Subject: Re: [2.6.31-rc1] oops in acpi_get_pci_dev
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Troy Moure <twmoure@szypr.net>
Cc: Alessandro Suardi <alessandro.suardi@gmail.com>,
       Alexander Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 11:13 PM, Troy Moure<twmoure@szypr.net> wrote:
> (I don't know if it's the "right" fix or not, not being familiar with the
> system.  If it is, I can send it in as a proper patch.)
>
> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
> index 8a5bf3b..55b5b90 100644
> --- a/drivers/acpi/pci_root.c
> +++ b/drivers/acpi/pci_root.c
> @@ -395,7 +395,7 @@ struct pci_dev *acpi_get_pci_dev(acpi_handle handle)
>                fn  = adr & 0xffff;
>
>                pdev = pci_get_slot(pbus, PCI_DEVFN(dev, fn));
> -               if (hnd == handle)
> +               if (!pdev || hnd == handle)
>                        break;
>
>                pbus = pdev->subordinate;

I've the same problem with booting hangs, and your patch fixed the
problem  on my ThinkPad X61.


Thanks,
Jeff.
