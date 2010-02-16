Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261Ab0BPTlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 14:41:53 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:44775 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933158Ab0BPTlt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 14:41:49 -0500
MIME-Version: 1.0
In-Reply-To: <200912161429.14968.roman.fietze@telemotive.de>
References: <200912161429.14968.roman.fietze@telemotive.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 16 Feb 2010 12:41:27 -0700
X-Google-Sender-Auth: 169150cdb6f85c34
Message-ID: <fa686aa41002161141v20a06768nbdcdb094293bb5b2@mail.gmail.com>
Subject: Re: [PATCH] pata_mpc52xx: optimizing code size by change of ATA 
	timing data types
To: Roman Fietze <roman.fietze@telemotive.de>
Cc: linuxppc-dev@lists.ozlabs.org, linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jgarzik@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'd linux-kernel, linux-ide and Jeff Garzik]

Hi Roman.

you should use ./scripts/get_maintainer.pl to make sure you're cc'ing
the right people when posting patches.  You should repost so that Jeff
has a copy of the patch to pick up (and add my acked-by when you do).

On Wed, Dec 16, 2009 at 6:29 AM, Roman Fietze
<roman.fietze@telemotive.de> wrote:
> Hello Everybody,
>
> A totally simple patch that reduces the text size as of the
> ppc_6xx-size command of pata_mpc52xx by more than 10%, by reducing the
> rodata size from 0x4a4 to 0x17e bytes. This is simply done by changing
> the data types of the ATA timing constants.

Acked-by: Grant Likely <grant.likely@secretlab>

>
> If you are interested at all, and it's worth the trouble, here the
> details:
>
> ppc_6xx-size:
>     text data bss  dec  hex filename
> old: 6532 1068   0 7600 1db0 pata_mpc52xx.o
> new: 5718 1068   0 6786 1a82 pata_mpc52xx.o
>
> The (assembler) code itself doesn't really change very much. I double
> checked the final results inside mpc52xx_ata_apply_timings() and they
> match.
>
> BTW: Should I break lines at col 72 or 80?
>
>
> From: Roman Fietze <roman.fietze@telemotive.de>
> Date: Wed, 16 Dec 2009 13:10:31 +0100
> Subject: [PATCH] pata_mpc52xx: reduce code size by simple change of constant data types
>
> Signed-off-by: Roman Fietze <roman.fietze@telemotive.de>
> ---
>  drivers/ata/pata_mpc52xx.c |   78 ++++++++++++++++++++++----------------------
>  1 files changed, 39 insertions(+), 39 deletions(-)
>
> diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
> index 2bc2dbe..e4e5e82 100644
> --- a/drivers/ata/pata_mpc52xx.c
> +++ b/drivers/ata/pata_mpc52xx.c
> @@ -64,13 +64,13 @@ struct mpc52xx_ata_priv {
>
>
>  /* ATAPI-4 PIO specs (in ns) */
> -static const int ataspec_t0[5]    = {600, 383, 240, 180, 120};
> -static const int ataspec_t1[5]    = { 70,  50,  30,  30,  25};
> -static const int ataspec_t2_8[5]  = {290, 290, 290,  80,  70};
> -static const int ataspec_t2_16[5] = {165, 125, 100,  80,  70};
> -static const int ataspec_t2i[5]   = {  0,   0,   0,  70,  25};
> -static const int ataspec_t4[5]    = { 30,  20,  15,  10,  10};
> -static const int ataspec_ta[5]    = { 35,  35,  35,  35,  35};
> +static const u16 ataspec_t0[5]         = {600, 383, 240, 180, 120};
> +static const u16 ataspec_t1[5]         = { 70,  50,  30,  30,  25};
> +static const u16 ataspec_t2_8[5]       = {290, 290, 290,  80,  70};
> +static const u16 ataspec_t2_16[5]      = {165, 125, 100,  80,  70};
> +static const u16 ataspec_t2i[5]                = {  0,   0,   0,  70,  25};
> +static const u16 ataspec_t4[5]         = { 30,  20,  15,  10,  10};
> +static const u16 ataspec_ta[5]         = { 35,  35,  35,  35,  35};
>
>  #define CALC_CLKCYC(c,v) ((((v)+(c)-1)/(c)))
>
> @@ -78,13 +78,13 @@ static const int ataspec_ta[5]    = { 35,  35,  35,  35,  35};
>
>  /* ATAPI-4 MDMA specs (in clocks) */
>  struct mdmaspec {
> -       u32 t0M;
> -       u32 td;
> -       u32 th;
> -       u32 tj;
> -       u32 tkw;
> -       u32 tm;
> -       u32 tn;
> +       u8 t0M;
> +       u8 td;
> +       u8 th;
> +       u8 tj;
> +       u8 tkw;
> +       u8 tm;
> +       u8 tn;
>  };
>
>  static const struct mdmaspec mdmaspec66[3] = {
> @@ -101,23 +101,23 @@ static const struct mdmaspec mdmaspec132[3] = {
>
>  /* ATAPI-4 UDMA specs (in clocks) */
>  struct udmaspec {
> -       u32 tcyc;
> -       u32 t2cyc;
> -       u32 tds;
> -       u32 tdh;
> -       u32 tdvs;
> -       u32 tdvh;
> -       u32 tfs;
> -       u32 tli;
> -       u32 tmli;
> -       u32 taz;
> -       u32 tzah;
> -       u32 tenv;
> -       u32 tsr;
> -       u32 trfs;
> -       u32 trp;
> -       u32 tack;
> -       u32 tss;
> +       u8 tcyc;
> +       u8 t2cyc;
> +       u8 tds;
> +       u8 tdh;
> +       u8 tdvs;
> +       u8 tdvh;
> +       u8 tfs;
> +       u8 tli;
> +       u8 tmli;
> +       u8 taz;
> +       u8 tzah;
> +       u8 tenv;
> +       u8 tsr;
> +       u8 trfs;
> +       u8 trp;
> +       u8 tack;
> +       u8 tss;
>  };
>
>  static const struct udmaspec udmaspec66[6] = {
> @@ -270,7 +270,7 @@ mpc52xx_ata_compute_pio_timings(struct mpc52xx_ata_priv *priv, int dev, int pio)
>  {
>        struct mpc52xx_ata_timings *timing = &priv->timings[dev];
>        unsigned int ipb_period = priv->ipb_period;
> -       unsigned int t0, t1, t2_8, t2_16, t2i, t4, ta;
> +       u32 t0, t1, t2_8, t2_16, t2i, t4, ta;
>
>        if ((pio < 0) || (pio > 4))
>                return -EINVAL;
> @@ -299,8 +299,8 @@ mpc52xx_ata_compute_mdma_timings(struct mpc52xx_ata_priv *priv, int dev,
>        if (speed < 0 || speed > 2)
>                return -EINVAL;
>
> -       t->mdma1 = (s->t0M << 24) | (s->td << 16) | (s->tkw << 8) | (s->tm);
> -       t->mdma2 = (s->th << 24) | (s->tj << 16) | (s->tn << 8);
> +       t->mdma1 = ((u32)s->t0M << 24) | ((u32)s->td << 16) | ((u32)s->tkw << 8) | s->tm;
> +       t->mdma2 = ((u32)s->th << 24) | ((u32)s->tj << 16) | ((u32)s->tn << 8);
>        t->using_udma = 0;
>
>        return 0;
> @@ -316,11 +316,11 @@ mpc52xx_ata_compute_udma_timings(struct mpc52xx_ata_priv *priv, int dev,
>        if (speed < 0 || speed > 2)
>                return -EINVAL;
>
> -       t->udma1 = (s->t2cyc << 24) | (s->tcyc << 16) | (s->tds << 8) | s->tdh;
> -       t->udma2 = (s->tdvs << 24) | (s->tdvh << 16) | (s->tfs << 8) | s->tli;
> -       t->udma3 = (s->tmli << 24) | (s->taz << 16) | (s->tenv << 8) | s->tsr;
> -       t->udma4 = (s->tss << 24) | (s->trfs << 16) | (s->trp << 8) | s->tack;
> -       t->udma5 = (s->tzah << 24);
> +       t->udma1 = ((u32)s->t2cyc << 24) | ((u32)s->tcyc << 16) | ((u32)s->tds << 8) | s->tdh;
> +       t->udma2 = ((u32)s->tdvs << 24) | ((u32)s->tdvh << 16) | ((u32)s->tfs << 8) | s->tli;
> +       t->udma3 = ((u32)s->tmli << 24) | ((u32)s->taz << 16) | ((u32)s->tenv << 8) | s->tsr;
> +       t->udma4 = ((u32)s->tss << 24) | ((u32)s->trfs << 16) | ((u32)s->trp << 8) | s->tack;
> +       t->udma5 = (u32)s->tzah << 24;
>        t->using_udma = 1;
>
>        return 0;
> --
> 1.6.5.3
>
>
> Roman
>
> --
> Roman Fietze                Telemotive AG Büro Mühlhausen
> Breitwiesen                              73347 Mühlhausen
> Tel.: +49(0)7335/18493-45        http://www.telemotive.de
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
