Return-Path: <linux-kernel-owner+w=401wt.eu-S1751750AbZHAP2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbZHAP2d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 11:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751660AbZHAP2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 11:28:33 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35880 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbZHAP2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 11:28:32 -0400
Message-ID: <4A745F1F.50304@cs.helsinki.fi>
Date: Sat, 01 Aug 2009 18:28:31 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: Christoph Lameter <cl@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [SLUB] change kmem_cache->align to record the real alignment
References: <1248924491.2560.725.camel@ymzhang>
In-Reply-To: <1248924491.2560.725.camel@ymzhang>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang, Yanmin wrote:
> kmem_cache->align records the original align parameter value specified
> by users. Function calculate_alignment might change it based on cache
> line size. So change kmem_cache->align correspondingly.
> 
> ﻿Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
> 
> ---
> 
> --- linux-2.6.31-rc3/mm/slub.c	2009-07-20 00:29:39.000000000 +0800
> +++ linux-2.6.31-rc3_slubalign/mm/slub.c	2009-07-30 01:19:29.000000000 +0800
> @@ -2400,6 +2400,7 @@ static int calculate_sizes(struct kmem_c
>  	 * on bootup.
>  	 */
>  	align = calculate_alignment(flags, align, s->objsize);
> +	s->align = align;
>  
>  	/*
>  	 * SLUB stores one object immediately after another beginning from
> 
> 

Applied, thanks!
