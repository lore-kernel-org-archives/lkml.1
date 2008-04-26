Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbYDZHeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbYDZHeW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 03:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbYDZHeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 03:34:05 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53377 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbYDZHeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 03:34:03 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4812DA93.6020707@s5r6.in-berlin.de>
Date: Sat, 26 Apr 2008 09:32:35 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Erez Zadok <ezk@cs.sunysb.edu>
CC: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org,
       krh@redhat.com, airlied@linux.ie, rolandd@cisco.com,
       James.Bottomley@HansenPartnership.com, hjk@linutronix.de,
       vandrove@vc.cvut.cz, mfasheh@suse.com, hugh@veritas.com, perex@perex.cz,
       avi@qumranet.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] VM: vm_ops->fault takes explicit struct file
References: <200804252320.m3PNK0Bw014449@agora.fsl.cs.sunysb.edu>
In-Reply-To: <200804252320.m3PNK0Bw014449@agora.fsl.cs.sunysb.edu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Erez Zadok wrote:
> For convenience of review and bisectability, I present the changes as one
> patch here.  If desired, I can split it for each subsystem.

Hmm, a split patch won't be useful; it won't compile.

Besides, this change doesn't look too intrusive to me.  For example, 
changes like this...

[...]
> --- a/drivers/ieee1394/dma.c
> +++ b/drivers/ieee1394/dma.c
> @@ -232,7 +232,7 @@ void dma_region_sync_for_device(struct dma_region *dma, unsigned long offset,
>  #ifdef CONFIG_MMU
>  
>  static int dma_region_pagefault(struct vm_area_struct *vma,
> -				struct vm_fault *vmf)
> +				struct vm_fault *vmf, struct file *file)
>  {
>  	struct dma_region *dma = (struct dma_region *)vma->vm_private_data;
>  

...are unlikely to cause objections or merge rejects.  ACK from me for 
the ieee1394 part, FWIW.

PS:  It's an obscure and unimportant fact, but you are not required to 
Cc krh on changes in drivers/ieee1394; he is interested in 
drivers/firewire which is separate code.
-- 
Stefan Richter
-=====-==--- -=-- ==-=-
http://arcgraph.de/sr/
