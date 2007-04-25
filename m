Return-Path: <linux-kernel-owner+w=401wt.eu-S1423250AbXDYHTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423250AbXDYHTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 03:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423252AbXDYHTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 03:19:42 -0400
Received: from smtp1-g19.free.fr ([212.27.42.27]:59194 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423250AbXDYHTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 03:19:41 -0400
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: Simon Arlott <simon@fire.lp0.eu>
Subject: Re: [PATCH] cxacru: Cleanup sysfs attribute code
Date: Wed, 25 Apr 2007 09:19:50 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
References: <462E730F.3090401@simon.arlott.org.uk>
In-Reply-To: <462E730F.3090401@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704250919.50382.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

>  static ssize_t cxacru_sysfs_showattr_dB(s16 value, char *buf)
>  {
> -	if (unlikely(value < 0)) {
> -		return snprintf(buf, PAGE_SIZE, "%d.%02u\n",
> -						value / 100, -value % 100);
> -	} else {
> -		return snprintf(buf, PAGE_SIZE, "%d.%02u\n",
> -						value / 100, value % 100);
> -	}
> +	return snprintf(buf, PAGE_SIZE, "%u.%02u\n",
> +					value / 100, abs(value) % 100);

shouldn't this be "%d.%02u\n"?

> +	static char *str[] = { "no", "yes" };
...
> +	return snprintf(buf, PAGE_SIZE, "%s\n", str[value]);

This could be
	static char *str[] = { "no\n", "yes\n" };
...
	return snprintf(buf, PAGE_SIZE, str[value]);
I'm not saying that it's better, just a remark!

Ciao,

Duncan.
