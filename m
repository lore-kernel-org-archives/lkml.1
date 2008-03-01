Return-Path: <linux-kernel-owner+w=401wt.eu-S1758722AbYCAJip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722AbYCAJip (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 04:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbYCAJih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 04:38:37 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:38299 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbYCAJig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 04:38:36 -0500
Date: Sat, 1 Mar 2008 11:37:12 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: sfrench@samba.org, linux-cifs-client@lists.samba.org,
       samba-technical@lists.samba.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][fs/cifs/cifsfs.c] Make use of cifs_xquota_get
Message-ID: <20080301093712.GB25835@cs181133002.pp.htv.fi>
References: <47B08A0B.4020604@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47B08A0B.4020604@tiscali.nl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 06:46:51PM +0100, Roel Kluin wrote:
> Functions cifs_xquota_set and cifs_xquota_get at respectively
> fs/cifs/cifsfs.c:367 and 392 are entirely similar - except for
> whitespace
> 
> struct quotactl_ops contains function pointers .set_xquota and
> .get_xquota that both get the address of cifs_xquota_set.
> cifs_xquota_get isn't called anywhere else in the kernel.
> 
> The patch below makes use of the function cifs_xquota_get, As
> an alternative the entire function cifs_xquota_get could be 
> removed.
> ---
> Make use of cifs_xquota_get
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index fcc4342..339b829 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -461,7 +461,7 @@ int cifs_xstate_get(struct super_block *sb, struct fs_quota_stat *qstats)
>  
>  static struct quotactl_ops cifs_quotactl_ops = {
>  	.set_xquota	= cifs_xquota_set,
> -	.get_xquota	= cifs_xquota_set,
> +	.get_xquota	= cifs_xquota_get,
>  	.set_xstate	= cifs_xstate_set,
>  	.get_xstate	= cifs_xstate_get,
>  };

Steve, this obvious bugfix seems to be stuck in cifs-2.6.git.

Can you forward this fix (and other fixes if you have any) to Linus soon?

TIA
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


