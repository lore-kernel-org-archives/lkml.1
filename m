Return-Path: <linux-kernel-owner+w=401wt.eu-S1764841AbXHDN0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764841AbXHDN0Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 09:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757966AbXHDN0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 09:26:17 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:35255 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756202AbXHDN0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 09:26:16 -0400
Date: Sat, 4 Aug 2007 15:26:13 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: David Vrabel <david.vrabel@csr.com>
Cc: linux-kernel@vger.kernel.org, David Vrabel <david.vrabel@csr.com>
Subject: Re: sdio: parameterize SDIO FBR register defines
Message-ID: <20070804152613.1f190abc@poseidon.drzeus.cx>
In-Reply-To: <11858961931710-git-send-email-david.vrabel@csr.com>
References: <11858961933491-git-send-email-david.vrabel@csr.com>
	<11858961931710-git-send-email-david.vrabel@csr.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 16:36:31 +0100
David Vrabel <david.vrabel@csr.com> wrote:

> Signed-off-by: David Vrabel <david.vrabel@csr.com>
> 
> ---
> commit 51755c3d59be1ba778bef45888f9f5e341dc4af4
> tree c7bbb562b2d801197eefb619a17c94467c1299cd
> parent 1cf0b6019aa3916197eecafe058bd2f3d700d24a
> author David Vrabel <david.vrabel@csr.com> Mon, 30 Jul 2007 19:20:59
> +0100 committer David Vrabel <dvrabel@cantab.net> Mon, 30 Jul 2007
> 19:28:30 +0100
> 
>  drivers/mmc/core/sdio.c     |    4 ++--
>  drivers/mmc/core/sdio_cis.c |    2 +-
>  include/linux/mmc/sdio.h    |   16 +++++++++-------
>  3 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
> index 6589fd6..08f579c 100644
> --- a/drivers/mmc/core/sdio.c
> +++ b/drivers/mmc/core/sdio.c
> @@ -30,7 +30,7 @@ static int sdio_read_fbr(struct sdio_func *func)
>  	unsigned char data;
>  
>  	ret = mmc_io_rw_direct(func->card, 0, 0,
> -		func->num * 0x100 + SDIO_FBR_STD_IF, 0, &data);
> +		SDIO_FBR_STD_IF(func->num), 0, &data);
>  	if (ret != MMC_ERR_NONE)
>  		goto out;
>  

I am a bit sceptical about these macros. Most i/o code in the kernel is
in the form of "<base address> + <register offset>". For one thing,
that model keeps the register defines clean and means people don't have
to go reaching for specs all the time.

Would you be content with replacing "func->num * 0x100" with a macro so
that the code becomes something like:

	SDIO_FBR_BASE(func->num) + SDIO_FBR_STD_IF

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
