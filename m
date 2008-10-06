Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbYJFBU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbYJFBU6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 21:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbYJFBUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 21:20:51 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:5814 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbYJFBUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 21:20:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=blZUTBEl9+NhRUPmHlAJ2KW+UWFnr0894YUZGHz2AdzRfJqUJqu+pv52lpI7DyX9pg
         iaX4lYfNAl/wO6bstoR146/wMzQ1gb4bpkGRnX10wAgPXHGDMc16clsDdNsdJMDzEQcI
         6xP8YbltC3vP5i58Jau0XrRprLjMnYBMZ7jAA=
Message-ID: <919fe2b30810051820w29df40d0ued4e15d740674a29@mail.gmail.com>
Date: Sun, 5 Oct 2008 21:20:49 -0400
From: "M. Asselstine" <asselsm@mcmaster.ca>
To: "Julia Lawall" <julia@diku.dk>
Subject: Re: [PATCH 1/2] drivers/i2c/busses/i2c-s3c2410.c: Correct use of ! and &
Cc: ben-linux@fluff.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0810042203520.19286@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0810042203520.19286@ask.diku.dk>
X-Google-Sender-Auth: 1a8f0b6613a6b316
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 4, 2008 at 4:05 PM, Julia Lawall <julia@diku.dk> wrote:
> From: Julia Lawall <julia@diku.dk>
>
> In commit e6bafba5b4765a5a252f1b8d31cbf6d2459da337, a bug was fixed that
> involved converting !x & y to !(x & y).  The code below shows the same
> pattern, and thus should perhaps be fixed in the same way.  In particular,
> the result of !readl(i2c->regs + S3C2410_IICCON) & S3C2410_IICCON_IRQEN is
> always 0.
>
> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
>
> // <smpl>
> @@ expression E; constant C; @@
> (
>  !E & !C
> |
> - !E & C
> + !(E & C)
> )
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>
Reviewed-by: Mark Asselstine <mark.asselstine@windriver.com>

Good catch Julia.


>
> ---
>  drivers/i2c/busses/i2c-s3c2410.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff -u -p a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
> --- a/drivers/i2c/busses/i2c-s3c2410.c
> +++ b/drivers/i2c/busses/i2c-s3c2410.c
> @@ -507,7 +507,7 @@ static int s3c24xx_i2c_doxfer(struct s3c
>        unsigned long timeout;
>        int ret;
>
> -       if (!readl(i2c->regs + S3C2410_IICCON) & S3C2410_IICCON_IRQEN)
> +       if (!(readl(i2c->regs + S3C2410_IICCON) & S3C2410_IICCON_IRQEN))
>                return -EIO;
>
>        ret = s3c24xx_i2c_set_master(i2c);
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
