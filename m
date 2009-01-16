Return-Path: <linux-kernel-owner+w=401wt.eu-S1765778AbZAPJ4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765778AbZAPJ4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 04:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762114AbZAPJ4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 04:56:10 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:45196 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761577AbZAPJ4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 04:56:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=J6xUlsaJ6TV1O5MM+9lKzqO7Mxw6faQgDqXT/OssA0gIrDzzsEqdGlRBN9wLnOrFQ7
         P/HL4gQFAMq3q+sqKptmhX8saLLRCzESGDAaHYBa1ZqHpQ9Fk/Xj5RRfg/h8qJl5YDbK
         /GtVdFsoxIH6hA0E/tEmADJyzET7nMIC2vTwk=
Message-ID: <25e057c00901160156w6058ade2j9c99ef727d8767ab@mail.gmail.com>
Date: Fri, 16 Jan 2009 10:56:01 +0100
From: "roel kluin" <roel.kluin@gmail.com>
To: "Hiroshi DOYU" <Hiroshi.DOYU@nokia.com>
Subject: Re: [PATCH 01/10] omap mailbox: cleanup omap2 register definition with macro
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-omap@vger.kernel.org
In-Reply-To: <20090116082706.17571.31102.stgit@oreo.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090116081919.17571.34378.stgit@oreo.research.nokia.com>
	 <20090116082706.17571.31102.stgit@oreo.research.nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/16 Hiroshi DOYU <Hiroshi.DOYU@nokia.com>:
> Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
> ---
>
>  arch/arm/mach-omap2/mailbox.c |   77 +++++++++++++++--------------------------
>  1 files changed, 29 insertions(+), 48 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/mailbox.c b/arch/arm/mach-omap2/mailbox.c
> index 32b7af3..0609e2d 100644
> --- a/arch/arm/mach-omap2/mailbox.c
> +++ b/arch/arm/mach-omap2/mailbox.c

> @@ -18,40 +18,19 @@
>  #include <mach/mailbox.h>
>  #include <mach/irqs.h>
>
> -#define MAILBOX_REVISION               0x00
> -#define MAILBOX_SYSCONFIG              0x10
> -#define MAILBOX_SYSSTATUS              0x14
> -#define MAILBOX_MESSAGE_0              0x40
> -#define MAILBOX_MESSAGE_1              0x44
> -#define MAILBOX_MESSAGE_2              0x48
> -#define MAILBOX_MESSAGE_3              0x4c
> -#define MAILBOX_MESSAGE_4              0x50
> -#define MAILBOX_MESSAGE_5              0x54
> -#define MAILBOX_FIFOSTATUS_0           0x80
> -#define MAILBOX_FIFOSTATUS_1           0x84
> -#define MAILBOX_FIFOSTATUS_2           0x88
> -#define MAILBOX_FIFOSTATUS_3           0x8c
> -#define MAILBOX_FIFOSTATUS_4           0x90
> -#define MAILBOX_FIFOSTATUS_5           0x94
> -#define MAILBOX_MSGSTATUS_0            0xc0
> -#define MAILBOX_MSGSTATUS_1            0xc4
> -#define MAILBOX_MSGSTATUS_2            0xc8
> -#define MAILBOX_MSGSTATUS_3            0xcc
> -#define MAILBOX_MSGSTATUS_4            0xd0
> -#define MAILBOX_MSGSTATUS_5            0xd4
> -#define MAILBOX_IRQSTATUS_0            0x100
> -#define MAILBOX_IRQENABLE_0            0x104
> -#define MAILBOX_IRQSTATUS_1            0x108
> -#define MAILBOX_IRQENABLE_1            0x10c
> -#define MAILBOX_IRQSTATUS_2            0x110
> -#define MAILBOX_IRQENABLE_2            0x114
> -#define MAILBOX_IRQSTATUS_3            0x118
> -#define MAILBOX_IRQENABLE_3            0x11c
> +#define MAILBOX_REVISION               0x000
> +#define MAILBOX_SYSCONFIG              0x010
> +#define MAILBOX_SYSSTATUS              0x014
> +#define MAILBOX_MESSAGE(m)             (0x040 + 4 * (m))
> +#define MAILBOX_FIFOSTATUS(m)          (0x080 + 4 * (m))
> +#define MAILBOX_MSGSTATUS(m)           (0x0c0 + 4 * (m))
> +#define MAILBOX_IRQSTATUS(u)           (0x100 + 8 * (u))
> +#define MAILBOX_IRQENABLE(u)           (0x108 + 8 * (u))
                                                                  ^^^^^^^
shouldn't this be
#define MAILBOX_IRQENABLE(u)           (0x104 + 8 * (u))

>
> -static unsigned long mbox_base;
> +#define MAILBOX_IRQ_NEWMSG(u)          (1 << (2 * (u)))
> +#define MAILBOX_IRQ_NOTFULL(u)         (1 << (2 * (u) + 1))
>
> -#define MAILBOX_IRQ_NOTFULL(n)         (1 << (2 * (n) + 1))
> -#define MAILBOX_IRQ_NEWMSG(n)          (1 << (2 * (n)))
> +static unsigned long mbox_base;
>
>  struct omap_mbox2_fifo {
>        unsigned long msg;
