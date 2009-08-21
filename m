Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbZHUHGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbZHUHGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 03:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754381AbZHUHGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 03:06:22 -0400
Received: from leia.mcbone.net ([194.97.104.42]:57317 "EHLO leia.mcbone.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912AbZHUHGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 03:06:21 -0400
Subject: Re: [PATCH,v2] Re: e1000e: why does
 pci_enable_pcie_error_reporting() fail on my hp2510p?
From: Jens Rosenboom <jens@mcbone.net>
To: Frans Pop <elendil@planet.nl>
Cc: Danny Feng <dfeng@redhat.com>, Netdev <netdev@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       David Miller <davem@davemloft.net>
In-Reply-To: <200908210848.39377.elendil@planet.nl>
References: <200908201714.30638.elendil@planet.nl>
	 <200908210829.10471.elendil@planet.nl> <4A8E3FC1.50201@redhat.com>
	 <200908210848.39377.elendil@planet.nl>
Content-Type: text/plain
Date: Fri, 21 Aug 2009 09:06:12 +0200
Message-Id: <1250838372.9489.8.camel@fnki-nb00130>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-21 at 08:48 +0200, Frans Pop wrote:
[...]
> @@ -5301,9 +5296,6 @@ static void __devexit e1000_remove(struct pci_dev *pdev)
>  
>  	/* AER disable */
>  	err = pci_disable_pcie_error_reporting(pdev);
> -	if (err)
> -		dev_err(&pdev->dev,
> -		        "pci_disable_pcie_error_reporting failed 0x%x\n", err);
>  
>  	pci_disable_device(pdev);
>  }

While you're at it, why don't you also remove the "err =" here, which
allows you to drop the variable from that function completely? This
applies to all three *_remove() functions.

