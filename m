Return-Path: <linux-kernel-owner+w=401wt.eu-S1758590AbXEMGsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590AbXEMGsA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 02:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756689AbXEMGry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 02:47:54 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755109AbXEMGrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 02:47:53 -0400
Date: Sat, 12 May 2007 23:47:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Workaround for a PCI restoring bug
Message-Id: <20070512234743.0a8a915f.akpm@linux-foundation.org>
In-Reply-To: <20070512201237.GB3569@ics.muni.cz>
References: <20070512201237.GB3569@ics.muni.cz>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 May 2007 22:12:37 +0200 Lukas Hejtmanek <xhejtman@ics.muni.cz> wrote:

> as of 2.6.21-git16, the bugs related to restoring PCI are still present. The
> save pci function reads only -1 from the PCI config space and when restoring,
> it messes up totaly most PCI devices. The attached patch is workaround only
> until proper fix is found and included. Could it be included into the mainline
> for now?
> 
> -- 
> Lukáš Hejtmánek
> 
> 
> [pci.patch  text/x-diff (489B)]
> --- drivers/pci/pci.c.orig	2006-07-15 23:53:08.000000000 +0200
> +++ drivers/pci/pci.c	2006-07-21 00:51:07.000000000 +0200
> @@ -477,7 +477,7 @@
>  	 */
>  	for (i = 15; i >= 0; i--) {
>  		pci_read_config_dword(dev, i * 4, &val);
> -		if (val != dev->saved_config_space[i]) {
> +		if (val != dev->saved_config_space[i] && dev->saved_config_space[i] != 0xffffffff) {
>  			printk(KERN_DEBUG "PM: Writing back config space on "
>  				"device %s at offset %x (was %x, writing %x)\n",
>  				pci_name(dev), i,

This change might indeed be a suitable workaround for some busted hardware,
but we'd need to know quite a bit about the problem before we could merge
anything like this

So, again, please send a full bug report.  An emailed one would be OK in
this case.

Thanks.
