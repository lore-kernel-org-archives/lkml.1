Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbZJUMGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbZJUMGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 08:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbZJUMGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 08:06:39 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:54220 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbZJUMGi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 08:06:38 -0400
MIME-Version: 1.0
In-Reply-To: <4ADEFA54.1090005@gmail.com>
References: <4ADEFA54.1090005@gmail.com>
Date: Wed, 21 Oct 2009 15:06:42 +0300
Message-ID: <37786d4b0910210506s8ab8556yf99c96519e35e1e2@mail.gmail.com>
Subject: Re: [PATCH] mfd: fix check on unsigned in twl4030_configure_resource()
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, sameo@linux.intel.com,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 21, 2009 at 3:11 PM, Roel Kluin <roel.kluin@gmail.com> wrote:
> struct twl4030_resconfig members devgroup, type and type2 are
> unsigned.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> `git grep devgroup' and notice that these are initialized to -1 in
> arch/arm/mach-omap2/board-rx51-peripherals.c:383-397
>
> Is this the right fix?

Yes it is. Aaro beat you to it though [1] :)

Regards,
Amit

[1]. http://git.kernel.org/?p=linux/kernel/git/sameo/mfd-2.6.git;a=commitdiff;h=86db38dffd5903e2fbb4268e46fd8a07a5ceb8ac

> diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
> index d423e0c..cc984a5 100644
> --- a/drivers/mfd/twl4030-power.c
> +++ b/drivers/mfd/twl4030-power.c
> @@ -335,7 +335,7 @@ static int __init twl4030_configure_resource(struct twl4030_resconfig *rconfig)
>                return err;
>        }
>
> -       if (rconfig->devgroup >= 0) {
> +       if (rconfig->devgroup != -1) {
>                grp &= ~DEVGROUP_MASK;
>                grp |= rconfig->devgroup << DEVGROUP_SHIFT;
>                err = twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
> @@ -355,12 +355,12 @@ static int __init twl4030_configure_resource(struct twl4030_resconfig *rconfig)
>                return err;
>        }
>
> -       if (rconfig->type >= 0) {
> +       if (rconfig->type != -1) {
>                type &= ~TYPE_MASK;
>                type |= rconfig->type << TYPE_SHIFT;
>        }
>
> -       if (rconfig->type2 >= 0) {
> +       if (rconfig->type2 != -1) {
>                type &= ~TYPE2_MASK;
>                type |= rconfig->type2 << TYPE2_SHIFT;
>        }
>
