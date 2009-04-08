Return-Path: <linux-kernel-owner+w=401wt.eu-S932874AbZDHMRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874AbZDHMRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763760AbZDHMPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:15:23 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:38022 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764098AbZDHMPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:15:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gCg61WodkudPlSGeWkDGrZqOYTUDurYcruRNiI4SV5Kl0zQQhLEN2UwaIGADT+PTWr
         H5dYFELDph8CopY2/9nyDzVA95uWJbf5dkwPsmn04gdXnWnwr53Jwa/EQHrUvFCOLyI/
         qpZdX4vnHBnf5dNKonO8++rtOmwmJysaznx2o=
MIME-Version: 1.0
In-Reply-To: <1239189748-11703-57-git-send-email-jwjstone@fastmail.fm>
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-49-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-50-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-51-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-52-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-53-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-54-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-55-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-56-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-57-git-send-email-jwjstone@fastmail.fm>
Date: Wed, 8 Apr 2009 14:15:17 +0200
Message-ID: <36ca99e90904080515w339dd1d1ge5bfb546cec5e4b8@mail.gmail.com>
Subject: Re: [PATCH 56/56] xfs: Remove void casts
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n38CHkqu029828

On Wed, Apr 8, 2009 at 13:22, Jack Stone <jwjstone@fastmail.fm> wrote:> Remove uneeded void casts>> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>> --->  fs/xfs/quota/xfs_dquot_item.c |    2 +->  fs/xfs/support/ktrace.c       |    6 +++--->  fs/xfs/xfs_attr_leaf.c        |    2 +->  fs/xfs/xfs_buf_item.c         |    6 +++--->  fs/xfs/xfs_extfree_item.c     |    8 ++++---->  fs/xfs/xfs_inode.c            |    5 ++--->  fs/xfs/xfs_log_recover.c      |    9 ++++----->  fs/xfs/xfs_trans.c            |    2 +->  fs/xfs/xfs_trans_inode.c      |    3 +-->  fs/xfs/xfs_trans_item.c       |    6 ++---->  10 files changed, 22 insertions(+), 27 deletions(-)>> diff --git a/fs/xfs/support/ktrace.c b/fs/xfs/support/ktrace.c> index 2d494c2..3982acf 100644> --- a/fs/xfs/support/ktrace.c> +++ b/fs/xfs/support/ktrace.c> @@ -75,10 +75,10 @@ ktrace_alloc(int nentries, unsigned int __nocast sleep)>         */>        entries = roundup_pow_of_two(nentries);>        if (entries == ktrace_zentries) {> -               ktep = (ktrace_entry_t*)kmem_zone_zalloc(ktrace_ent_zone,> +               ktep = kmem_zone_zalloc(ktrace_ent_zone,>                                                            sleep);Dito.
>        } else {> -               ktep = (ktrace_entry_t*)kmem_zalloc((entries * sizeof(*ktep)),> +               ktep = kmem_zalloc((entries * sizeof(*ktep)),>                                                            sleep | KM_LARGE);Please check.
>        }>> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c> index 92af409..431755a 100644> --- a/fs/xfs/xfs_buf_item.c> +++ b/fs/xfs/xfs_buf_item.c> @@ -726,7 +726,7 @@ xfs_buf_item_init(>        chunks = (int)((XFS_BUF_COUNT(bp) + (XFS_BLI_CHUNK - 1)) >> XFS_BLI_SHIFT);>        map_size = (int)((chunks + NBWORD) >> BIT_TO_WORD_SHIFT);>> -       bip = (xfs_buf_log_item_t*)kmem_zone_zalloc(xfs_buf_item_zone,> +       bip = kmem_zone_zalloc(xfs_buf_item_zone,>                                                    KM_SLEEP);Dito.
>        bip->bli_item.li_type = XFS_LI_BUF;>        bip->bli_item.li_ops = &xfs_buf_item_ops;> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c> index 05a4bdd..53ccdc4 100644> --- a/fs/xfs/xfs_extfree_item.c> +++ b/fs/xfs/xfs_extfree_item.c> @@ -253,9 +253,9 @@ xfs_efi_init(xfs_mount_t    *mp,>        if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {>                size = (uint)(sizeof(xfs_efi_log_item_t) +>                        ((nextents - 1) * sizeof(xfs_extent_t)));> -               efip = (xfs_efi_log_item_t*)kmem_zalloc(size, KM_SLEEP);> +               efip = kmem_zalloc(size, KM_SLEEP);>        } else {> -               efip = (xfs_efi_log_item_t*)kmem_zone_zalloc(xfs_efi_zone,> +               efip = kmem_zone_zalloc(xfs_efi_zone,>                                                             KM_SLEEP);Dito.
>        }>> @@ -548,9 +548,9 @@ xfs_efd_init(xfs_mount_t    *mp,>        if (nextents > XFS_EFD_MAX_FAST_EXTENTS) {>                size = (uint)(sizeof(xfs_efd_log_item_t) +>                        ((nextents - 1) * sizeof(xfs_extent_t)));> -               efdp = (xfs_efd_log_item_t*)kmem_zalloc(size, KM_SLEEP);> +               efdp = kmem_zalloc(size, KM_SLEEP);>        } else {> -               efdp = (xfs_efd_log_item_t*)kmem_zone_zalloc(xfs_efd_zone,> +               efdp = kmem_zone_zalloc(xfs_efd_zone,>                                                             KM_SLEEP);Dito.
>        }>> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c> index 7ba4501..3037920 100644> --- a/fs/xfs/xfs_log_recover.c> +++ b/fs/xfs/xfs_log_recover.c> @@ -1670,7 +1670,7 @@ xlog_recover_do_buffer_pass1(>         * the bucket.>         */>        if (*bucket == NULL) {> -               bcp = (xfs_buf_cancel_t *)kmem_alloc(sizeof(xfs_buf_cancel_t),> +               bcp = kmem_alloc(sizeof(xfs_buf_cancel_t),>                                                     KM_SLEEP);Dito.
>                bcp->bc_blkno = blkno;>                bcp->bc_len = len;> @@ -1696,7 +1696,7 @@ xlog_recover_do_buffer_pass1(>                nextp = nextp->bc_next;>        }>        ASSERT(prevp != NULL);> -       bcp = (xfs_buf_cancel_t *)kmem_alloc(sizeof(xfs_buf_cancel_t),> +       bcp = kmem_alloc(sizeof(xfs_buf_cancel_t),>                                             KM_SLEEP);Dito.
>        bcp->bc_blkno = blkno;>        bcp->bc_len = len;> @@ -2316,7 +2316,7 @@ xlog_recover_do_inode_trans(>        if (item->ri_buf[0].i_len == sizeof(xfs_inode_log_format_t)) {>                in_f = (xfs_inode_log_format_t *)item->ri_buf[0].i_addr;>        } else {> -               in_f = (xfs_inode_log_format_t *)kmem_alloc(> +               in_f = kmem_alloc(>                        sizeof(xfs_inode_log_format_t), KM_SLEEP);Please check.
>                need_free = 1;>                error = xfs_inode_item_format_convert(&item->ri_buf[0], in_f);> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c> index 8570b82..44d039d 100644> --- a/fs/xfs/xfs_trans.c> +++ b/fs/xfs/xfs_trans.c> @@ -868,7 +868,7 @@ shut_us_down:>        } else if (nvec <= XFS_TRANS_LOGVEC_COUNT) {>                log_vector = log_vector_fast;>        } else {> -               log_vector = (xfs_log_iovec_t *)kmem_alloc(nvec *> +               log_vector = kmem_alloc(nvec *>                                                   sizeof(xfs_log_iovec_t),Move up.
>                                                   KM_SLEEP);Probably realign.
>        }> --
Bert���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
