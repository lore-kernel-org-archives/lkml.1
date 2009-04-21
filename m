Return-Path: <linux-kernel-owner+w=401wt.eu-S1757084AbZDUBTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbZDUBTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 21:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbZDUBTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 21:19:05 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:61996 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580AbZDUBTC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 21:19:02 -0400
MIME-Version: 1.0
In-Reply-To: <49E799CD.1010902@gmail.com>
References: <49E799CD.1010902@gmail.com>
Date: Tue, 21 Apr 2009 11:18:59 +1000
Message-ID: <1d3f23370904201818v1efb272dv55441d436311a19@mail.gmail.com>
Subject: Re: [microblaze-uclinux] [PATCH] microblaze: iowrite upon timeout
From: John Williams <john.williams@petalogix.com>
To: microblaze-uclinux@itee.uq.edu.au
Cc: monstr@monstr.eu, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 6:49 AM, Roel Kluin <roel.kluin@gmail.com> wrote:
> retries reaches -1, so the iowrite occurrs upon timeout.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Acked-by: John Williams <john.williams@petalogix.com>

(also applied to PetaLogix SVN)

Thanks,

John

> ---
> diff --git a/arch/microblaze/kernel/early_printk.c b/arch/microblaze/kernel/early_printk.c
> index 62cc789..4b0f0fd 100644
> --- a/arch/microblaze/kernel/early_printk.c
> +++ b/arch/microblaze/kernel/early_printk.c
> @@ -36,7 +36,7 @@ static void early_printk_putc(char c)
>
>        unsigned retries = 10000;
>        /* read status bit - 0x8 offset */
> -       while (retries-- && (in_be32(base_addr + 8) & (1 << 3)))
> +       while (--retries && (in_be32(base_addr + 8) & (1 << 3)))
>                ;
>
>        /* Only attempt the iowrite if we didn't timeout */
> ___________________________
> microblaze-uclinux mailing list
> microblaze-uclinux@itee.uq.edu.au
> Project Home Page : http://www.itee.uq.edu.au/~jwilliams/mblaze-uclinux
> Mailing List Archive : http://www.itee.uq.edu.au/~listarch/microblaze-uclinux/
>
>



-- 
John Williams, PhD, B.Eng, B.IT
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com  p: +61-7-30090663  f: +61-7-30090663
