Return-Path: <linux-kernel-owner+w=401wt.eu-S933226AbXHXTAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226AbXHXTAQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 15:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761942AbXHXTAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 15:00:01 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:63301 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758685AbXHXS77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 14:59:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mMKOJ8y//O7XeCaMlZ/qkoS98U2vJykb9UvVeGerds3Bm0GGGa+QhdF0ujzpofHOs1u4tZeiYDrS7MOYjAxju5S9UQiZiUT3OkudMJJv7Nci3G5s4W7WF5XLDsFXhZw3a9l5WgMBsd7Ez0Se48amV3BQheRZ2+x2kVt8PYKMGuw=
Message-ID: <4af2d03a0708241159v56b46299h46df9777a98590e5@mail.gmail.com>
Date: Fri, 24 Aug 2007 16:59:58 -0200
From: "Jiri Slaby" <jirislaby@gmail.com>
To: postfail@hushmail.com
Subject: Re: [PATCH] /drivers/char sx.c ioremap -> pci_ioremap api
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <46CF2849.2090008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46CF2849.2090008@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/24/07, Scott Thompson <postfailathushmail@gmail.com> wrote:
>
> patchset against 2.6.23-rc3.
>
> moves the iomap/iounmap call to pci 'flavor'.  this was a
> recommendation from a previously submitted patch that handles
> the unchecked iomap (or, now, pci_iomap) return code.
>
> Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
> ----------------------------------------------------------
>
> diff --git a/drivers/char/sx.c b/drivers/char/sx.c
> index 85a2328..481334f 100644
> --- a/drivers/char/sx.c
> +++ b/drivers/char/sx.c
> @@ -2626,14 +2626,14 @@ static void __devinit fix_sx_pci(struct pci_dev
> *pdev, struct sx_board *board)
>
>   	pci_read_config_dword(pdev, PCI_BASE_ADDRESS_0, &hwbase);
>   	hwbase &= PCI_BASE_ADDRESS_MEM_MASK;
> -	rebase = ioremap(hwbase, 0x80);

remove also the hwbase var.

> +	rebase = pci_iomap(pdev, 0, 0x80);
>   	t = readl(rebase + CNTRL_REG_OFFSET);
>   	if (t != CNTRL_REG_GOODVALUE) {
>   		printk(KERN_DEBUG "sx: performing cntrl reg fix: %08x -> "
>   			"%08x\n", t, CNTRL_REG_GOODVALUE);
>   		writel(CNTRL_REG_GOODVALUE, rebase + CNTRL_REG_OFFSET);
>   	}
> -	iounmap(rebase);
> +	pci_iounmap(pdev, rebase);
>   }
>   #endif
>


-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
