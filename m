Return-Path: <linux-kernel-owner+w=401wt.eu-S1757783AbZLFU0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783AbZLFU0i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 15:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757710AbZLFU0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 15:26:36 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45596 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757598AbZLFU0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 15:26:36 -0500
Date: Sun, 6 Dec 2009 09:47:17 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, akpm@linux-foundation.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Rafael J . Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       linux-laptop@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v8 5/8] Loongson: YeeLoong: add hardware monitoring
	driver
Message-ID: <20091206084717.GD2766@ucw.cz>
References: <cover.1260082252.git.wuzhangjin@gmail.com> <d8789fa7e97d8a170c4e2516d7ef2d2fbbe42cc6.1260082252.git.wuzhangjin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8789fa7e97d8a170c4e2516d7ef2d2fbbe42cc6.1260082252.git.wuzhangjin@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> +static int get_battery_current(void)
> +{
> +	s16 value;
> +
> +	value = (ec_read(REG_BAT_CURRENT_HIGH) << 8) |
> +		(ec_read(REG_BAT_CURRENT_LOW));
> +
> +	if (value < 0)
> +		value = ~value + 1;
> +
> +	return value;
> +}

What is going on here? I thought the value is already in two's
complement... Is the above equivalent of

	      if (value < 0)
	      	 value = -value; 

? If so, why? If not, can you add a comment?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
