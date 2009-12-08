Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbZLHHxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbZLHHxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 02:53:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbZLHHxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 02:53:13 -0500
Received: from mail-px0-f194.google.com ([209.85.216.194]:38745 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966AbZLHHxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 02:53:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=aE4AlpJwZnCoe1m/2nVV1ehlsnMY92k9Q3HEOAhndYXMqMdYlwGI/69n1Uv7LaUSuQ
         D+dKk3yr1jaSeJxlLeKf2KOnH0M8K1WXVzSELG3y7Kbi1B5EDlnrRAqnDntzGC4kQZAW
         z9dTVKpdeHvKWCk12FIpNXIVJxTWR6bh+Kdog=
Subject: Re: [PATCH v8 3/8] Loongson: YeeLoong: add backlight driver
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Ralf Baechle <ralf@linux-mips.org>
Cc: akpm@linux-foundation.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Rafael J . Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       linux-laptop@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <3c77f3891e73e189cceef7155dc9cb6503084a4b.1260082252.git.wuzhangjin@gmail.com>
References: <cover.1260082252.git.wuzhangjin@gmail.com>
	 <d6bb11d33fe01abd6de945117ce647af73841f00.1260082252.git.wuzhangjin@gmail.com>
	 <5a8742a71e96ba40bee34fb37478cc8339e76530.1260082252.git.wuzhangjin@gmail.com>
	 <3c77f3891e73e189cceef7155dc9cb6503084a4b.1260082252.git.wuzhangjin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Tue, 08 Dec 2009 15:52:44 +0800
Message-ID: <1260258764.3315.82.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-06 at 15:01 +0800, Wu Zhangjin wrote:
> From: Wu Zhangjin <wuzhangjin@gmail.com>
> 
> This patch adds YeeLoong Backlight Driver, it provides standard
> interface(/sys/class/backlight/) for user-space applications(e.g.
> kpowersave, gnome-power-manager) to control the brightness of the
> backlight.
[...]
> +static int yeeloong_set_brightness(struct backlight_device *bd)
> +{
> +	unsigned int level, current_level;
> +	static unsigned int old_level;
> +
> +	level = (bd->props.fb_blank == FB_BLANK_UNBLANK &&
> +		 bd->props.power == FB_BLANK_UNBLANK) ?
> +	    bd->props.brightness : 0;
> +
> +	if (level > MAX_BRIGHTNESS)
> +		level = MAX_BRIGHTNESS;
> +	else if (level < 0)
> +		level = 0;
> +
> +	/* Avoid to modify the brightness when EC is tuning it */
> +	if (old_level != level) {
> +		current_level = ec_read(REG_DISPLAY_BRIGHTNESS);
> +		if (old_level == current_level)
> +			ec_write(REG_DISPLAY_BRIGHTNESS, level);
> +	}
> +	old_level = level;

Will move the above line into the end of "if { ... }".

Regards,
	Wu Zhangjin

