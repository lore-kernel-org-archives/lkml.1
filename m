Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbYFDGO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbYFDGO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 02:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbYFDGOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 02:14:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:30221 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbYFDGOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 02:14:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=O3EW6eEw2rhaJSOKhoTODXiXzMGbYaGVMOfag2Ojal8a+895VJEUCN8yEzf3Kk6HpTLXof2dnN1D0zGPGhchtXDRmyW/K9052mLJSxsh+EDpMGoX2guuk1dT1YXUFzJxGedBgTorlsazPpWM8B2jBr1UkUaNaM66KiqrbjdQVK8=
Message-ID: <524f69650806032314j17554909h1a0c0d8f0e9b7820@mail.gmail.com>
Date: Wed, 4 Jun 2008 01:14:46 -0500
From: "Steve French" <smfrench@gmail.com>
To: torvalds@linux-foundation.org
Subject: Re: [PATCH] cifs endianness fixes
Cc: sfrench@samba.org, linux-kernel@vger.kernel.org,
       "Al Viro" <viro@ftp.linux.org.uk>
In-Reply-To: <E1K36og-0007Z3-Hm@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1K36og-0007Z3-Hm@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACK

Please merge

On Mon, Jun 2, 2008 at 4:59 AM, Al Viro <viro@ftp.linux.org.uk> wrote:
>
> __le16 fields used as host-endian.
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 9b8b4cf..fb655b4 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -3927,9 +3927,9 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER_RSP *pSMBr,
>        }
>
>        ref = (struct dfs_referral_level_3 *) &(pSMBr->referrals);
> -       if (ref->VersionNumber != 3) {
> +       if (ref->VersionNumber != cpu_to_le16(3)) {
>                cERROR(1, ("Referrals of V%d version are not supported,"
> -                       "should be V3", ref->VersionNumber));
> +                       "should be V3", le16_to_cpu(ref->VersionNumber)));
>                rc = -EINVAL;
>                goto parse_DFS_referrals_exit;
>        }
> @@ -3977,7 +3977,7 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER_RSP *pSMBr,
>                if (rc)
>                        goto parse_DFS_referrals_exit;
>
> -               ref += ref->Size;
> +               ref += le16_to_cpu(ref->Size);
>        }
>
>  parse_DFS_referrals_exit:
>



-- 
Thanks,

Steve
