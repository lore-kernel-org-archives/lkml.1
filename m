Return-Path: <linux-kernel-owner+w=401wt.eu-S1756263AbZGMPhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbZGMPhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 11:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbZGMPhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 11:37:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:28171 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756226AbZGMPhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 11:37:06 -0400
Message-ID: <4A5B549E.4040003@petalogix.com>
Date: Mon, 13 Jul 2009 17:37:02 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: monstr@monstr.eu
CC: linux-aio@kvack.org, Linux Kernel list <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: generic_file_aio_write on nfs
References: <4A4C6EA4.9030108@monstr.eu>
In-Reply-To: <4A4C6EA4.9030108@monstr.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

can someone met with problem writev01, writev03, writev04?
Kernel patch below solve my issue but I have no idea why I couldn't use
generic aio write function.

Thanks,
Michal
> Hi Benjamin,
>
> I am doing LTP tests on Microblaze cpu and I am getting some faults.
> I found that the problem is caused by generic_file_aio_write function.
> I did quick patch with disable usage of generic_file_aio_write function and
> use only write function which works. I haven't debug
> generic_file_aio_write function.
>
> I am running Linux with initramfs and LTP programs are run from nfs.
>
> Have you ever met with this problem?
>
> Thanks,
> Michal
>
> [monstr@monstr linux-monstr.eu-commit]$ git diff fs/read_write.c
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 400fe81..e639098 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -642,7 +642,8 @@ static ssize_t do_readv_writev(int type, struct file
> *file,
>                 fnv = file->f_op->aio_read;
>         } else {
>                 fn = (io_fn_t)file->f_op->write;
> -               fnv = file->f_op->aio_write;
> +               //fnv = file->f_op->aio_write;
> +               fnv = 0;
>         }
>  
>         if (fnv)
>
>   


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

