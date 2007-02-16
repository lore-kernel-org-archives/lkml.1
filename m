Return-Path: <linux-kernel-owner+w=401wt.eu-S964817AbXBPNMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964817AbXBPNMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 08:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964822AbXBPNMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 08:12:34 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:46451 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964817AbXBPNMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 08:12:33 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: minyard@acm.org
Subject: Re: [patch 3/4] ipmi: add pci remove handling
Date: Fri, 16 Feb 2007 14:16:17 +0100
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070214200624.GC5364@localdomain> <20070215022745.648ab8cb.akpm@linux-foundation.org> <20070215155318.GA24870@localdomain>
In-Reply-To: <20070215155318.GA24870@localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1666322.6071fCiHyn";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702161416.22471.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1666322.6071fCiHyn
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Am Donnerstag, 15. Februar 2007 schrieb Corey Minyard:
> On Thu, Feb 15, 2007 at 02:27:45AM -0800, Andrew Morton wrote:
> > Judging from the patch headers you were working against 2.6.19, which is
> > most optimistic.  Please always prepare and test patches against the
> > latest kernel.
>
> Well, I had it applied against a 2.6.20 kernel, but I messed up the
> testing of it.  Sorry, my bad.
>
> New patch...
>
>
> Add pci_remove handling to the driver, so it will clean up if
> the device is hot-removed.
>
> Signed-off-by: Corey Minyard <minyard@acm.org>
>
> Index: linux-2.6.20/drivers/char/ipmi/ipmi_si_intf.c
> ===================================================================
> --- linux-2.6.20.orig/drivers/char/ipmi/ipmi_si_intf.c
> +++ linux-2.6.20/drivers/char/ipmi/ipmi_si_intf.c
> @@ -2191,12 +2191,15 @@ static int __devinit ipmi_pci_probe(stru
>  		info->irq_setup = std_irq_setup;
>
>  	info->dev = &pdev->dev;
> +	pdev->dev.driver_data = info;
>
>  	return try_smi_init(info);
>  }
>
>  static void __devexit ipmi_pci_remove(struct pci_dev *pdev)
>  {
> +	struct smi_info *info = pdev->dev.driver_data;
> +	cleanup_one_si(info);
>  }

Please use pci_{set,get}_drvdata() to access this field.

Greetings,

Eike

--nextPart1666322.6071fCiHyn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBF1a6mXKSJPmm5/E4RAr21AJ4yos6En10PtNy7t0B5Q7V/n70gDwCffHBa
QhwBS/sQR2ZEdAGdKMHqpo4=
=8fGJ
-----END PGP SIGNATURE-----

--nextPart1666322.6071fCiHyn--
