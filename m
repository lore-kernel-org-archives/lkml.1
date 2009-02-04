Return-Path: <linux-kernel-owner+w=401wt.eu-S1753694AbZBDBzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbZBDBzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 20:55:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbZBDBzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 20:55:05 -0500
Received: from gate.crashing.org ([63.228.1.57]:54470 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbZBDBzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 20:55:03 -0500
Subject: Re: [PATCH 1/7] PCI PM: Fix handling of devices without drivers
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Eric Sesterhenn <snakebyte@gmx.de>
In-Reply-To: <200902040156.15200.rjw@sisk.pl>
References: <200902040154.36018.rjw@sisk.pl>
	 <200902040156.15200.rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 12:53:53 +1100
Message-Id: <1233712433.16867.133.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -static void pci_pm_default_suspend(struct pci_dev *pci_dev)
> +static void pci_pm_default_suspend(struct pci_dev *pci_dev, bool prepare)
>  {
>  	pci_pm_default_suspend_generic(pci_dev);
>  
> -	if (!pci_is_bridge(pci_dev))
> +	if (prepare && !pci_is_bridge(pci_dev))
>  		pci_prepare_to_sleep(pci_dev);

Minor nit: It took me a while to understand the patch because of the use
of the word "prepare" which we easily confuse with the prepare suspend
phase.

Might be worth using a different terminology...

Cheers,
Ben.


