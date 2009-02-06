Return-Path: <linux-kernel-owner+w=401wt.eu-S1755077AbZBFSfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbZBFSfz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 13:35:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750882AbZBFSfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 13:35:46 -0500
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:49462 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831AbZBFSfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 13:35:46 -0500
Date: Fri, 6 Feb 2009 19:35:42 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@strlen.de>
To: Frank Seidel <fseidel@suse.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       khali@linux-fr.org, ben-linux@fluff.org, linux-i2c@vger.kernel.org,
       frank@f-seidel.de, w.sang@pengutronix.de,
       "David S. Miller" <davem@davemloft.net>, Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] i2c: add missing KERN_* constants to printks
Message-ID: <20090206183542.GB6361@strlen.de>
References: <498C3EEA.5060508@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498C3EEA.5060508@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Feb 06, 2009 at 02:45:14PM +0100, Frank Seidel wrote:
> From: Frank Seidel <frank@f-seidel.de>
> 
> According to kerneljanitors todo list all printk calls (beginning
> a new line) should have an according KERN_* constant.
> Those are the missing pieces here for the i2c subsystem.
OK in principle.  Still *I* prefer the pr_debug, pr_emerg etc. macros.
Looks a bit nicer ...

> --- a/drivers/i2c/algos/i2c-algo-pca.c
> +++ b/drivers/i2c/algos/i2c-algo-pca.c
> @@ -51,7 +51,7 @@ static int i2c_debug;
>  static void pca_start(struct i2c_algo_pca_data *adap)
>  {
>  	int sta = pca_get_con(adap);
> -	DEB2("=== START\n");
> +	DEB2(KERN_WARNING "=== START\n");
Are you sure about KERN_WARNING?  I havn't looked deeper, but DEB2
suggests KERN_DEBUG?  What about fixing DEB[1-3] directly instead of
each "call".  e.g.

-#define DEB2(fmt, args...) do { if (i2c_debug>=2) printk(fmt, ## args); } while(0)
+#define DEB2(fmt, args...) do { if (i2c_debug>=2) pr_warning(fmt, ## args); } while(0)

Best regards,
Uwe
