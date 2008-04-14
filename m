Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbYDNLUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbYDNLUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 07:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbYDNLU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 07:20:27 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:14751 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752812AbYDNLU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 07:20:27 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-11.tower-29.messagelabs.com!1208172026!921749!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
Date: Mon, 14 Apr 2008 13:20:21 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Re: [PATCH 4/4 v2] [RFC] UIO: generic platform driver
Message-ID: <20080414112021.GA19986@digi.com>
References: <20080411092158.GB31625@digi.com> <20080411103346.GC3185@local> <20080411110358.GC19973@digi.com> <20080411111703.GD3185@local> <20080411112543.GA23221@digi.com> <20080412131646.GF9669@flint.arm.linux.org.uk> <20080414074858.GA22694@digi.com> <20080414093714.GD1540@flint.arm.linux.org.uk> <20080414095445.GA19413@digi.com> <20080414101701.GE1540@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080414101701.GE1540@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 14 Apr 2008 11:20:22.0981 (UTC) FILETIME=[87D14F50:01C89E21]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.000.1023-15848.006
X-TM-AS-Result: No--19.965000-8.000000-1
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

> > > What's this drivers/uio/uio_pdrv.ko module, and why doesn't it appear
> > > in the LKML archive of this thread?
> > Don't know why lkml.org didn't link these.  The start of the thread can
> > be found at
> > 
> > 	http://lkml.org/lkml/2008/4/10/110
> 
> Thanks.  Well, tbh, I don't know which way to go on this.  Each of the
> suggested ways have their downsides.
> 
> However:
> 
> +       pdata->clk = clk_get(&pdev->dev, DRIVER_NAME);
> 
> seems wrong - "uio" as a clock name?
What do you suggest?  "uioclk"?
 
> +               /* XXX: better use dev_dbg, but which device should I use?
> +                * info->uio_dev->dev isn't accessible here as struct uio_device
> +                * is opaque.
> +                */
> 
> why not store a copy of 'dev' in struct uio_platdata ?
I don't like increasing the size of struct uio_platdata only for a debug
helper.  In most cases pr_debug (or dev_dbg) compiles to nothing.
Maybe the easiest way is to remove that debug statement.

> +       uiomem = &uioinfo->mem[0];
> +       for (i = 0; i < pdev->num_resources; ++i) {
> ...
> +               ++uiomem;
> +       }
> 
> Who's to say there's pdev->num_resources entries in the 'mem' array?
The code you skipped with ... from that loop includes

	if (uiomem >= &uioinfo->mem[MAX_UIO_MAPS]) {
		dev_warn(&pdev->dev, "...");
		break;
	}

that should take care of that.  In v2 of this patch the remaining
entries are disabled by .size = 0.

> Shouldn't this loop also be limited to MAX_UIO_MAPS iterations (or
> maybe complain if there's more than MAX_UIO_MAPS)?
> 
> +/* XXX: I thought there already exists something like STRINGIFY, but I could not
> + * find it ...
> + */
> +#ifndef STRINGIFY
> +#define STRINGIFY(x) __STRINGIFY_HELPER(x)
> +#define __STRINGIFY_HELPER(x) #x
> +#endif
> 
> #include <linux/stringify.h> ?
If you look at the v2 patch[1] I found that in the mean time.  Thanks
all the same.

Best regards and thanks for your review,
Uwe

[1] http://lkml.org/lkml/2008/4/11/81 or
http://thread.gmane.org/gmane.linux.kernel/665257

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
