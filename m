Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab0CMGZK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 01:25:10 -0500
Received: from 1wt.eu ([62.212.114.60]:58146 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab0CMGZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 01:25:09 -0500
Date: Sat, 13 Mar 2010 07:24:46 +0100
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Patrick McHardy <kaber@trash.net>, akpm@linux-foundation.org,
       Tim Gardner <tim.gardner@canonical.com>, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [104/145] netfilter: xt_recent: fix false match
Message-ID: <20100313062446.GG12342@1wt.eu>
References: <20100313002816.GA18903@kroah.com> <20100313002714.299272135@kvm.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100313002714.299272135@kvm.kroah.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 04:27:17PM -0800, Greg KH wrote:
> 2.6.32-stable review patch.  If anyone has any objections, please let me know.
> 
> ----------------
> From: Tim Gardner <tim.gardner@canonical.com>
> 
> commit 8ccb92ad41cb311e52ad1b1fe77992c7f47a3b63 upstream.
> 
> A rule with a zero hit_count will always match.
> 
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> Signed-off-by: Patrick McHardy <kaber@trash.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  net/netfilter/xt_recent.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/net/netfilter/xt_recent.c
> +++ b/net/netfilter/xt_recent.c
> @@ -260,7 +260,7 @@ recent_mt(const struct sk_buff *skb, con
>  		for (i = 0; i < e->nstamps; i++) {
>  			if (info->seconds && time_after(time, e->stamps[i]))
>  				continue;
> -			if (++hits >= info->hit_count) {
> +			if (info->hit_count && ++hits >= info->hit_count) {
>  				ret = !ret;
>  				break;
>  			}

I don't know if this has any undesired side effect or not, but the
logic is changed now since "hits" will not be increased anymore when
info->hit_count is zero. And the code does not make it obvious to me
what the intended purpose was.

For this reason I always find it dangerous to change variables in
if() conditions because it's where we change operations the most
frequently when fixing bugs.

Willy

