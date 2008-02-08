Return-Path: <linux-kernel-owner+w=401wt.eu-S1762634AbYBHVnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762634AbYBHVnZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762126AbYBHVnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:43:00 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:50535 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283AbYBHVm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:42:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=TnNZmEyZF5t+MprslztvdQ9axNLxtCXXiCDqsrylI5DaT2A1C60H7cmKjVmCAH7d/+58Rs4PBO9K/sJgsGeyLIcMXe+PtLRotIjaC4jSRaD2fjv4QSf3qlkegkspfjUgXqYbEReevs6hX64ptEvfUvVdW7yzyn0u4tq0eJcB3FA=
Message-ID: <47ACCCDD.5060307@gmail.com>
Date: Fri, 08 Feb 2008 22:42:53 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/1] tty: BKL pushdown fix1
References: <47ACCBD4.1000502@gmail.com> <1202506856-3403-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1202506856-3403-1-git-send-email-jirislaby@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, CCing Alan.

On 02/08/2008 10:40 PM, Jiri Slaby wrote:
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> ---
>  fs/compat_ioctl.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
> index c6e72ae..9663e87 100644
> --- a/fs/compat_ioctl.c
> +++ b/fs/compat_ioctl.c
> @@ -1046,7 +1046,7 @@ static int vt_check(struct file *file)
>  	struct inode *inode = file->f_path.dentry->d_inode;
>  	struct vc_data *vc;
>  	
> -	if (file->f_op->ioctl != tty_ioctl)
> +	if (file->f_op->unlocked_ioctl != tty_ioctl)
>  		return -EINVAL;
>  	                
>  	tty = (struct tty_struct *)file->private_data;
