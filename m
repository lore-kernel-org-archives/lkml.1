Return-Path: <linux-kernel-owner+w=401wt.eu-S1762649AbZBECN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762649AbZBECN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 21:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762284AbZBECNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 21:13:43 -0500
Received: from smtp-out.google.com ([216.239.33.17]:53643 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762129AbZBECNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 21:13:42 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=JyMbhf4SOzTCQwpDuaBW+VmCReDTGkbm6quN+1DtuF0TtjVOxI3I1Skl5I009+yD2
	49hhC9dYUUpVLupGRfYqw==
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0902041736080.15728@kitami.corp.google.com>
References: <Pine.LNX.4.64.0902041736080.15728@kitami.corp.google.com>
Date: Wed, 4 Feb 2009 18:13:37 -0800
Message-ID: <ed628a920902041813n4857aab4hc0e592a652de31b0@mail.gmail.com>
Subject: Re: [PATCH] Separate FMODE_PREAD/FMODE_PWRITE into separate flags
From: Paul Turner <pjt@google.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com, ebiederm@xmission.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.24.198.65
X-GMailtapped: pjt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(fix typo on Eric's email address)

On Wed, Feb 4, 2009 at 6:06 PM, Paul Turner <pjt@google.com> wrote:
> Separate FMODE_PREAD and FMODE_PWRITE into separate flags to reflect the
> reality that the read and write paths may have independent restrictions.
>
> A git grep verifies that these flags are always cleared together so this new
> behavior will only apply to interfaces that change to clear flags individually.
>
> Signed-off-by: Paul Turner <pjt@google.com>
> ---
>  include/linux/fs.h |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 6022f44..d6a51d9 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -60,18 +60,19 @@ struct inodes_stat_t {
>  #define FMODE_WRITE            ((__force fmode_t)2)
>  /* file is seekable */
>  #define FMODE_LSEEK            ((__force fmode_t)4)
> -/* file can be accessed using pread/pwrite */
> +/* file can be accessed using pread */
>  #define FMODE_PREAD            ((__force fmode_t)8)
> -#define FMODE_PWRITE           FMODE_PREAD     /* These go hand in hand */
> +/* file can be accessed using pwrite */
> +#define FMODE_PWRITE           ((__force fmode_t)16)
>  /* File is opened for execution with sys_execve / sys_uselib */
> -#define FMODE_EXEC             ((__force fmode_t)16)
> +#define FMODE_EXEC             ((__force fmode_t)32)
>  /* File is opened with O_NDELAY (only set for block devices) */
> -#define FMODE_NDELAY           ((__force fmode_t)32)
> +#define FMODE_NDELAY           ((__force fmode_t)64)
>  /* File is opened with O_EXCL (only set for block devices) */
> -#define FMODE_EXCL             ((__force fmode_t)64)
> +#define FMODE_EXCL             ((__force fmode_t)128)
>  /* File is opened using open(.., 3, ..) and is writeable only for ioctls
>    (specialy hack for floppy.c) */
> -#define FMODE_WRITE_IOCTL      ((__force fmode_t)128)
> +#define FMODE_WRITE_IOCTL      ((__force fmode_t)256)
>
>  /*
>  * Don't update ctime and mtime.
> --
> 1.5.4.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
