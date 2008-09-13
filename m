Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700AbYIMT4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbYIMT4g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 15:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbYIMT4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 15:56:16 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52804 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852AbYIMTzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 15:55:52 -0400
Message-ID: <48CC1AC3.7090406@garzik.org>
Date: Sat, 13 Sep 2008 15:55:47 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Hannes Hering <hannes.hering@gmx.de>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, ossrosch@linux.vnet.ibm.com,
       ossthema@de.ibm.com, raisch@de.ibm.com, themann@de.ibm.com,
       osstklei@de.ibm.com
Subject: Re: [PATCH 1/2] ehea: Fix DLPAR memory handling
References: <200809051636.26545.hannes.hering@gmx.de>
In-Reply-To: <200809051636.26545.hannes.hering@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Hering wrote:
> The ehea busmap must be allocated only once in the first of many calls of the
> ehea_create_busmap_callback.
> 
> Signed-off-by: Hannes Hering <hering2@de.ibm.com>
> ---
> 
> diff -Nurp -X dontdiff linux-2.6.27-rc5/drivers/net/ehea/ehea_qmr.c patched_kernel/drivers/net/ehea/ehea_qmr.c
> --- linux-2.6.27-rc5/drivers/net/ehea/ehea_qmr.c	2008-08-29 00:52:02.000000000 +0200
> +++ patched_kernel/drivers/net/ehea/ehea_qmr.c	2008-09-05 15:31:30.000000000 +0200
> @@ -595,7 +595,8 @@ static int ehea_create_busmap_callback(u
>  	end_section = start_section + ((nr_pages * PAGE_SIZE) / EHEA_SECTSIZE);
>  	mr_len = *(unsigned long *)arg;
>  
> -	ehea_bmap = kzalloc(sizeof(struct ehea_bmap), GFP_KERNEL);
> +	if (!ehea_bmap)
> +		ehea_bmap = kzalloc(sizeof(struct ehea_bmap), GFP_KERNEL);
>  	if (!ehea_bmap)
>  		return -ENOMEM;

applied


