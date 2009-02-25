Return-Path: <linux-kernel-owner+w=401wt.eu-S1757850AbZBYBz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850AbZBYBz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 20:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbZBYBzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 20:55:49 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:15768 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbZBYBzs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 20:55:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GSWdjqZATTASrcT4EZ2U5gLqGzXk41eARwB+3A/9p5TDVU6desGwahGSh0qCPF35Cg
         D8nEnn5+pZZKCFMZPJgVxe+zURUnJ3dKJTPwHih/IK+YcrNrbdijTEf5p5tNWI2hcBQM
         y829VwaJjnrJGRKvMt0+f+qDqedYQ3t/TeMOM=
MIME-Version: 1.0
In-Reply-To: <200902241509.54649.david-b@pacbell.net>
References: <200902241509.54649.david-b@pacbell.net>
Date: Tue, 24 Feb 2009 22:55:45 -0300
Message-ID: <82ecf08e0902241755y5a7be725gb84116433b7d3be2@mail.gmail.com>
Subject: Re: [patch/RESEND 2.6.29-rc3-git] NAND: davinci_nand driver
From: Thiago Galesi <thiagogalesi@gmail.com>
To: dbrownell@users.sourceforge.net
Cc: Linux MTD <linux-mtd@lists.infradead.org>,
       lkml <linux-kernel@vger.kernel.org>,
       DaVinci <davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK a couple of things
 +
> +
> +#ifdef CONFIG_MTD_PARTITIONS
> +static inline int mtd_has_partitions(void) { return 1; }
> +#else
> +static inline int mtd_has_partitions(void) { return 0; }
> +#endif
> +
> +#ifdef CONFIG_MTD_CMDLINE_PARTS
> +static inline int mtd_has_cmdlinepart(void) { return 1; }
> +#else
> +static inline int mtd_has_cmdlinepart(void) { return 0; }
> +#endif

I'm not sure stylewise this is the best way. Even though #ifdefs stays
outside of functions, this is a case where maybe it's better to put it
inside or rething the need / usage for these functions.

> +static int nand_davinci_calculate_1bit(struct mtd_info *mtd,
> +                                     const u_char *dat, u_char *ecc_code)

(and others)

My beef here is the use of u_char. This is really not a standart C
type or a standart Linux type (u8/u32 etc), so we should aim for those
(yes, I hate typing unsigned blah blah blah) but you can use u8 for
that.

> +static void nand_davinci_read_buf(struct mtd_info *mtd, uint8_t *buf, int len)
> +{
> +       struct nand_chip *chip = mtd->priv;
> +
> +       if ((0x03 & ((unsigned)buf)) == 0 && (0x03 & len) == 0)
> +               ioread32_rep(chip->IO_ADDR_R, buf, len >> 2);
> +       else if ((0x01 & ((unsigned)buf)) == 0 && (0x01 & len) == 0)

What are those 0x03 and 0x01 (and other places as well), you'll have
to spell out those, preferably using defines.

-- 
-
Thiago Galesi
