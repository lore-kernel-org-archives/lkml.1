Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab0CITka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 14:40:30 -0500
Received: from xenotime.net ([72.52.64.118]:35655 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750972Ab0CITk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 14:40:28 -0500
Message-ID: <4B96A426.1080307@xenotime.net>
Date: Tue, 09 Mar 2010 11:40:22 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: aseemsethi@yahoo.com
CC: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi:fix missing KERN_facility level in ni_labpc.c
References: <201003100004.36422.aseemsethi@yahoo.com>
In-Reply-To: <201003100004.36422.aseemsethi@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/10 10:34, aseem sethi wrote:
> From: aseemsethi <aseemsethi@yahoo.com>
>  This is a patch to fix the "missing KERN_facility level" error found when running the checkpatch.pl script
>  Signed-off-by: Aseem Sethi <aseemsethi@yahoo.com>
> 
> ---
>  drivers/staging/comedi/drivers/ni_labpc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
> index 3c88caa..63853c2 100644
> --- a/drivers/staging/comedi/drivers/ni_labpc.c
> +++ b/drivers/staging/comedi/drivers/ni_labpc.c
> @@ -535,7 +535,7 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
>         printk("\n");
>  
>         if (iobase == 0) {
> -               printk("io base address is zero!\n");
> +               printk(KERN_ERR "io base address is zero!\n");
>                 return -EINVAL;
>         }
>         /*  request io regions for isa boards */


Hi,

How does someone know that this message comes from this driver and
not from some other driver or core part of the kernel?


I'd be much more interested in someone fixing comedi build errors (that have
been around forever -- I reported these long ago) when CONFIG_PCI=n and
CONFIG_COMEDI=m, CONFIG_COMEDI_PCMCIA=m, CONFIG_PCCARD=y, CONFIG_PCMCIA=y,
but CONFIG_CARDBUS=n:

ERROR: "ni_tio_rinsn" [drivers/staging/comedi/drivers/ni_mio_cs.ko] undefined!
ERROR: "ni_tio_winsn" [drivers/staging/comedi/drivers/ni_mio_cs.ko] undefined!
ERROR: "ni_tio_insn_config" [drivers/staging/comedi/drivers/ni_mio_cs.ko] undefined!
ERROR: "ni_tio_init_counter" [drivers/staging/comedi/drivers/ni_mio_cs.ko] undefined!
ERROR: "ni_gpct_device_construct" [drivers/staging/comedi/drivers/ni_mio_cs.ko] undefined!
ERROR: "ni_gpct_device_destroy" [drivers/staging/comedi/drivers/ni_mio_cs.ko] undefined!
ERROR: "labpc_1200_is_unipolar" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
ERROR: "labpc_1200_ai_gain_bits" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
ERROR: "range_labpc_1200_ai" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
ERROR: "labpc_common_detach" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
ERROR: "labpc_common_attach" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
ERROR: "das08_cs_boards" [drivers/staging/comedi/drivers/das08_cs.ko] undefined!
ERROR: "das08_common_detach" [drivers/staging/comedi/drivers/das08_cs.ko] undefined!
ERROR: "das08_common_attach" [drivers/staging/comedi/drivers/das08_cs.ko] undefined!

I.e., the "pcmcia" drivers are probably cardbus drivers (or at least some of them are),
but there is no differentiation between PCMCIA and CARDBUS.


-- 
~Randy
