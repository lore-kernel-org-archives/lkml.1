Return-Path: <linux-kernel-owner+w=401wt.eu-S1758282AbZBLJRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282AbZBLJRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 04:17:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756176AbZBLJQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 04:16:45 -0500
Received: from stinky.trash.net ([213.144.137.162]:44820 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175AbZBLJQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 04:16:43 -0500
Message-ID: <4993E8F7.6070007@trash.net>
Date: Thu, 12 Feb 2009 10:16:39 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
CC: wli@movementarian.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] Update jhash.h with the new version of Jenkins' hash
References: <alpine.DEB.2.00.0902111107480.15665@blackhole.kfki.hu> <20090212001223.GA5757@movementarian.org> <alpine.DEB.2.00.0902121006440.18739@blackhole.kfki.hu>
In-Reply-To: <alpine.DEB.2.00.0902121006440.18739@blackhole.kfki.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jozsef Kadlecsik wrote:
> -#define __jhash_mix(a, b, c) \
> +#define __rot(x,k) (((x)<<(k)) | ((x)>>(32-(k))))
> +
> +/* __jhash_mix - mix 3 32-bit values reversibly. */
> +#define __jhash_mix(a,b,c) \
> +{ \
> +  a -= c;  a ^= __rot(c, 4);  c += b; \
> +  b -= a;  b ^= __rot(a, 6);  a += c; \
> +  c -= b;  c ^= __rot(b, 8);  b += a; \
> +  a -= c;  a ^= __rot(c,16);  c += b; \
> +  b -= a;  b ^= __rot(a,19);  a += c; \
> +  c -= b;  c ^= __rot(b, 4);  b += a; \
> +}

include/linux/bitops.h includes multiple rot variants. rol32()
looks approriate.
