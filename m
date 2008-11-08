Return-Path: <linux-kernel-owner+w=401wt.eu-S1753801AbYKHUz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbYKHUz5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 15:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbYKHUzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 15:55:49 -0500
Received: from server.drzeus.cx ([85.8.24.28]:58318 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752476AbYKHUzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 15:55:48 -0500
Date: Sat, 8 Nov 2008 21:55:37 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/3] mmc: Add mmc_vddrange_to_ocrmask() helper function
Message-ID: <20081108215537.12cdf5f6@mjolnir.drzeus.cx>
In-Reply-To: <20081030195632.GB13640@oksana.dev.rtsoft.ru>
References: <20081030195546.GA30645@oksana.dev.rtsoft.ru>
	<20081030195632.GB13640@oksana.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2008 22:56:32 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> +/**
> + * mmc_vddrange_to_ocrmask - Convert a voltage range to the OCR mask
> + * @vdd_min:	minimum voltage value (mV)
> + * @vdd_max:	maximum voltage value (mV)
> + * @mask:	pointer to the mask
> + *

Why the pointer? Why not let the caller handle the aggregation? That
would be a lot safer.

> +	/* fill the mask, from max bit to min bit */
> +	while (vdd_max >= vdd_min)
> +		*mask |= 1 << vdd_max--;
> +	return 0;

Many cards get a bit uppity with a single bit set. If possible, try to
make this function set two bits when the voltage is right on the
boundary (e.g. 3.3V).

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
