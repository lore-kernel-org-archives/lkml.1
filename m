Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524Ab0A0PLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab0A0PLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 10:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754356Ab0A0PLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 10:11:15 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56833 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab0A0PLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 10:11:14 -0500
Message-ID: <4B605779.9010500@cs.helsinki.fi>
Date: Wed, 27 Jan 2010 17:10:49 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Nitin Gupta <ngupta@vflare.org>
CC: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] use lock for 64-bit stats
References: <1264602246-12880-1-git-send-email-ngupta@vflare.org> <1264602246-12880-2-git-send-email-ngupta@vflare.org>
In-Reply-To: <1264602246-12880-2-git-send-email-ngupta@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nitin Gupta wrote:
> +static void stat_dec(u32 *v)
> +{
> +	*v = *v - 1;
> +}
> +
> +static void stat64_inc(struct ramzswap *rzs, u64 *v)
> +{
> +	spin_lock(&rzs->stat64_lock);
> +	*v = *v + 1;
> +	spin_unlock(&rzs->stat64_lock);
> +}
> +
> +static void stat64_dec(struct ramzswap *rzs, u64 *v)
> +{
> +	spin_lock(&rzs->stat64_lock);
> +	*v = *v - 1;
> +	spin_unlock(&rzs->stat64_lock);
> +}
> +
> +static u64 stat64_read(struct ramzswap *rzs, u64 *v)
> +{
> +	u64 val;
> +
> +	spin_lock(&rzs->stat64_lock);
> +	val = *v;
> +	spin_unlock(&rzs->stat64_lock);
> +
> +	return val;
> +}
> +#else
> +#define stat_inc(v)
> +#define stat_dec(v)
> +#define stat64_inc(r, v)
> +#define stat64_dec(r, v)
> +#define stat64_read(r, v)
> +#endif /* CONFIG_RAMZSWAP_STATS */

I think I complained about this before: the names are too generic and 
could collide with core kernel code. I think they ought to be called 
ramzsawp_stat*().

			Pekka
