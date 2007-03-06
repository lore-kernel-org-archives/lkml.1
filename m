Return-Path: <linux-kernel-owner+w=401wt.eu-S965058AbXCFOTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965058AbXCFOTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 09:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965057AbXCFOTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 09:19:23 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:39327 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965051AbXCFOTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 09:19:22 -0500
From: Eric Dumazet <dada1@cosmosbay.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] div64_64 support
Date: Tue, 6 Mar 2007 15:19:20 +0100
User-Agent: KMail/1.9.5
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
References: <20070223170527.4ca695b2@freekitty> <20070305155714.3abe1b5e@freekitty> <20070306133404.GA864@one.firstfloor.org>
In-Reply-To: <20070306133404.GA864@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703061519.20346.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 March 2007 14:34, Andi Kleen wrote:

> -	return x;
> +	int s;
> +	u32 y;
> +	u64 b;
> +	u64 bs;
> +
> +	y = 0;
> +	for (s = 63; s >= 0; s -= 3) {
> +		y = 2 * y;
> +		b = 3 * y * (y+1) + 1;
> +		bs = b << s;
> +		if (x >= bs && (b == (bs>>s))) {  /* avoid overflow */
> +			x -= bs;
> +			y++;
> +		}
> +	}
> +	return y;
>  }
>

Andi

<rant>
Let me see... You throw code like that and expect someone to actually 
understand it in one year, and be able to correct a bug ?
</rant>

Please add something, an URL or even better a nice explanation, per favor...

Thank you
