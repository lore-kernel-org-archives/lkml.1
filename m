Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933692Ab0BYUnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 15:43:16 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:30913 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933640Ab0BYUnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 15:43:15 -0500
Subject: Re: [PATCH 0/7] tcp: bugs and cleanup for 2.6.33
From: Ben Hutchings <bhutchings@solarflare.com>
To: William Allen Simpson <william.allen.simpson@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>
In-Reply-To: <4B86DEC6.1090307@gmail.com>
References: <4B86DDCB.50608@gmail.com>  <4B86DEC6.1090307@gmail.com>
Content-Type: text/plain
Organization: Solarflare Communications
Date: Thu, 25 Feb 2010 20:43:11 +0000
Message-Id: <1267130591.2107.16.camel@achroite.uk.solarflarecom.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Feb 2010 20:43:19.0351 (UTC) FILETIME=[29D3DC70:01CAB65B]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.000.1038-17214.005
X-TM-AS-Result: No--24.534700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-25 at 15:34 -0500, William Allen Simpson wrote:
> Redefine two TCP header functions to accept TCP header pointer.
> When subtracting, return signed int to allow error checking.

This patch only adds functions, so why do you say 'redefine'?

> These functions will be used in subsequent patches that implement
> additional features.
[...]
> +/* Length of standard options only.  This could be negative. */
> +static inline int tcp_option_len_th(const struct tcphdr *th)
> +{
> +       return (int)(th->doff * 4) - sizeof(*th);
> +}

I don't see  the point of this cast; the left operand of the subtraction
will in any case be promoted to size_t to match the right operand.

Did you mean
	return (int)(th->doff * 4 - sizeof(*th));
?

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

