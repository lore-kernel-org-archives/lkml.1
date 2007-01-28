Return-Path: <linux-kernel-owner+w=401wt.eu-S932915AbXA1WJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915AbXA1WJy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 17:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932917AbXA1WJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 17:09:54 -0500
Received: from ozlabs.org ([203.10.76.45]:52784 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932915AbXA1WJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 17:09:51 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17853.7463.911235.324340@cargo.ozlabs.ibm.com>
Date: Mon, 29 Jan 2007 09:01:11 +1100
From: Paul Mackerras <paulus@samba.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Greg Kroah-Hartman <greg@kroah.com>, Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Kyle McMartin <kyle@parisc-linux.org>,
       linuxppc-dev@ozlabs.org, Brice Goglin <brice@myri.com>,
       shaohua.li@intel.com, linux-pci@atrey.karlin.mff.cuni.cz,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/6] msi: Kill msi_lookup_irq
In-Reply-To: <m1d54zq6o3.fsf_-_@ebiederm.dsl.xmission.com>
References: <1169714047.65693.647693675533.qpush@cradle>
	<m1hcubq6re.fsf@ebiederm.dsl.xmission.com>
	<m1d54zq6o3.fsf_-_@ebiederm.dsl.xmission.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman writes:

> @@ -693,15 +664,14 @@ int pci_enable_msi(struct pci_dev* dev)
>  	if (!pos)
>  		return -EINVAL;
>  
> -	WARN_ON(!msi_lookup_irq(dev, PCI_CAP_ID_MSI));
> +	WARN_ON(!!dev->msi_enabled);

Minor nit: what's wrong with just WARN_ON(dev->msi_enabled) ?
Also here:

> @@ -836,16 +811,14 @@ int pci_enable_msix(struct pci_dev* dev, struct msix_entry *entries, int nvec)
>  				return -EINVAL;	/* duplicate entry */
>  		}
>  	}
> -	temp = dev->irq;
> -	WARN_ON(!msi_lookup_irq(dev, PCI_CAP_ID_MSIX));
> +	WARN_ON(!!dev->msix_enabled);

Paul.
