Return-Path: <linux-kernel-owner+w=401wt.eu-S1161029AbXDTEvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161029AbXDTEvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 00:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161039AbXDTEvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 00:51:52 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161029AbXDTEvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 00:51:50 -0400
Date: Thu, 19 Apr 2007 21:51:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/11] Char: cyclades, clear interrupts before releasing
Message-Id: <20070419215146.1b85353c.akpm@linux-foundation.org>
In-Reply-To: <4488267294095310@karneval.cz>
References: <2428225437641930190@karneval.cz>
	<4488267294095310@karneval.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007 12:07:56 +0200 (CEST) Jiri Slaby <jirislaby@gmail.com> wrote:

> +	/* non-Z with old PLX */
> +	if (cinfo->num_chips != -1 && (readb(cinfo->base_addr + CyPLX_VER) &
> +				0x0f) == PLX_9050)
> +		cy_writeb(cinfo->ctl_addr + 0x4c, 0);
> +	else
> +#ifndef CONFIG_CYZ_INTR
> +		if (cinfo->num_chips != -1)
> +#endif
> +		cy_writew(cinfo->ctl_addr + 0x68,
> +				readw(cinfo->ctl_addr + 0x68) & ~0x0900);

well that a bit nasty.

We already have that IS_CYC_Z() thing.  Perhaps we could turn that into a nice
lowercase-named C function and provide a CONFIG_CYZ_INTR=y version which
does `return 1'.  Or something like that.

But the above is, umm, inconsistent with the cleanups you've been doing ;)
