Return-Path: <linux-kernel-owner+w=401wt.eu-S1755810AbZG0JVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbZG0JVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 05:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755616AbZG0JVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 05:21:38 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:43994 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537AbZG0JVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 05:21:37 -0400
From: Karsten Keil <keil@b1-systems.de>
Organization: B1-systems
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next:  tree build failure
Date: Mon, 27 Jul 2009 11:21:33 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.27.23-0.1-default; KDE/4.2.1; x86_64; ; )
References: <20090727175328.fe3197a5.sfr@canb.auug.org.au>
In-Reply-To: <20090727175328.fe3197a5.sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907271121.34348.keil@b1-systems.de>
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,


On Montag, 27. Juli 2009 09:53:28 you wrote:
> Hi Dave,
>
> Today's linux-next build (powerpc allyesconfig) failed like this:
>
> drivers/isdn/hisax/built-in.o: In function `setup_w6692':
> (.opd+0x4a28): multiple definition of `setup_w6692'
> drivers/isdn/hardware/built-in.o:(.opd+0x4e90): first defined here
> drivers/isdn/hisax/built-in.o: In function `.setup_w6692':
> (.devinit.text+0x5b14): multiple definition of `.setup_w6692'
> drivers/isdn/hardware/built-in.o:(.text+0x8b75c): first defined here
>
> Caused by commit 707b2ce6c1f4f1261788f2ff09ad82c35e0e6240
> ("mISDN: Add driver for Winbond cards").
>
> setup_w6692 appears in drivers/isdn/hardware/mISDN/w6692.c and
> drivers/isdn/hisax/w6692.c.  I applied the patch below for today (this
> may not be correct).
>

Sorry for that, yes this fix is correct - I really should test allyesconfig 
more times by myself  :-(.

ACK.

> [I also get these warnings:
> drivers/isdn/hardware/mISDN/w6692.c:533: warning: 'setvolume' defined but
> not used drivers/isdn/hardware/mISDN/w6692.c:560: warning: 'enable_pots'
> defined but not used ]

The POTS code is implemented, but the higher level interface is not finally 
defined yet, so the two functions are not used at the moment.
The interface will added soon.


> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 27 Jul 2009 17:45:36 +1000
> Subject: [PATCH] net: fix multiple definitions of setup_w6692
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/isdn/hardware/mISDN/w6692.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/isdn/hardware/mISDN/w6692.c
> b/drivers/isdn/hardware/mISDN/w6692.c index 1b9008f..d3f1077 100644
> --- a/drivers/isdn/hardware/mISDN/w6692.c
> +++ b/drivers/isdn/hardware/mISDN/w6692.c
> @@ -1234,7 +1234,7 @@ w6692_dctrl(struct mISDNchannel *ch, u32 cmd, void
> *arg) return err;
>  }
>
> -int
> +static int
>  setup_w6692(struct w6692_hw *card)
>  {
>  	u32	val;

