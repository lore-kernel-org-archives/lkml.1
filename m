Return-Path: <linux-kernel-owner+w=401wt.eu-S1758201AbXEMGN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201AbXEMGN0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 02:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756949AbXEMGNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 02:13:20 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:35793 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbXEMGNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 02:13:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AUiDtakMUwzlNrsyAPAumtdC1WopUpsVbrt/DqavQ9mSqd628VORzG53+tDIfa+yAppb9ctS0P6L2roWlb/tr+j2b04EGfGcnrDgDAwIS9E8i0z5I/EtcMjK7DvyPjyfDNzaI7UsCHID8srWLZYvquX/vy6SVjke4x5WJSfu/uc=
Message-ID: <b6a2187b0705122313n1de6dccci4c7f79c835b2be4f@mail.gmail.com>
Date: Sun, 13 May 2007 14:13:18 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.22-rc1
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705131359200.26974@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705131359200.26974@boston.corp.fedex.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Take that back. It's after patching reiser4-for-2.6.21.patch.gz that
causes duplicated export symbols.

Sorry,
Jeff.


On 5/13/07, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>
> Linus,
>
> > So give it a good testing. We'll see how the regression tracking ends up
> > working, but in order to actually track that, we want people actively
> > testing -rc1 and making good reports!
>
> Here's a little patch to fix filemap.c compilation problem ...
>
>
> Thanks,
> Jeff
>
>
> --- linux/mm/filemap.c.org      2007-05-13 13:54:16 +0800
> +++ linux/mm/filemap.c  2007-05-13 13:54:25 +0800
> @@ -782,6 +782,7 @@
>         read_unlock_irq(&mapping->tree_lock);
>         return ret;
>   }
> +EXPORT_SYMBOL(find_get_pages);
>   EXPORT_SYMBOL(find_get_pages_tag);
>
>   /**
> @@ -840,8 +841,6 @@
>
>         ra->ra_pages /= 4;
>   }
> -EXPORT_SYMBOL(find_get_pages);
> -EXPORT_SYMBOL(find_get_pages_tag);
>
>   /**
>    * do_generic_mapping_read - generic file read routine
>
>
