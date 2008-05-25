Return-Path: <linux-kernel-owner+w=401wt.eu-S1761959AbYEYKXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761959AbYEYKXS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756985AbYEYKWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:22:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53748 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753936AbYEYKWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:22:30 -0400
Date: Sun, 25 May 2008 11:08:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Samuel Tardieu <sam@rfc1149.net>,
       Mike Frysinger <vapier.adi@gmail.com>, Mingarelli@infomag.iguana.be,
       Thomas <Thomas.Mingarelli@hp.com>,
       Jordan Crouse <jordan.crouse@amd.com>, Chen Gong <g.chen@freescale.com>,
       Gabriel C <nix.or.die@googlemail.com>
Subject: Re: [WATCHDOG] v2.6.26-rc3 patches
Message-ID: <20080525110812.3a05e9fa@core>
In-Reply-To: <20080525100944.GA4084@infomag.infomag.iguana.be>
References: <20080525100944.GA4084@infomag.infomag.iguana.be>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +
> +static void geodewdt_ping(void)
> +{
> +	/* Stop the counter */
> +	geode_mfgpt_write(wdt_timer, MFGPT_REG_SETUP, 0);
> +
> +	/* Reset the counter */
> +	geode_mfgpt_write(wdt_timer, MFGPT_REG_COUNTER, 0);
> +
> +	/* Enable the counter */
> +	geode_mfgpt_write(wdt_timer, MFGPT_REG_SETUP, MFGPT_SETUP_CNTEN);
> +}
> +
> +static void geodewdt_disable(void)
> +{
> +	geode_mfgpt_write(wdt_timer, MFGPT_REG_SETUP, 0);
> +	geode_mfgpt_write(wdt_timer, MFGPT_REG_COUNTER, 0);
> +}
> +
> +static int geodewdt_set_heartbeat(int val)
> +{
> +	if (val < 1 || val > GEODEWDT_MAX_SECONDS)
> +		return -EINVAL;
> +
> +	geode_mfgpt_write(wdt_timer, MFGPT_REG_SETUP, 0);
> +	geode_mfgpt_write(wdt_timer, MFGPT_REG_CMP2, val * GEODEWDT_HZ);
> +	geode_mfgpt_write(wdt_timer, MFGPT_REG_COUNTER, 0);
> +	geode_mfgpt_write(wdt_timer, MFGPT_REG_SETUP, MFGPT_SETUP_CNTEN);
> +
> +	timeout = val;
> +	return 0;
> +}
> +

There is no locking in geodewdt - so all those routines can end up being
run together. Not sure it is a problem just noting it while reviewing.

