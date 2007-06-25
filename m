Return-Path: <linux-kernel-owner+w=401wt.eu-S1754952AbXFYXlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbXFYXlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 19:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbXFYXlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 19:41:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47349 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751531AbXFYXlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 19:41:24 -0400
Date: Mon, 25 Jun 2007 16:41:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, perex@suse.cz,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH] ALSA: fix ice1712 section mismatch
Message-Id: <20070625164110.94ecade1.akpm@linux-foundation.org>
In-Reply-To: <20070625161739.8115c40c.randy.dunlap@oracle.com>
References: <20070625161739.8115c40c.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007 16:17:39 -0700 Randy Dunlap <randy.dunlap@oracle.com>
wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Cannot mix const and __initdata:
> sound/pci/ice1712/prodigy192.c:708: error: ak4114_controls causes a section type conflict
> 

This is a fatal compilation error, isn't it?

> ---
>  sound/pci/ice1712/prodigy192.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.22-rc6.orig/sound/pci/ice1712/prodigy192.c
> +++ linux-2.6.22-rc6/sound/pci/ice1712/prodigy192.c
> @@ -705,7 +705,7 @@ static int ak4114_input_sw_put(struct sn
>  }
>  
>  
> -static const struct snd_kcontrol_new ak4114_controls[] __devinitdata = {
> +static struct snd_kcontrol_new ak4114_controls[] __devinitdata = {
>  	{
>  		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
>  		.name = "MIODIO IEC958 Capture Input",

That patch is already in the alsa git tree (has been there for five days),
so I would of course prefer that the alsa guys merge it into 2.6.22.

However alsa merges are a bit spotty, so I'll queue this up anyway and will
merge it in a day or three if nothing else happens, OK?

