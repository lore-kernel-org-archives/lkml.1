Return-Path: <linux-kernel-owner+w=401wt.eu-S1756997AbYIIIAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997AbYIIIAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 04:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbYIIH7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 03:59:55 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:56720 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851AbYIIH7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 03:59:53 -0400
From: Hannes Hering <hannes.hering@linux.vnet.ibm.com>
To: akpm@linux-foundation.org
Subject: Re: + ehea-fix-dlpar-memory-handling.patch added to -mm tree
Date: Tue, 9 Sep 2008 09:58:47 +0200
User-Agent: KMail/1.9.9
References: <200809082225.m88MPu89013383@imap1.linux-foundation.org>
In-Reply-To: <200809082225.m88MPu89013383@imap1.linux-foundation.org>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, ossrosch@linux.vnet.ibm.com,
       ossthema@de.ibm.com, raisch@de.ibm.com, themann@de.ibm.com,
       osstklei@de.ibm.com
Organization: IBM
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809090958.47358.hannes.hering@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

please consider the ehea-fix-dlpar-memory-handling.patch as critical bug fix,
as it fixes a potential firmware error causing the driver to get inoperable
when system memory is sparse. Therefore please include this fix into 2.6.27.

Regards

Hannes

On Tuesday 09 September 2008 00:25:56 you wrote:
> 
> The patch titled
>      ehea: fix DLPAR memory handling
> has been added to the -mm tree.  Its filename is
>      ehea-fix-dlpar-memory-handling.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: ehea: fix DLPAR memory handling
> From: Hannes Hering <hannes.hering@gmx.de>
> 
> The ehea busmap must be allocated only once in the first of many calls of the
> ehea_create_busmap_callback.
> 
> Signed-off-by: Hannes Hering <hering2@de.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/net/ehea/ehea_qmr.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff -puN drivers/net/ehea/ehea_qmr.c~ehea-fix-dlpar-memory-handling drivers/net/ehea/ehea_qmr.c
> --- a/drivers/net/ehea/ehea_qmr.c~ehea-fix-dlpar-memory-handling
> +++ a/drivers/net/ehea/ehea_qmr.c
> @@ -595,7 +595,8 @@ static int ehea_create_busmap_callback(u
>  	end_section = start_section + ((nr_pages * PAGE_SIZE) / EHEA_SECTSIZE);
>  	mr_len = *(unsigned long *)arg;
>  
> -	ehea_bmap = kzalloc(sizeof(struct ehea_bmap), GFP_KERNEL);
> +	if (!ehea_bmap)
> +		ehea_bmap = kzalloc(sizeof(struct ehea_bmap), GFP_KERNEL);
>  	if (!ehea_bmap)
>  		return -ENOMEM;
>  
> _
> 
> Patches currently in -mm which might be from hannes.hering@gmx.de are
> 
> ehea-fix-dlpar-memory-handling.patch
> ehea-enable-dlpar-memory-remove.patch
>
