Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbYGDSdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbYGDSdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 14:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbYGDSda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 14:33:30 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37344 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbYGDSd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 14:33:29 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <486E6CED.8060309@s5r6.in-berlin.de>
Date: Fri, 04 Jul 2008 20:33:17 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080614 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Philippe De Muyter <phdm@macqel.be>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ieee1394 : dump mmapped video1394 buffers in core files
References: <20080701132149.GA32510@frolo.macqel>	<517f3f820807011116g6ce1b3e1qf166070f7a4c523f@mail.gmail.com>	<20080702105027.GA1111@frolo.macqel>	<cfd18e0f0807020358k317575c6ra0187428098f0160@mail.gmail.com>	<486C4CC5.2060006@hitachi.com>	<20080703093736.GA14369@frolo.macqel> <20080703165228.GA29373@frolo.macqel>
In-Reply-To: <20080703165228.GA29373@frolo.macqel>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philippe De Muyter wrote:
> Currently, core files do not contain the mmapped memory of the video1394
> or dv1394 devices,

Ditto with /dev/raw1394 when the rawiso ioctl API is used.

> which contain the actual video input, making it
> impossible to analyse the cause of abnormal program termination for
> image analysis or (de)compression software.  Fix that.
> 
> Signed-off-by: Philippe De Muyter <phdm@macqel.be>
> ---
> diff -r ced66ca0044f drivers/ieee1394/dma.c
> --- a/drivers/ieee1394/dma.c	Mon Jun 30 08:58:09 2008 -0700
> +++ b/drivers/ieee1394/dma.c	Thu Jul  3 18:40:24 2008 +0200
> @@ -274,7 +274,7 @@ int dma_region_mmap(struct dma_region *d
>  	vma->vm_ops = &dma_region_vm_ops;
>  	vma->vm_private_data = dma;
>  	vma->vm_file = file;
> -	vma->vm_flags |= VM_RESERVED;
> +	vma->vm_flags |= VM_RESERVED | VM_ALWAYSDUMP;
>  
>  	return 0;
>  }

I'll commit it with the title changed to "dump mmapped iso buffers in 
core files" if that's OK.
-- 
Stefan Richter
-=====-==--- -=== --=--
http://arcgraph.de/sr/
