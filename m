Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbZCAQvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbZCAQvw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 11:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbZCAQvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 11:51:43 -0500
Received: from ns2.suse.de ([195.135.220.15]:47440 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbZCAQvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 11:51:42 -0500
Date: Sun, 1 Mar 2009 17:51:39 +0100
From: Karsten Keil <kkeil@suse.de>
To: Frank Seidel <fseidel@suse.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       kkeil@suse.de, linux-isdn@vger.kernel.org,
       Frank Seidel <frank@f-seidel.de>,
       Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Andreas Eversberg <andreas@eversberg.eu>,
       Hannes Eder <hannes@hanneseder.net>, Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] isdn: reduce stack size of mISDN_dsp
Message-ID: <20090301165139.GA15287@pingi.kke.suse.de>
References: <49AAB8B2.8060801@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AAB8B2.8060801@suse.de>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.60-0.34-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 01, 2009 at 05:32:50PM +0100, Frank Seidel wrote:
> From: Frank Seidel <frank@f-seidel.de>
> 
> Reduce stack size memory footprint of mISDN_dsp.
> (From 1468 bytes for dsp_cmx_send on i386 down
> to 44).
> 

I do not think we can use a static buffer here,
we may have multiple instances.

> Signed-off-by: Frank Seidel <frank@f-seidel.de>
> ---
>  drivers/isdn/mISDN/dsp_cmx.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- a/drivers/isdn/mISDN/dsp_cmx.c
> +++ b/drivers/isdn/mISDN/dsp_cmx.c
> @@ -1592,7 +1592,8 @@ dsp_cmx_send(void *arg)
>  	struct dsp_conf_member *member;
>  	struct dsp *dsp;
>  	int mustmix, members;
> -	s32 mixbuffer[MAX_POLL+100], *c;
> +	static s32 mixbuffer[MAX_POLL+100];
> +	s32 *c;
>  	u8 *p, *q;
>  	int r, rr;
>  	int jittercheck = 0, delay, i;

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
