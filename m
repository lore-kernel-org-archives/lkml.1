Return-Path: <linux-kernel-owner+w=401wt.eu-S1756520AbZLDOoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbZLDOoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 09:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755835AbZLDOoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 09:44:44 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57658 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824AbZLDOon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 09:44:43 -0500
Date: Fri, 4 Dec 2009 09:08:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, akpm@linux-foundation.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       linux-laptop@vger.kernel.org
Subject: Re: [PATCH v7 5/8] Loongson: YeeLoong: add hardware monitoring
	driver
Message-ID: <20091204080813.GB1540@ucw.cz>
References: <cover.1259932036.git.wuzhangjin@gmail.com> <102732263f647e47216c1f2cb121c30226cc995e.1259932036.git.wuzhangjin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <102732263f647e47216c1f2cb121c30226cc995e.1259932036.git.wuzhangjin@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> +static int get_cpu_temp(void)
> +{
> +	int value;
> +
> +	value = ec_read(REG_TEMPERATURE_VALUE);
> +
> +	if (value & (1 << 7))
> +		value = (value & 0x7f) - 128;
> +	else
> +		value = value & 0xff;

wtf?

Maybe value should be 's8'?

> +static int get_battery_current(void)
> +{
> +	int value;
> +
> +	value = (ec_read(REG_BAT_CURRENT_HIGH) << 8) |
> +		(ec_read(REG_BAT_CURRENT_LOW));
> +
> +	if (value & 0x8000)
> +		value = 0xffff - value;

Another version of  pair-complement conversion; this one is broken --
off by 1.

> +static int parse_arg(const char *buf, unsigned long count, int *val)
> +{
> +	if (!count)
> +		return 0;
> +	if (sscanf(buf, "%i", val) != 1)
> +		return -EINVAL;
> +	return count;
> +}

We have strict_strtoul for a reason...

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
