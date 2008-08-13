Return-Path: <linux-kernel-owner+w=401wt.eu-S1752663AbYHMEUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbYHMEUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 00:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751066AbYHMEUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 00:20:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53890 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750973AbYHMEUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 00:20:37 -0400
Date: Tue, 12 Aug 2008 21:20:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       per.liden@ericsson.com, jon.maloy@ericsson.com,
       allan.stephens@windriver.com
Subject: Re: [PATCH] tipc: Use the appropriate swab helper rather than an
 internal helper
Message-Id: <20080812212017.febf1392.akpm@linux-foundation.org>
In-Reply-To: <1218600348.30194.105.camel@brick>
References: <1218587234.30194.93.camel@brick>
	<20080812205422.4273d598.akpm@linux-foundation.org>
	<1218600348.30194.105.camel@brick>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2008 21:05:47 -0700 Harvey Harrison <harvey.harrison@gmail.com> wrote:

> ___generally means I am an internal implementation detail, don't use
> me.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Sorry for breaking the build Andrew, my testing has been with all the __constant
> versions in-tree removed.
> 
>  net/tipc/subscr.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/tipc/subscr.c b/net/tipc/subscr.c
> index 0326d30..f5da05d 100644
> --- a/net/tipc/subscr.c
> +++ b/net/tipc/subscr.c
> @@ -85,7 +85,7 @@ static struct top_srv topsrv = { 0 };
>  
>  static u32 htohl(u32 in, int swap)
>  {
> -	return swap ? (u32)___constant_swab32(in) : in;
> +	return swap ? (u32)swab32(in) : in;
>  }

yes, that's what I did too, only I dropped the
seems-to-me-to-be-unneeded (u32) cast.
