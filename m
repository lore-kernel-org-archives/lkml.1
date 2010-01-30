Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181Ab0A3P00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab0A3P00 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 10:26:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742Ab0A3P0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 10:26:25 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:58538 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751070Ab0A3P0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 10:26:24 -0500
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Jan 2010 10:26:24 EST
Message-ID: <4B644E11.5060002@vmware.com>
Date: Sat, 30 Jan 2010 16:19:45 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090822)
MIME-Version: 1.0
To: Richard Kennedy <richard@rsk.demon.co.uk>
CC: David Airlie <airlied@linux.ie>, lkml <linux-kernel@vger.kernel.org>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>
Subject: Re: [PATCH] drm/ttm: remove padding from ttm_ref_object on 64bit
 builds
References: <1264525848.2044.5.camel@localhost>
In-Reply-To: <1264525848.2044.5.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Kennedy wrote:
> Re-order structure ttm_ref_object to remove 8 bytes of alignment padding
> on 64 bit builds, so shrinking its size from 72 to 64 bytes allowing it
> to fit into a smaller slab.
>
> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
> ----
> patch against 2.6.33-rc5
> compiled & tested on x86_64 AMDX2 and nouveau 
> regards
> Richard
>
>
> diff --git a/drivers/gpu/drm/ttm/ttm_object.c b/drivers/gpu/drm/ttm/ttm_object.c
> index 1099aba..75e9d6f 100644
> --- a/drivers/gpu/drm/ttm/ttm_object.c
> +++ b/drivers/gpu/drm/ttm/ttm_object.c
> @@ -109,8 +109,8 @@ struct ttm_ref_object {
>  	struct drm_hash_item hash;
>  	struct list_head head;
>  	struct kref kref;
> -	struct ttm_base_object *obj;
>  	enum ttm_ref_type ref_type;
> +	struct ttm_base_object *obj;
>  	struct ttm_object_file *tfile;
>  };
>  
>
>
>   
Acked-by: Thomas Hellstrom <thellstrom@vmware.com>


