Return-Path: <linux-kernel-owner+w=401wt.eu-S934298AbZDIKkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934298AbZDIKkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934164AbZDIKkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 06:40:03 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:35849 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934140AbZDIKj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 06:39:58 -0400
X-Sasl-enc: pYW+zRolEPxxsPAigfKgkfVtV3ZhE9eDdpsj1tKMc+Z+ 1239273595
Message-ID: <49DDD078.7000800@fastmail.fm>
Date: Thu, 09 Apr 2009 11:39:52 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: Bert Wesarg <bert.wesarg@googlemail.com>
CC: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org, felixb@sgi.com
Subject: Re: [PATCH 56/56] xfs: Remove void casts
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-49-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-50-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-51-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-52-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-53-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-54-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-55-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-56-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-57-git-send-email-jwjstone@fastmail.fm> <36ca99e90904080515w339dd1d1ge5bfb546cec5e4b8@mail.gmail.com> <49DCAE53.4000405@fastmail.fm>
In-Reply-To: <49DCAE53.4000405@fastmail.fm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added maintainer CC]
Jack Stone wrote:
> Fixed patch
>
> Thanks,
>
> Jack
>
> --
>
> xfs: Remove void casts
>
> From: Jack Stone <jwjstone@fastmail.fm>
>
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>
>  fs/xfs/quota/xfs_dquot_item.c |    2 +-
>  fs/xfs/support/ktrace.c       |   10 ++++------
>  fs/xfs/xfs_attr_leaf.c        |    2 +-
>  fs/xfs/xfs_buf_item.c         |    7 +++----
>  fs/xfs/xfs_extfree_item.c     |   10 ++++------
>  fs/xfs/xfs_inode.c            |    5 ++---
>  fs/xfs/xfs_log_recover.c      |   12 ++++--------
>  fs/xfs/xfs_trans.c            |    5 ++---
>  fs/xfs/xfs_trans_inode.c      |    3 +--
>  fs/xfs/xfs_trans_item.c       |    6 ++----
>  10 files changed, 24 insertions(+), 38 deletions(-)
>
> diff --git a/fs/xfs/quota/xfs_dquot_item.c b/fs/xfs/quota/xfs_dquot_item.c
> index 1728f6a..a4d970a 100644
> --- a/fs/xfs/quota/xfs_dquot_item.c
> +++ b/fs/xfs/quota/xfs_dquot_item.c
> @@ -648,7 +648,7 @@ xfs_qm_qoff_logitem_init(
>  {
>      xfs_qoff_logitem_t    *qf;
>  
> -    qf = (xfs_qoff_logitem_t*) kmem_zalloc(sizeof(xfs_qoff_logitem_t),
> KM_SLEEP);
> +    qf = kmem_zalloc(sizeof(xfs_qoff_logitem_t), KM_SLEEP);
>  
>      qf->qql_item.li_type = XFS_LI_QUOTAOFF;
>      if (start)
> diff --git a/fs/xfs/support/ktrace.c b/fs/xfs/support/ktrace.c
> index 2d494c2..db35dcd 100644
> --- a/fs/xfs/support/ktrace.c
> +++ b/fs/xfs/support/ktrace.c
> @@ -58,9 +58,9 @@ ktrace_alloc(int nentries, unsigned int __nocast sleep)
>      ktrace_entry_t  *ktep;
>      int        entries;
>  
> -    ktp = (ktrace_t*)kmem_zone_alloc(ktrace_hdr_zone, sleep);
> +    ktp = kmem_zone_alloc(ktrace_hdr_zone, sleep);
>  
> -    if (ktp == (ktrace_t*)NULL) {
> +    if (ktp == NULL) {
>          /*
>           * KM_SLEEP callers don't expect failure.
>           */
> @@ -75,11 +75,9 @@ ktrace_alloc(int nentries, unsigned int __nocast sleep)
>       */
>      entries = roundup_pow_of_two(nentries);
>      if (entries == ktrace_zentries) {
> -        ktep = (ktrace_entry_t*)kmem_zone_zalloc(ktrace_ent_zone,
> -                                sleep);
> +        ktep = kmem_zone_zalloc(ktrace_ent_zone, sleep);
>      } else {
> -        ktep = (ktrace_entry_t*)kmem_zalloc((entries * sizeof(*ktep)),
> -                                sleep | KM_LARGE);
> +        ktep = kmem_zalloc((entries * sizeof(*ktep)), sleep | KM_LARGE);
>      }
>  
>      if (ktep == NULL) {
> diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
> index afdc891..688e894 100644
> --- a/fs/xfs/xfs_attr_leaf.c
> +++ b/fs/xfs/xfs_attr_leaf.c
> @@ -2869,7 +2869,7 @@ xfs_attr_leaf_inactive(xfs_trans_t **trans,
> xfs_inode_t *dp, xfs_dabuf_t *bp)
>       * Allocate storage for a list of all the "remote" value extents.
>       */
>      size = count * sizeof(xfs_attr_inactive_list_t);
> -    list = (xfs_attr_inactive_list_t *)kmem_alloc(size, KM_SLEEP);
> +    list = kmem_alloc(size, KM_SLEEP);
>  
>      /*
>       * Identify each of the "remote" value extents.
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 92af409..95234ef 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -726,8 +726,7 @@ xfs_buf_item_init(
>      chunks = (int)((XFS_BUF_COUNT(bp) + (XFS_BLI_CHUNK - 1)) >>
> XFS_BLI_SHIFT);
>      map_size = (int)((chunks + NBWORD) >> BIT_TO_WORD_SHIFT);
>  
> -    bip = (xfs_buf_log_item_t*)kmem_zone_zalloc(xfs_buf_item_zone,
> -                            KM_SLEEP);
> +    bip = kmem_zone_zalloc(xfs_buf_item_zone, KM_SLEEP);
>      bip->bli_item.li_type = XFS_LI_BUF;
>      bip->bli_item.li_ops = &xfs_buf_item_ops;
>      bip->bli_item.li_mountp = mp;
> @@ -751,9 +750,9 @@ xfs_buf_item_init(
>       * the buffer to indicate which bytes the callers have asked
>       * to have logged.
>       */
> -    bip->bli_orig = (char *)kmem_alloc(XFS_BUF_COUNT(bp), KM_SLEEP);
> +    bip->bli_orig = kmem_alloc(XFS_BUF_COUNT(bp), KM_SLEEP);
>      memcpy(bip->bli_orig, XFS_BUF_PTR(bp), XFS_BUF_COUNT(bp));
> -    bip->bli_logged = (char *)kmem_zalloc(XFS_BUF_COUNT(bp) / NBBY,
> KM_SLEEP);
> +    bip->bli_logged = kmem_zalloc(XFS_BUF_COUNT(bp) / NBBY, KM_SLEEP);
>  #endif
>  
>      /*
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 05a4bdd..2b8267c 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -253,10 +253,9 @@ xfs_efi_init(xfs_mount_t    *mp,
>      if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {
>          size = (uint)(sizeof(xfs_efi_log_item_t) +
>              ((nextents - 1) * sizeof(xfs_extent_t)));
> -        efip = (xfs_efi_log_item_t*)kmem_zalloc(size, KM_SLEEP);
> +        efip = kmem_zalloc(size, KM_SLEEP);
>      } else {
> -        efip = (xfs_efi_log_item_t*)kmem_zone_zalloc(xfs_efi_zone,
> -                                 KM_SLEEP);
> +        efip = kmem_zone_zalloc(xfs_efi_zone, KM_SLEEP);
>      }
>  
>      efip->efi_item.li_type = XFS_LI_EFI;
> @@ -548,10 +547,9 @@ xfs_efd_init(xfs_mount_t    *mp,
>      if (nextents > XFS_EFD_MAX_FAST_EXTENTS) {
>          size = (uint)(sizeof(xfs_efd_log_item_t) +
>              ((nextents - 1) * sizeof(xfs_extent_t)));
> -        efdp = (xfs_efd_log_item_t*)kmem_zalloc(size, KM_SLEEP);
> +        efdp = kmem_zalloc(size, KM_SLEEP);
>      } else {
> -        efdp = (xfs_efd_log_item_t*)kmem_zone_zalloc(xfs_efd_zone,
> -                                 KM_SLEEP);
> +        efdp = kmem_zone_zalloc(xfs_efd_zone, KM_SLEEP);
>      }
>  
>      efdp->efd_item.li_type = XFS_LI_EFD;
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index e7ae08d..5ab6e3d 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3453,7 +3453,7 @@ xfs_iext_add_indirect_multi(
>       * (all extents past */
>      if (nex2) {
>          byte_diff = nex2 * sizeof(xfs_bmbt_rec_t);
> -        nex2_ep = (xfs_bmbt_rec_t *) kmem_alloc(byte_diff, KM_NOFS);
> +        nex2_ep = kmem_alloc(byte_diff, KM_NOFS);
>          memmove(nex2_ep, &erp->er_extbuf[idx], byte_diff);
>          erp->er_extcount -= nex2;
>          xfs_iext_irec_update_extoffs(ifp, erp_idx + 1, -nex2);
> @@ -3842,8 +3842,7 @@ xfs_iext_realloc_indirect(
>      if (new_size == 0) {
>          xfs_iext_destroy(ifp);
>      } else {
> -        ifp->if_u1.if_ext_irec = (xfs_ext_irec_t *)
> -            kmem_realloc(ifp->if_u1.if_ext_irec,
> +        ifp->if_u1.if_ext_irec = kmem_realloc(ifp->if_u1.if_ext_irec,
>                  new_size, size, KM_NOFS);
>      }
>  }
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 7ba4501..fc8daa0 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1670,8 +1670,7 @@ xlog_recover_do_buffer_pass1(
>       * the bucket.
>       */
>      if (*bucket == NULL) {
> -        bcp = (xfs_buf_cancel_t *)kmem_alloc(sizeof(xfs_buf_cancel_t),
> -                             KM_SLEEP);
> +        bcp = kmem_alloc(sizeof(xfs_buf_cancel_t), KM_SLEEP);
>          bcp->bc_blkno = blkno;
>          bcp->bc_len = len;
>          bcp->bc_refcount = 1;
> @@ -1696,8 +1695,7 @@ xlog_recover_do_buffer_pass1(
>          nextp = nextp->bc_next;
>      }
>      ASSERT(prevp != NULL);
> -    bcp = (xfs_buf_cancel_t *)kmem_alloc(sizeof(xfs_buf_cancel_t),
> -                         KM_SLEEP);
> +    bcp = kmem_alloc(sizeof(xfs_buf_cancel_t), KM_SLEEP);
>      bcp->bc_blkno = blkno;
>      bcp->bc_len = len;
>      bcp->bc_refcount = 1;
> @@ -2316,8 +2314,7 @@ xlog_recover_do_inode_trans(
>      if (item->ri_buf[0].i_len == sizeof(xfs_inode_log_format_t)) {
>          in_f = (xfs_inode_log_format_t *)item->ri_buf[0].i_addr;
>      } else {
> -        in_f = (xfs_inode_log_format_t *)kmem_alloc(
> -            sizeof(xfs_inode_log_format_t), KM_SLEEP);
> +        in_f = kmem_alloc(sizeof(xfs_inode_log_format_t), KM_SLEEP);
>          need_free = 1;
>          error = xfs_inode_item_format_convert(&item->ri_buf[0], in_f);
>          if (error)
> @@ -3778,8 +3775,7 @@ xlog_do_log_recovery(
>       * First do a pass to find all of the cancelled buf log items.
>       * Store them in the buf_cancel_table for use in the second pass.
>       */
> -    log->l_buf_cancel_table =
> -        (xfs_buf_cancel_t **)kmem_zalloc(XLOG_BC_TABLE_SIZE *
> +    log->l_buf_cancel_table = kmem_zalloc(XLOG_BC_TABLE_SIZE *
>                           sizeof(xfs_buf_cancel_t*),
>                           KM_SLEEP);
>      error = xlog_do_recovery_pass(log, head_blk, tail_blk,
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 8570b82..282795e 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -868,9 +868,8 @@ shut_us_down:
>      } else if (nvec <= XFS_TRANS_LOGVEC_COUNT) {
>          log_vector = log_vector_fast;
>      } else {
> -        log_vector = (xfs_log_iovec_t *)kmem_alloc(nvec *
> -                           sizeof(xfs_log_iovec_t),
> -                           KM_SLEEP);
> +        log_vector = kmem_alloc(nvec * sizeof(xfs_log_iovec_t),
> +                KM_SLEEP);
>      }
>  
>      /*
> diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
> index 23d276a..e1b90f0 100644
> --- a/fs/xfs/xfs_trans_inode.c
> +++ b/fs/xfs/xfs_trans_inode.c
> @@ -271,8 +271,7 @@ xfs_trans_inode_broot_debug(
>          ASSERT((ip->i_df.if_broot != NULL) &&
>                 (ip->i_df.if_broot_bytes > 0));
>          iip->ili_root_size = ip->i_df.if_broot_bytes;
> -        iip->ili_orig_root =
> -            (char*)kmem_alloc(iip->ili_root_size, KM_SLEEP);
> +        iip->ili_orig_root = kmem_alloc(iip->ili_root_size, KM_SLEEP);
>          memcpy(iip->ili_orig_root, (char*)(ip->i_df.if_broot),
>                iip->ili_root_size);
>      }
> diff --git a/fs/xfs/xfs_trans_item.c b/fs/xfs/xfs_trans_item.c
> index eb3fc57..49615dd 100644
> --- a/fs/xfs/xfs_trans_item.c
> +++ b/fs/xfs/xfs_trans_item.c
> @@ -54,8 +54,7 @@ xfs_trans_add_item(xfs_trans_t *tp, xfs_log_item_t *lip)
>       * of them and put it at the front of the chunk list.
>       */
>      if (tp->t_items_free == 0) {
> -        licp = (xfs_log_item_chunk_t*)
> -               kmem_alloc(sizeof(xfs_log_item_chunk_t), KM_SLEEP);
> +        licp = kmem_alloc(sizeof(xfs_log_item_chunk_t), KM_SLEEP);
>          ASSERT(licp != NULL);
>          /*
>           * Initialize the chunk, and then
> @@ -460,8 +459,7 @@ xfs_trans_add_busy(xfs_trans_t *tp, xfs_agnumber_t
> ag, xfs_extlen_t idx)
>       * of them and put it at the front of the chunk list.
>       */
>      if (tp->t_busy_free == 0) {
> -        lbcp = (xfs_log_busy_chunk_t*)
> -               kmem_alloc(sizeof(xfs_log_busy_chunk_t), KM_SLEEP);
> +        lbcp = kmem_alloc(sizeof(xfs_log_busy_chunk_t), KM_SLEEP);
>          ASSERT(lbcp != NULL);
>          /*
>           * Initialize the chunk, and then
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

