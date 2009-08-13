Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbZHMXAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbZHMXAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 19:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755672AbZHMXAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 19:00:11 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:35268 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633AbZHMXAJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 19:00:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jyKNr1omfp4fahKog7Vr1doFeogfEbigAEZ7lFP6zMb0pEM1dLOwIyKpT3BKzpem6s
         s+uFS3eeW8A9yZsZ+rpdx7b6CT59m+MrgSkKCjdvPURXNew7wNqgX2X++HbgZh1FtH63
         c9PGMvThGfOGb8bNCoe2HkYiLVxx89EJNzTDs=
MIME-Version: 1.0
In-Reply-To: <1249637774-32419-1-git-send-email-dfeng@redhat.com>
References: <1249637774-32419-1-git-send-email-dfeng@redhat.com>
Date: Thu, 13 Aug 2009 16:00:08 -0700
X-Google-Sender-Auth: c6f06c58aa21f563
Message-ID: <9929d2390908131600y330e4014se4f5955515cfc84d@mail.gmail.com>
Subject: Re: [PATCH] e1000e: fix use of pci_enable_pcie_error_reporting
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: john.ronciak@intel.com, peter.p.waskiewicz.jr@intel.com,
       bruce.w.allan@intel.com, jesse.brandeburg@intel.com,
       davem@davemloft.net, e1000-devel@lists.sourceforge.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 7, 2009 at 02:36, Xiaotian Feng<dfeng@redhat.com> wrote:
> commit 111b9dc5 introduces pcie aer support for e1000e, but it is not
> reasonable to disable it in e1000_remove but enable it in e1000_resume.
> This patch enables aer support in e1000_probe.
>
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> ---
>  drivers/net/e1000e/netdev.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
> index 63415bb..e2f0304 100644
> --- a/drivers/net/e1000e/netdev.c
> +++ b/drivers/net/e1000e/netdev.c
> @@ -4670,14 +4670,6 @@ static int e1000_resume(struct pci_dev *pdev)
>                return err;
>        }
>
> -       /* AER (Advanced Error Reporting) hooks */
> -       err = pci_enable_pcie_error_reporting(pdev);
> -       if (err) {
> -               dev_err(&pdev->dev, "pci_enable_pcie_error_reporting failed "
> -                                   "0x%x\n", err);
> -               /* non-fatal, continue */
> -       }
> -
>        pci_set_master(pdev);
>
>        pci_enable_wake(pdev, PCI_D3hot, 0);
> @@ -4990,6 +4982,14 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
>        if (err)
>                goto err_pci_reg;
>
> +        /* AER (Advanced Error Reporting) hooks */
> +        err = pci_enable_pcie_error_reporting(pdev);
> +        if (err) {
> +                dev_err(&pdev->dev, "pci_enable_pcie_error_reporting failed "
> +                                    "0x%x\n", err);
> +                /* non-fatal, continue */
> +        }
> +
>        pci_set_master(pdev);
>        /* PCI config space info */
>        err = pci_save_state(pdev);
> --
> 1.6.2.5
>
> --

This patch passed testing, I have added it to my queue of patches and
will push this out to Dave (with the whitespace corrected).

-- 
Cheers,
Jeff
