Return-Path: <linux-kernel-owner+w=401wt.eu-S932721AbZDIKQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721AbZDIKQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764027AbZDIKP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 06:15:58 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57134 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757226AbZDIKP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 06:15:57 -0400
X-Sasl-enc: CnPyjfoxyY4ykO1VItQsxgx5bb03VNVJzr8o97cL2A4/ 1239272155
Message-ID: <49DDCAD7.7070206@fastmail.fm>
Date: Thu, 09 Apr 2009 11:15:51 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: Bert Wesarg <bert.wesarg@googlemail.com>
CC: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org, aia21@cantab.net
Subject: Re: [PATCH 35/56] ntfs: Remove void casts
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-28-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-29-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-30-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-31-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-32-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-33-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-34-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-35-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-36-git-send-email-jwjstone@fastmail.fm> <36ca99e90904080522o4813667fx535e02179b1f3688@mail.gmail.com> <49DCAF04.3090803@fastmail.fm>
In-Reply-To: <49DCAF04.3090803@fastmail.fm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added maintainer CC]
Jack Stone wrote:
> Fixed patch,
>
> Thanks,
>
> Jack
>
> --
>
> ntfs: Remove void casts
>
> From: Jack Stone <jwjstone@fastmail.fm>
>
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>
>  fs/ntfs/dir.c     |    8 ++++----
>  fs/ntfs/index.c   |    2 +-
>  fs/ntfs/super.c   |    8 ++++----
>  fs/ntfs/usnjrnl.c |    2 +-
>  4 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/fs/ntfs/dir.c b/fs/ntfs/dir.c
> index 5a9e344..c373301 100644
> --- a/fs/ntfs/dir.c
> +++ b/fs/ntfs/dir.c
> @@ -326,7 +326,7 @@ descend_into_child_node:
>          goto err_out;
>      }
>      lock_page(page);
> -    kaddr = (u8*)page_address(page);
> +    kaddr = page_address(page);
>  fast_descend_into_child_node:
>      /* Get to the index allocation block. */
>      ia = (INDEX_ALLOCATION*)(kaddr + ((vcn <<
> @@ -804,7 +804,7 @@ descend_into_child_node:
>          goto err_out;
>      }
>      lock_page(page);
> -    kaddr = (u8*)page_address(page);
> +    kaddr = page_address(page);
>  fast_descend_into_child_node:
>      /* Get to the index allocation block. */
>      ia = (INDEX_ALLOCATION*)(kaddr + ((vcn <<
> @@ -1279,7 +1279,7 @@ get_next_bmp_page:
>          bmp_page = NULL;
>          goto iput_err_out;
>      }
> -    bmp = (u8*)page_address(bmp_page);
> +    bmp = page_address(bmp_page);
>      /* Find next index block in use. */
>      while (!(bmp[cur_bmp_pos >> 3] & (1 << (cur_bmp_pos & 7)))) {
>  find_next_index_buffer:
> @@ -1322,7 +1322,7 @@ find_next_index_buffer:
>              goto err_out;
>          }
>          lock_page(ia_page);
> -        kaddr = (u8*)page_address(ia_page);
> +        kaddr = page_address(ia_page);
>      }
>      /* Get the current index buffer. */
>      ia = (INDEX_ALLOCATION*)(kaddr + (ia_pos & ~PAGE_CACHE_MASK &
> diff --git a/fs/ntfs/index.c b/fs/ntfs/index.c
> index 2194eff..16a8b2e 100644
> --- a/fs/ntfs/index.c
> +++ b/fs/ntfs/index.c
> @@ -282,7 +282,7 @@ descend_into_child_node:
>          goto err_out;
>      }
>      lock_page(page);
> -    kaddr = (u8*)page_address(page);
> +    kaddr = page_address(page);
>  fast_descend_into_child_node:
>      /* Get to the index allocation block. */
>      ia = (INDEX_ALLOCATION*)(kaddr + ((vcn <<
> diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
> index f76951d..d05bccf 100644
> --- a/fs/ntfs/super.c
> +++ b/fs/ntfs/super.c
> @@ -1295,7 +1295,7 @@ static int
> check_windows_hibernation_status(ntfs_volume *vol)
>          ret = PTR_ERR(page);
>          goto iput_out;
>      }
> -    kaddr = (u32*)page_address(page);
> +    kaddr = page_address(page);
>      if (*(le32*)kaddr == cpu_to_le32(0x72626968)/*'hibr'*/) {
>          ntfs_debug("Magic \"hibr\" found in hiberfil.sys.  Windows is "
>                  "hibernated on the volume.  This is the "
> @@ -1515,7 +1515,7 @@ not_enabled:
>                  "attribute.");
>          return false;
>      }
> -    uh = (USN_HEADER*)page_address(page);
> +    uh = page_address(page);
>      /* Sanity check the $Max. */
>      if (unlikely(sle64_to_cpu(uh->allocation_delta) >
>              sle64_to_cpu(uh->maximum_size))) {
> @@ -2501,7 +2501,7 @@ static s64 get_nr_free_clusters(ntfs_volume *vol)
>              nr_free -= PAGE_CACHE_SIZE * 8;
>              continue;
>          }
> -        kaddr = (u32*)kmap_atomic(page, KM_USER0);
> +        kaddr = kmap_atomic(page, KM_USER0);
>          /*
>           * For each 4 bytes, subtract the number of set bits. If this
>           * is the last page and it is partial we don't really care as
> @@ -2572,7 +2572,7 @@ static unsigned long
> __get_nr_free_mft_records(ntfs_volume *vol,
>              nr_free -= PAGE_CACHE_SIZE * 8;
>              continue;
>          }
> -        kaddr = (u32*)kmap_atomic(page, KM_USER0);
> +        kaddr = kmap_atomic(page, KM_USER0);
>          /*
>           * For each 4 bytes, subtract the number of set bits. If this
>           * is the last page and it is partial we don't really care as
> diff --git a/fs/ntfs/usnjrnl.c b/fs/ntfs/usnjrnl.c
> index b2bc0d5..5c8fdd7 100644
> --- a/fs/ntfs/usnjrnl.c
> +++ b/fs/ntfs/usnjrnl.c
> @@ -58,7 +58,7 @@ bool ntfs_stamp_usnjrnl(ntfs_volume *vol)
>                      "$UsnJrnl/$DATA/$Max attribute.");
>              return false;
>          }
> -        uh = (USN_HEADER*)page_address(page);
> +        uh = page_address(page);
>          stamp = get_current_ntfs_time();
>          ntfs_debug("Stamping transaction log ($UsnJrnl): old "
>                  "journal_id 0x%llx, old lowest_valid_usn "
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

