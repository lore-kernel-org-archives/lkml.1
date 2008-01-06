Return-Path: <linux-kernel-owner+w=401wt.eu-S1759330AbYAFQhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbYAFQhB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 11:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbYAFQgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 11:36:54 -0500
Received: from mail.dunaweb.hu ([81.17.184.3]:42590 "EHLO mail.dunaweb.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923AbYAFQgy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 11:36:54 -0500
X-Greylist: delayed 1389 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Jan 2008 11:36:53 EST
Message-ID: <4780FE2F.60100@dunaweb.hu>
Date: Sun, 06 Jan 2008 17:13:35 +0100
From: Zoltan Boszormenyi <zboszor@dunaweb.hu>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: FD Cami <francois.cami@free.fr>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Re: Forcing modes in libata (was: SATA buffered read VERY
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Once upon a time FD Cami wrote:
> On Sun, 6 Jan 2008 13:36:09 +0000
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
> > On Sun, 6 Jan 2008 08:03:31 +0300
> > > > For now you can boot with libata.dma=1 to select DMA on disks but
> > > > not CD
> > > 
> > > Great, but why isn't this in the documentation?
> > 
> > Send patches
>
> patch attached.
>
> Description : Add libata.dma= to Documentation/kernel-parameters.txt
>
> Found documentation in :
> http://www.mail-archive.com/linux-ide%40vger.kernel.org/msg09849.html
> http://www.redhat.com/archives/fedora-extras-commits/2007-October/msg04568.html
>
> Signed-off-by: François Cami <francois.cami@free.fr>
>
> *["libata-doc-patch.txt" (text/plain)]* <http://marc.info/?l=linux-kernel&m=119963307018562&q=p3>
>
> diff -rU2 linux-2.6.24-rc6/Documentation/kernel-parameters.txt \
>                 linux-2.6.24-rc6-mine/Documentation/kernel-parameters.txt
> --- linux-2.6.24-rc6/Documentation/kernel-parameters.txt	2008-01-06 \
>                 15:58:54.000000000 +0100
> +++ linux-2.6.24-rc6-mine/Documentation/kernel-parameters.txt	2008-01-06 \
> 16:11:20.000000000 +0100 @@ -883,4 +883,11 @@
>  			C2 power state.
>  
> +	libata.dma=	[LIBATA] DMA control
> +			libata.dma=0	  Disable all PATA DMA like old IDE
> +			libata.dma=1	  Disk DMA only
> +			libata.dma=2	  ATAPI DMA only
> +			libata.dma=3	  CF DMA only 
> +			libata.dma=0,1,3  Combinations also work.
> +
>   

The code patch you are looking at has little different semantics.
(1 << 2) is 4 not 3... Values for different devices are:

1  - ATA
2 - ATAPI
4 - CF

The parameter is a bitmask of 1, 2, 4. Default is 7.
2.6.24-rc3 also has this in libata-core.c which confirms
the acceptance of a bitmask :

static int libata_dma_mask = 
ATA_DMA_MASK_ATA|ATA_DMA_MASK_ATAPI|ATA_DMA_MASK_CFA;
module_param_named(dma, libata_dma_mask, int, 0444);
MODULE_PARM_DESC(dma, "DMA enable/disable (0x1==ATA, 0x2==ATAPI, 0x4==CF)");

Best regards,
Zoltán Böszörményi


