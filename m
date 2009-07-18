Return-Path: <linux-kernel-owner+w=401wt.eu-S932732AbZGRLr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732AbZGRLr1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 07:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932588AbZGRLr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 07:47:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60440 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932546AbZGRLr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 07:47:26 -0400
Date: Sat, 18 Jul 2009 13:47:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tiago Vignatti <tiago.vignatti@nokia.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@redhat.com>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vga: implements VGA arbitration on Linux
Message-ID: <20090718114713.GC1433@ucw.cz>
References: <1247576250-16274-1-git-send-email-tiago.vignatti@nokia.com> <1247576250-16274-2-git-send-email-tiago.vignatti@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247576250-16274-2-git-send-email-tiago.vignatti@nokia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-07-14 15:57:29, Tiago Vignatti wrote:
> Signed-off-by: Tiago Vignatti <tiago.vignatti@nokia.com>



> ---

Some patch description might be useful.

> @@ -0,0 +1,1120 @@
> +/*
> + * vgaarb.c
> + *
> + * (C) Copyright 2005 Benjamin Herrenschmidt <benh@kernel.crashing.org>
> + * (C) Copyright 2007 Paulo R. Zanoni <przanoni@gmail.com>
> + * (C) Copyright 2007, 2009 Tiago Vignatti <vignatti@freedesktop.org>
> + *

If you  have copyright, GPL would be cool.

> +struct vga_device {
> +	struct list_head list;
> +	struct pci_dev *pdev;
> +	unsigned int decodes;	/* what does it decodes */
> +	unsigned int owns;	/* what does it owns */
> +	unsigned int locks;	/* what does it locks */

spelling in comments? And ...how can int tell me what it owns?


> +
> +static LIST_HEAD(vga_list);
> +static DEFINE_SPINLOCK(vga_lock);
> +static DECLARE_WAIT_QUEUE_HEAD(vga_wait_queue);
> +
> +#ifndef __ARCH_HAS_VGA_DEFAULT_DEVICE
> +static struct pci_dev *vga_default;
> +#endif
> +
> +static void vga_arb_device_card_gone(struct pci_dev *pdev);
> +
> +/* Find somebody in our list */
> +static struct vga_device *vgadev_find(struct pci_dev *pdev)
> +{
> +	struct vga_device *vgadev;
> +
> +	list_for_each_entry(vgadev, &vga_list, list)
> +	    if (pdev == vgadev->pdev)
> +		return vgadev;
> +	return NULL;
> +}

Indent using tabs. checkpatch?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
