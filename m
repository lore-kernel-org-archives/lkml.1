Return-Path: <linux-kernel-owner+w=401wt.eu-S1758029AbZCBMGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029AbZCBMGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 07:06:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbZCBMGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 07:06:36 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45695 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120AbZCBMGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 07:06:35 -0500
Subject: Re: [PATCH 1/2] GFS2: fix sparse warnings: constant is so big it
	is ...
From: Steven Whitehouse <swhiteho@redhat.com>
To: Hannes Eder <hannes@hanneseder.net>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090221011125.5075.23703.stgit@vmbox.hanneseder.net>
References: <20090221011033.5075.95929.stgit@vmbox.hanneseder.net>
	 <20090221011125.5075.23703.stgit@vmbox.hanneseder.net>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Mon, 02 Mar 2009 12:01:22 +0000
Message-Id: <1235995282.9571.822.camel@quoit>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry for the delay - I'm back from holiday now and I've applied this
patch to the -nmw git tree. Thanks,

Steve.

On Sat, 2009-02-21 at 02:11 +0100, Hannes Eder wrote:
> Fix this sparse warnings:
>   fs/gfs2/rgrp.c:156:23: warning: constant 0xffffffffffffffff is so big it is unsigned long long
>   fs/gfs2/rgrp.c:157:23: warning: constant 0xaaaaaaaaaaaaaaaa is so big it is unsigned long long
>   fs/gfs2/rgrp.c:158:23: warning: constant 0x5555555555555555 is so big it is long long
>   fs/gfs2/rgrp.c:194:20: warning: constant 0x5555555555555555 is so big it is long long
>   fs/gfs2/rgrp.c:204:44: warning: constant 0x5555555555555555 is so big it is long long
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> ---
>  fs/gfs2/rgrp.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
> index c0abe69..34691d7 100644
> --- a/fs/gfs2/rgrp.c
> +++ b/fs/gfs2/rgrp.c
> @@ -153,10 +153,10 @@ static inline u64 gfs2_bit_search(const __le64 *ptr, u64 mask, u8 state)
>  {
>  	u64 tmp;
>  	static const u64 search[] = {
> -		[0] = 0xffffffffffffffff,
> -		[1] = 0xaaaaaaaaaaaaaaaa,
> -		[2] = 0x5555555555555555,
> -		[3] = 0x0000000000000000,
> +		[0] = 0xffffffffffffffffULL,
> +		[1] = 0xaaaaaaaaaaaaaaaaULL,
> +		[2] = 0x5555555555555555ULL,
> +		[3] = 0x0000000000000000ULL,
>  	};
>  	tmp = le64_to_cpu(*ptr) ^ search[state];
>  	tmp &= (tmp >> 1);
> @@ -191,7 +191,7 @@ u32 gfs2_bitfit(const u8 *buf, const unsigned int len, u32 goal, u8 state)
>  	const __le64 *ptr = ((__le64 *)buf) + (goal >> 5);
>  	const __le64 *end = (__le64 *)(buf + ALIGN(len, sizeof(u64)));
>  	u64 tmp;
> -	u64 mask = 0x5555555555555555;
> +	u64 mask = 0x5555555555555555ULL;
>  	u32 bit;
>  
>  	BUG_ON(state > 3);
> @@ -201,7 +201,7 @@ u32 gfs2_bitfit(const u8 *buf, const unsigned int len, u32 goal, u8 state)
>  	tmp = gfs2_bit_search(ptr, mask, state);
>  	ptr++;
>  	while(tmp == 0 && ptr < end) {
> -		tmp = gfs2_bit_search(ptr, 0x5555555555555555, state);
> +		tmp = gfs2_bit_search(ptr, 0x5555555555555555ULL, state);
>  		ptr++;
>  	}
>  	/* Mask off any bits which are more than len bytes from the start */
> 

