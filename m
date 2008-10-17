Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbYJQNXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbYJQNXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 09:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbYJQNXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 09:23:47 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2954 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbYJQNXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 09:23:46 -0400
Date: Fri, 17 Oct 2008 14:23:42 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       lrg@slimlogic.co.uk, alsa-devel@alsa-project.org
Subject: Re: [PATCH] Fix debugfs_create_dir's error checking method for sound/soc/
Message-ID: <20081017132340.GF2546@sirena.org.uk>
References: <48F88D77.2080106@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F88D77.2080106@cn.fujitsu.com>
X-Cookie: Monitor not included.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 09:04:55PM +0800, Zhaolei wrote:

> debugfs_create_dir() returns NULL if an error occurs, returns -ENODEV
> when debugfs is not enabled in the kernel.

...

>  	asoc_debugfs = debugfs_create_dir("asoc", NULL);
> -	if (!IS_ERR(asoc_debugfs))
> +	if (!IS_ERR(asoc_debugfs) && asoc_debugfs)
>  		debugfs_create_u32("dapm_pop_time", 0744, asoc_debugfs,
>  				   &pop_time);

Hrmpf.  This looks like something that should be fixed in debugfs -
using both error reporting strategies is rather unhelpful and we're
actually loosing information in the case where debugfs is built.  I'll
send a patch and see what people thing.

Still in the meantime,

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
