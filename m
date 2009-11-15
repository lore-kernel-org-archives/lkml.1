Return-Path: <linux-kernel-owner+w=401wt.eu-S1752210AbZKOXkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbZKOXkh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 18:40:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbZKOXkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 18:40:36 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:63998 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbZKOXkf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 18:40:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aCcQ60RV6XjGSCz+YfOx0PYzkftpnS9/jOH+gDk/Ts0vUe19fN6AKIdw+ORRaUDTvn
         Lo/j/CWx30LppqmnO+ucKxkjOZwgl4EI4zNcTwfj+a9MzdIYzwHw+9WxdM2k89sh17fi
         oViZGcY44pmYdyI7YDIot3ihuSAC0ba3TRmGM=
MIME-Version: 1.0
In-Reply-To: <1257432215-6146-1-git-send-email-jglisse@redhat.com>
References: <1257432215-6146-1-git-send-email-jglisse@redhat.com>
Date: Mon, 16 Nov 2009 09:40:40 +1000
Message-ID: <21d7e9970911151540q507e61d6o3388aff17e23fea9@mail.gmail.com>
Subject: Re: [PATCH] drm/ttm: Dead code elimination & comment addition
From: Dave Airlie <airlied@gmail.com>
To: Jerome Glisse <jglisse@redhat.com>
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org, thomas@shipmail.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 6, 2009 at 12:43 AM, Jerome Glisse <jglisse@redhat.com> wrote:
> Remove dead code in ttm_bo_handle_mem_move and add comment on
> what we are doing their and why.
>

I haven't seen Thomas's ACK on this? I'd like to keep TTM under his control ;-)

Dave.

> Signed-off-by: Jerome Glisse <jglisse@redhat.com>
> ---
>  drivers/gpu/drm/ttm/ttm_bo.c |   14 +++++---------
>  1 files changed, 5 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
> index 87c0625..aea4699 100644
> --- a/drivers/gpu/drm/ttm/ttm_bo.c
> +++ b/drivers/gpu/drm/ttm/ttm_bo.c
> @@ -309,9 +309,8 @@ static int ttm_bo_handle_move_mem(struct ttm_buffer_object *bo,
>                ttm_bo_unmap_virtual(bo);
>
>        /*
> -        * Create and bind a ttm if required.
> +        * Create and bind a ttm if new placement is not on card memory.
>         */
> -
>        if (!(new_man->flags & TTM_MEMTYPE_FLAG_FIXED) && (bo->ttm == NULL)) {
>                ret = ttm_bo_add_ttm(bo, false);
>                if (ret)
> @@ -327,15 +326,12 @@ static int ttm_bo_handle_move_mem(struct ttm_buffer_object *bo,
>                                goto out_err;
>                }
>
> +               /* New placement is not on card and old placement is system
> +                * memory we can thus simply copy new placement informations
> +                */
>                if (bo->mem.mem_type == TTM_PL_SYSTEM) {
> -
> -                       struct ttm_mem_reg *old_mem = &bo->mem;
> -                       uint32_t save_flags = old_mem->placement;
> -
> -                       *old_mem = *mem;
> +                       bo->mem = *mem;
>                        mem->mm_node = NULL;
> -                       ttm_flag_masked(&save_flags, mem->placement,
> -                                       TTM_PL_MASK_MEMTYPE);
>                        goto moved;
>                }
>
> --
> 1.6.5.1
>
>
