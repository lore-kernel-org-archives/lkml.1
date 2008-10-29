Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbYJ2M62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbYJ2M62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 08:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbYJ2M6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 08:58:17 -0400
Received: from gw.goop.org ([64.81.55.164]:43416 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbYJ2M6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 08:58:16 -0400
Message-ID: <49085DE3.4010508@goop.org>
Date: Wed, 29 Oct 2008 23:58:11 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Joe Damato <ice799@gmail.com>
CC: linux-x86_64@vger.kernel.org, linux-newbie@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/12] x86: Add static initiazlier for descriptors
References: <> <1224904532-9586-1-git-send-email-ice799@gmail.com> <52f8491fb5d55c0171840b01638ea6db0a98f3be.1224903712.git.ice799@gmail.com> <03269a2e8f455b431612a32e8cce048e98c75b27.1224903712.git.ice799@gmail.com> <4810cc08c12cd78612b53f9b52d7ba93a9b03fd0.1224903712.git.ice799@gmail.com> <a9cabc5cabdb5a10631e2a6dc330c54826f2b210.1224903712.git.ice799@gmail.com> <a4c806abcf7a46c78aaff4e338fdbc1a06a56c88.1224903712.git.ice799@gmail.com> <8834ad1ab5a5ab9b4902ab708160b23f078f3758.1224903712.git.ice799@gmail.com> <4d0ab6d642a4edc3ecc7367df7043ecc8f0a7f98.1224903712.git.ice799@gmail.com> <c53b3a54b3215187055dfe5673e1351d1bd3957a.1224903712.git.ice799@gmail.com> <e1bbf5a92bbf8fcf36dcbb650ee5f22d48d4b0f4.1224903712.git.ice799@gmail.com>
In-Reply-To: <e1bbf5a92bbf8fcf36dcbb650ee5f22d48d4b0f4.1224903712.git.ice799@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Damato wrote:
> Add static initializer for LDT/GDT/TSS descriptors.
>
> Signed-off-by: Joe Damato <ice799@gmail.com>
> ---
>  include/asm-x86/desc_defs.h |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
>
> diff --git a/include/asm-x86/desc_defs.h b/include/asm-x86/desc_defs.h
> index a1c6516..5119051 100644
> --- a/include/asm-x86/desc_defs.h
> +++ b/include/asm-x86/desc_defs.h
> @@ -91,6 +91,20 @@ typedef struct desc_struct tss_desc;
>                  , .dpl = (hi >> 13) & 3 \
>                  , .p   = (hi >> 15) & 1 \
>                  , .base1 = (hi >> 16) & 0xffff }
> +#define __DESC_INITIALIZER(lo,hi) \
> +                { .limit0 = lo & 0xffff \
> +                , .base0  = (lo >> 16) & 0xffff \
> +                , .base1  = hi & 0xff \
> +                , .type   = (hi >> 8) & 0xf \
> +                , .s      = (hi >> 12) & 1 \
> +                , .dpl    = (hi >> 13) & 3 \
> +                , .p      = (hi >> 15) & 1 \
> +                , .limit  = (hi >> 16) & 0xf \
> +                , .avl    = (hi >> 20) & 1 \
> +                , .l      = (hi >> 21) & 1 \
> +                , .d      = (hi >> 22) & 1 \
> +                , .g      = (hi >> 23) & 1 \
> +                ,.base2   = (hi >> 24) & 0xf }
>   

Reasonable as a transition, I guess, but it would be better to just make 
the initializers pass in proper values.  But I think it would be better 
to implement this with a union rather than repacking the packed values.

    J
