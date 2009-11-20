Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbZKTTgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbZKTTgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 14:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbZKTTgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 14:36:17 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:51183 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbZKTTgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 14:36:16 -0500
Date: Fri, 20 Nov 2009 11:34:41 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Jaroslav Kysela <perex@perex.cz>
Subject: Re: linux-next: Tree for November 20 (snd_jack)
Message-Id: <20091120113441.3ed5d339.randy.dunlap@oracle.com>
In-Reply-To: <s5hlji180kg.wl%tiwai@suse.de>
References: <20091120230513.0d2e5cb5.sfr@canb.auug.org.au>
	<20091120104030.01972d33.randy.dunlap@oracle.com>
	<s5hpr7d80to.wl%tiwai@suse.de>
	<s5hlji180kg.wl%tiwai@suse.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B06EFAA.0111:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Nov 2009 20:21:03 +0100 Takashi Iwai wrote:

> At Fri, 20 Nov 2009 20:15:31 +0100,
> I wrote:
> > 
> > At Fri, 20 Nov 2009 10:40:30 -0800,
> > Randy Dunlap wrote:
> > > 
> > > On Fri, 20 Nov 2009 23:05:13 +1100 Stephen Rothwell wrote:
> > > 
> > > > Hi all,
> > > > 
> > > > Changes since 20091119:
> > > 
> > > 
> > > This commit in linux-next-20091120:
> > > 
> > > author	Mark Brown <broonie@opensource.wolfsonmicro.com>	
> > > 	Mon, 28 Jul 2008 18:05:36 +0000 (19:05 +0100)
> > > committer	Jaroslav Kysela <perex@perex.cz>	
> > > 	Tue, 29 Jul 2008 19:32:06 +0000 (21:32 +0200)
> > > commit	0d94e41abe271c86df06bcf72d24f9ca7ce771f0
> > > 
> > > causes build errors when:
> > > 
> > > CONFIG_INPUT=m
> > > CONFIG_SND=y
> > > CONFIG_SND_JACK=y
> > > CONFIG_SND_SOC=m
> > > CONFIG_SND_HDA_INTEL=m
> > > CONFIG_SND_HDA_INPUT_JACK=y
> > 
> > The problem isn't the commit above (it's over a year ago!), but the
> > recent change of hda input layer.

Ack, sorry about that.

> > Will take a look at later.  Thanks.
> 
> Does the patch below work?
> 

Yes, it does, thanks.

> 
> thanks,
> 
> Takashi
> 
> ---
> diff --git a/sound/pci/hda/Kconfig b/sound/pci/hda/Kconfig
> index 25ae10e..556cff9 100644
> --- a/sound/pci/hda/Kconfig
> +++ b/sound/pci/hda/Kconfig
> @@ -51,7 +51,7 @@ config SND_HDA_INPUT_BEEP_MODE
>  
>  config SND_HDA_INPUT_JACK
>  	bool "Support jack plugging notification via input layer"
> -	depends on INPUT=y || INPUT=SND_HDA_INTEL
> +	depends on INPUT=y || INPUT=SND
>  	select SND_JACK
>  	help
>  	  Say Y here to enable the jack plugging notification via


---
~Randy
