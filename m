Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab0CHInX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 03:43:23 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:52227 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab0CHInV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 03:43:21 -0500
Message-ID: <4B94B892.8000209@rs.jp.nec.com>
Date: Mon, 08 Mar 2010 17:42:58 +0900
From: Akira Fujita <a-fujita@rs.jp.nec.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1 ThunderBrowse/3.2.8.1
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: allow defrag (EXT4_IOC_MOVE_EXT) in 32bit compat
 mode
References: <201003072132.10579.borntraeger@de.ibm.com>
In-Reply-To: <201003072132.10579.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Christian,

(2010/03/08 5:32), Christian Borntraeger wrote:
> I have an x86_64 kernel with i386 userspace. e4defrag fails on the
> EXT4_IOC_MOVE_EXT ioctl because it is not wired up for the compat
> case. It seems that struct move_extent is compat save, only types
> with fixed widths are used:
> {
>          __u32 reserved;         /* should be zero */
>          __u32 donor_fd;         /* donor file descriptor */
>          __u64 orig_start;       /* logical start offset in block for orig */
>          __u64 donor_start;      /* logical start offset in block for donor */
>          __u64 len;              /* block length to be moved */
>          __u64 moved_len;        /* moved block length */
> };
>
> Lets just wire up EXT4_IOC_MOVE_EXT for the compat case.
>
> Signed-off-by: Christian Borntraeger<borntraeger@de.ibm.com>
> CCed: Akira Fujita<a-fujita@rs.jp.nec.com>
>
> ---
>   fs/ext4/ioctl.c |    2 ++
>   1 file changed, 2 insertions(+)
>
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -375,6 +375,8 @@ long ext4_compat_ioctl(struct file *file
>   		break;
>   	case EXT4_IOC_GROUP_ADD:
>   		break;
> +	case EXT4_IOC_MOVE_EXT:
> +		break;
>   	default:
>   		return -ENOIOCTLCMD;
>   	}

Looks good for me.
Thank you for your work.

Regards,
Akira Fujita


