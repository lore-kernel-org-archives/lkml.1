Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbZLGGs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbZLGGs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 01:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbZLGGs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 01:48:57 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:51741 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbZLGGs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 01:48:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NsGhP62BIU7rMU77428bagzQeHPYbMPcyPmFUW4n3VBgDGc7KcD/1h5SGc2kzk6vAs
         lj+r/fYtcAAhmWf0YwIr+RIH0GagmV2bQV3gFbTGgm6NIncqIiOvG6bWZmHw6XQGzZch
         uxss7dyC9HqsrHyUoaLzymDQhQaaoZk5LPvFE=
Date: Sun, 6 Dec 2009 22:48:57 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, akpm@linux-foundation.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       "Rafael J . Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       linux-laptop@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v8 8/8] Loongson: YeeLoong: add input/hotkey driver
Message-ID: <20091207064857.GG21451@core.coreip.homeip.net>
References: <cover.1260082252.git.wuzhangjin@gmail.com> <b164d5bb79963a57621d024c22e5664de0ff8662.1260082252.git.wuzhangjin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b164d5bb79963a57621d024c22e5664de0ff8662.1260082252.git.wuzhangjin@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wu,

On Sun, Dec 06, 2009 at 03:01:48PM +0800, Wu Zhangjin wrote:
> +
> +#define EC_VER_LEN 64
> +
> +static int black_screen_handler(int status)
> +{
> +	char *p, ec_ver[EC_VER_LEN];
> +
> +	p = strstr(loongson_cmdline, "EC_VER=");
> +	if (!p)
> +		memset(ec_ver, 0, EC_VER_LEN);
> +	else {
> +		strncpy(ec_ver, p, EC_VER_LEN);
> +		p = strstr(ec_ver, " ");
> +		if (p)
> +			*p = '\0';
> +	}
> +

Hmm, why do you copy and parse command lineinstead of using module
param and also doing it just once?

> +	/* Seems EC(>=PQ1D26) does this job for us, we can not do it again,
> +	 * otherwise, the brightness will not resume to the normal level! */
> +	if (strncasecmp(ec_ver, "EC_VER=PQ1D26", 64) < 0)
> +		yeeloong_lcd_vo_set(status);
> +
> +	return status;
> +}

Thanks.

-- 
Dmitry
