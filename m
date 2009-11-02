Return-Path: <linux-kernel-owner+w=401wt.eu-S932114AbZKBSTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbZKBSTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 13:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756492AbZKBSTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 13:19:49 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:56449 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756406AbZKBSTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 13:19:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=wYiBmlKcHLPjLeKVXMW5uznlhbLL3nQ96lXQhE/4v9Iq5WO385RM8IGn2/Tk0IPSpc
         KsDzF7qJ8H6+Ar9Rhk9lxrDfE7kcpu7t83VOh7LSf3ypfox2vcvzkdzXdnHiqfWdiTHR
         aecRg5GjJ9HWMKKK+dpFedLtNw6qoY6H2xyk4=
Date: Mon, 2 Nov 2009 19:19:53 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: =?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>
Cc: laijs@cn.fujitsu.com, mingo@elte.hu, davem@davemloft.net,
       akpm@linux-foundation.org, harvey.harrison@gmail.com,
       linux list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/7] vsprintf: reduce code size by avoiding extra
	check
Message-ID: <20091102181944.GA4880@nowhere>
References: <b8bf37780911020926rd5e40b1h957c803f7bb21196@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b8bf37780911020926rd5e40b1h957c803f7bb21196@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 03:26:36PM -0200, André Goddard Rosa wrote:
> From fd3098fe2764b049e23ea125a20979410699d257 Mon Sep 17 00:00:00 2001
> From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
> Date: Sun, 1 Nov 2009 13:46:26 -0200
> Subject: [PATCH v2 5/7] vsprintf: reduce code size by avoiding extra check
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
>    text    data     bss     dec     hex filename
>   15735       0       8   15743    3d7f lib/vsprintf.o-before
>   15719       0       8   15727    3d6f lib/vsprintf.o-minus-double-check
> 
> Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>



Please add a changelog in your patches, I mean something that
explain your practical change.

I'm not sure this change is necessary, the only impact is a small
reduce of binary code. Well, why not.


> ---
>  lib/vsprintf.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 14e4197..af79152 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -747,8 +747,9 @@ static char *ip6_compressed_string(char *p, const
> char *addr)
>  				p = pack_hex_byte(p, hi);
>  			else
>  				*p++ = hex_asc_lo(hi);
> +			p = pack_hex_byte(p, lo);
>  		}
> -		if (hi || lo > 0x0f)
> +		else if (lo > 0x0f)
>  			p = pack_hex_byte(p, lo);
>  		else
>  			*p++ = hex_asc_lo(lo);
> -- 
> 1.6.5.2.140.g5f809

