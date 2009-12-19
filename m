Return-Path: <linux-kernel-owner+w=401wt.eu-S1754097AbZLSWGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbZLSWGe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 17:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbZLSWGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 17:06:33 -0500
Received: from extranet.aprogsys.com ([91.121.73.63]:57472 "EHLO
	extranet.aprogsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbZLSWGc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 17:06:32 -0500
From: Vincent ETIENNE <ve@vetienne.net>
Organization: HOME
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: Kernel 2.66.33-rC1 boot problem bisected to commit 99935a7a59eaca0292c1a5880e10bae03f4a5e3d
Date: Sat, 19 Dec 2009 23:06:29 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc1-dirty; KDE/4.3.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org
References: <200912191707.16648.ve@vetienne.net> <4B2D4781.20907@kernel.org>
In-Reply-To: <4B2D4781.20907@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200912192306.29636.ve@vetienne.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 19 décembre 2009 22:37:05, Yinghai Lu a écrit :
> Vincent ETIENNE wrote:
> > I am experiencing boot problem with kernel 2.6.33-rc1.  Bisection points
> > to
> >
> 
> please check
> 
> Subject: [PATCH 1/7] x86/pci: intel ioh bus num reg accessing fix
> 
> it is above 0x100, so if mmconf is not enable, need to skip it
> 
> Reported-by: Jens Axboe <jens.axboe@oracle.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/pci/intel_bus.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: linux-2.6/arch/x86/pci/intel_bus.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/pci/intel_bus.c
> +++ linux-2.6/arch/x86/pci/intel_bus.c
> @@ -49,6 +49,10 @@ static void __devinit pci_root_bus_res(s
>  	u64 mmioh_base, mmioh_end;
>  	int bus_base, bus_end;
> 
> +	/* some sys doesn't get mmconf enabled */
> +	if (dev->cfg_size < 0x200)
> +		return;
> +
>  	if (pci_root_num >= PCI_ROOT_NR) {
>  		printk(KERN_DEBUG "intel_bus.c: PCI_ROOT_NR is too small\n");
>  		return;
> 

It works : v2.6;33_rc1 + your patch booot sucessfully on my machine
Thanks a lot

		Vincent
