Return-Path: <linux-kernel-owner+w=401wt.eu-S932095AbXF1WkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbXF1WkQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 18:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758062AbXF1WkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 18:40:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38878 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755669AbXF1WkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 18:40:01 -0400
Date: Thu, 28 Jun 2007 15:39:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, perex@suse.cz
Subject: Re: [PATCH] ALSA: more section mismatches
Message-Id: <20070628153949.8582d3a4.akpm@linux-foundation.org>
In-Reply-To: <20070628150515.0d819891.randy.dunlap@oracle.com>
References: <20070628150515.0d819891.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007 15:05:15 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix section mismatch warnings:
> 
> WARNING: sound/built-in.o(.exit.text+0x3ad): Section mismatch: reference to .init.text: (between 'sb_exit' and 'unload_uart6850')
> WARNING: sound/built-in.o(.exit.text+0x753): Section mismatch: reference to .init.text: (between 'snd_mts64_module_exit' and 'snd_portman_module_exit')
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  sound/drivers/mts64.c |    2 +-
>  sound/oss/sb_card.c   |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-2622-rc6.orig/sound/drivers/mts64.c
> +++ linux-2622-rc6/sound/drivers/mts64.c
> @@ -1048,7 +1048,7 @@ static struct platform_driver snd_mts64_
>  /*********************************************************************
>   * module init stuff
>   *********************************************************************/
> -static void __init_or_module snd_mts64_unregister_all(void)
> +static void snd_mts64_unregister_all(void)

Well this is called from __exit, so __init_or_module isn't right.  But we
don't have an __exit_or_module.

>  {
>  	int i;
>  
> --- linux-2622-rc6.orig/sound/oss/sb_card.c
> +++ linux-2622-rc6/sound/oss/sb_card.c
> @@ -290,7 +290,7 @@ static struct pnp_card_driver sb_pnp_dri
>  MODULE_DEVICE_TABLE(pnp_card, sb_pnp_card_table);
>  #endif /* CONFIG_PNP */
>  
> -static void __init_or_module sb_unregister_all(void)
> +static void sb_unregister_all(void)
>  {
>  #ifdef CONFIG_PNP
>  	if (pnp_registered)

One of these is alsa and the other isn't.

But what the heck: obviously safe, I'll slam it all in.
