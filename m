Return-Path: <linux-kernel-owner+w=401wt.eu-S933594AbXHXBmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933594AbXHXBmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 21:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764823AbXHXBmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 21:42:15 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:40903 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764697AbXHXBmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 21:42:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Zab7o9m15IFci/JoPjCeEdn7UbwGKd8LRU8NwMgTO3owXHhVGLzr+E7fu40/SaVl41lFI1QJHZay/bQMWH78qekVtF34QOshoM1kGsxf6a1Cc7mm2LuwaTUNgZApUPUbbmkJsTxjaoxzNQSOaiwvOOxSMy2ya289xGmUjsBRjZM=
Message-ID: <524f69650708231842p2d8fab64u7021e9d68cda072e@mail.gmail.com>
Date: Thu, 23 Aug 2007 20:42:13 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH] CIFS: fix unbalanced calls to Get/FreeXid
Cc: "Steve French" <sfrench@samba.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070823163917.GB7222@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070823163917.GB7222@cvg>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

merged into cifs-2.6.git tree

On 8/23/07, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> This patch fixes unbalanced calls to GetXid/FreeXid.
>
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
>
>  fs/cifs/cifsfs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index cabb6a5..2493cc4 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -346,7 +346,7 @@ int cifs_xquota_set(struct super_block *sb, int quota_type, qid_t qid,
>         if (pTcon) {
>                 cFYI(1, ("set type: 0x%x id: %d", quota_type, qid));
>         } else {
> -               return -EIO;
> +               rc = -EIO;
>         }
>
>         FreeXid(xid);
>


-- 
Thanks,

Steve
