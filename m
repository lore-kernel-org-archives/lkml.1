Return-Path: <linux-kernel-owner+w=401wt.eu-S1756618AbXJaR7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618AbXJaR7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 13:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753529AbXJaR7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 13:59:10 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:47363 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbXJaR7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 13:59:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=MHhGUXq+yPMjyIzP7A6p5TxKkxBbaDtdskc30cQ7Nc01fMHC59idR/iXTZzCaOxAv9xl9/bLGeifV7SOVsOWDNLNqoLSIt22st1eM+OMrRAogcpo5GDuCqZM3xvSAjnL97ZogzSFdXnKLr8iTdYOO5HCp11lgdJBFDntMxTPWgA=
Message-ID: <4728C266.2010600@googlemail.com>
Date: Wed, 31 Oct 2007 18:59:02 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: netdev <netdev@vger.kernel.org>, tlan-devel@lists.sourceforge.net,
       chessman@tux.org
Subject: drivers/net/tlan question
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed on current git the following warning with !CONFIG_PCI :

...

drivers/net/tlan.c: In function 'TLan_probe1':
drivers/net/tlan.c:682: warning: label 'err_out' defined but not used

...

I thought a simply #ifdef is missing but looking at TLan_probe1() I got confused about err_out_regions

...

#ifdef CONFIG_PCI
        if (pdev) {
                rc = pci_enable_device(pdev);
                if (rc)
                        return rc;

                rc = pci_request_regions(pdev, TLanSignature);
                if (rc) {
                        printk(KERN_ERR "TLAN: Could not reserve IO regions\n");
                        goto err_out;
                }
        }
#endif  /*  CONFIG_PCI  */

        dev = alloc_etherdev(sizeof(TLanPrivateInfo));
        if (dev == NULL) {
                printk(KERN_ERR "TLAN: Could not allocate memory for device.\n");
                rc = -ENOMEM;
                goto err_out_regions;
        }

...

...

err_out_regions:
#ifdef CONFIG_PCI
        if (pdev)
                pci_release_regions(pdev);
#endif
err_out:
        if (pdev)
                pci_disable_device(pdev);
        return rc;

...

It is possible 'dev' to be NULL with !CONFIG_PCI ? If is true then err_out_regions: does nothing ? 

Does this look right ?


Regards,

Gabriel 

 
