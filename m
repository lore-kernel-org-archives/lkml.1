Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487Ab0ADRMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab0ADRMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 12:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439Ab0ADRMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 12:12:16 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34119 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab0ADRMO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 12:12:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=O86UxUcrleVFnwz+ctdx6G+55fO5s6Fxra37mw7EIM1U5ztUpHJFCWa4M6rTaoHnAK
         +3VtyFewRxzJ1lKWN0MVOEgWWFMs+aricqsa11HYd6PhUUZLczLFhrtV7Jre5JvUddfw
         34hrjNT6EHHvS5jGtFOPXzYP4MfeA3nbSagtE=
MIME-Version: 1.0
In-Reply-To: <20100104162107.16880.67633.stgit@localhost.localdomain>
References: <20100104162107.16880.67633.stgit@localhost.localdomain>
Date: Mon, 4 Jan 2010 18:12:12 +0100
Message-ID: <520f0cf11001040912y67aab8e0x619baeed4883184f@mail.gmail.com>
Subject: Re: [PATCH] sonypi: Kill off the BKL in the ioctl
From: John Kacur <jkacur@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 4, 2010 at 5:21 PM, Alan Cox <alan@linux.intel.com> wrote:
> And another thats been ignored for several months
>
> --
>
> All the internal logic is protected properly by the existing mutex locking
>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
>
>  drivers/char/sonypi.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
>
> diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
> index 0798754..6a574bf 100644
> --- a/drivers/char/sonypi.c
> +++ b/drivers/char/sonypi.c
> @@ -955,8 +955,8 @@ static unsigned int sonypi_misc_poll(struct file *file, poll_table *wait)
>        return 0;
>  }
>
> -static int sonypi_misc_ioctl(struct inode *ip, struct file *fp,
> -                            unsigned int cmd, unsigned long arg)
> +static long sonypi_misc_ioctl(struct file *fp,
> +                                       unsigned int cmd, unsigned long arg)
>  {
>        int ret = 0;
>        void __user *argp = (void __user *)arg;
> @@ -1074,7 +1074,7 @@ static const struct file_operations sonypi_misc_fops = {
>        .open           = sonypi_misc_open,
>        .release        = sonypi_misc_release,
>        .fasync         = sonypi_misc_fasync,
> -       .ioctl          = sonypi_misc_ioctl,
> +       .unlocked_ioctl = sonypi_misc_ioctl,
>  };
>
>  static struct miscdevice sonypi_misc_device = {
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

I submitted this in October that would also remove the bkl from the
sonypi_misc_open function too.
http://lkml.indiana.edu/hypermail/linux/kernel/0910.2/01405.html

Thanks
