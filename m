Return-Path: <linux-kernel-owner+w=401wt.eu-S1755649AbZLDCOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649AbZLDCOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 21:14:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbZLDCOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 21:14:42 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:64714 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbZLDCOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 21:14:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=B5dPjOMoQamvKkqJHRyO41ym+j5ANhVt2s4h+Lfu8IjU48fFTYZ34YWabxLtGPx86o
         uvbxgTmp6ElkhuAALxTaU3pnwtAPBHT6TMotZ+7lax+jnyvVik8Vh9nARe03DXsq2jj9
         zqYHKwDK/5ubTIL0Zw8xAk4pkE8qG17br89sY=
Date: Fri, 4 Dec 2009 05:14:44 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mm-commits@vger.kernel.org, h-shimamoto@ct.jp.nec.com,
       chris.mason@oracle.com, konishi.ryusuke@lab.ntt.co.jp,
       swhiteho@redhat.com, tytso@mit.edu
Subject: Re: + task_struct-make-journal_info-conditional.patch added to -mm
 tree
Message-ID: <20091204021444.GA8392@x200>
References: <200912032240.nB3Mevae027408@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912032240.nB3Mevae027408@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 02:40:57PM -0800, akpm@linux-foundation.org wrote:
> --- a/include/linux/sched.h~task_struct-make-journal_info-conditional
> +++ a/include/linux/sched.h
> @@ -1452,8 +1452,10 @@ struct task_struct {
>  	gfp_t lockdep_reclaim_gfp;
>  #endif
>  
> +#ifdef CONFIG_FS_JOURNAL_INFO
>  /* journalling filesystem info */
>  	void *journal_info;
> +#endif

This will prevent using e.g. ext3 on CONFIG_EXT3_FS=n kernels.
