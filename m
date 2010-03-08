Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668Ab0CHFr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 00:47:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab0CHFrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 00:47:51 -0500
Message-ID: <4B948F7C.6010109@redhat.com>
Date: Sun, 07 Mar 2010 23:47:40 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH] ext4: allow defrag (EXT4_IOC_MOVE_EXT) in 32bit compat
 mode
References: <201003072132.10579.borntraeger@de.ibm.com>
In-Reply-To: <201003072132.10579.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
> I have an x86_64 kernel with i386 userspace. e4defrag fails on the
> EXT4_IOC_MOVE_EXT ioctl because it is not wired up for the compat
> case. It seems that struct move_extent is compat save, only types
> with fixed widths are used:

and they're well-aligned.

> {
>         __u32 reserved;         /* should be zero */
>         __u32 donor_fd;         /* donor file descriptor */
>         __u64 orig_start;       /* logical start offset in block for orig */
>         __u64 donor_start;      /* logical start offset in block for donor */
>         __u64 len;              /* block length to be moved */
>         __u64 moved_len;        /* moved block length */
> };
> 
> Lets just wire up EXT4_IOC_MOVE_EXT for the compat case.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> CCed: Akira Fujita <a-fujita@rs.jp.nec.com> 

Looks fine to me.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/ext4/ioctl.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -375,6 +375,8 @@ long ext4_compat_ioctl(struct file *file
>  		break;
>  	case EXT4_IOC_GROUP_ADD:
>  		break;
> +	case EXT4_IOC_MOVE_EXT:
> +		break;
>  	default:
>  		return -ENOIOCTLCMD;
>  	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

