Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbXJVWSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbXJVWSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 18:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbXJVWSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 18:18:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52495 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751028AbXJVWSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 18:18:09 -0400
Date: Mon, 22 Oct 2007 15:17:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: yanzheng@21cn.com, linux-kernel@vger.kernel.org
Subject: Re: + fix-vm_can_nonlinear-check-in-sys_remap_file_pages.patch
 added to -mm tree
Message-Id: <20071022151730.c0e1bd07.akpm@linux-foundation.org>
In-Reply-To: <20071008184044.GA1875@martell.zuzino.mipt.ru>
References: <200710081705.l98H5eoj009691@imap1.linux-foundation.org>
	<20071008184044.GA1875@martell.zuzino.mipt.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Oct 2007 22:40:44 +0400
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Mon, Oct 08, 2007 at 10:05:40AM -0700, akpm@linux-foundation.org wrote:
> > --- a/mm/fremap.c~fix-vm_can_nonlinear-check-in-sys_remap_file_pages
> > +++ a/mm/fremap.c
> > @@ -160,7 +160,7 @@ asmlinkage long sys_remap_file_pages(uns
> >  	if (vma->vm_private_data && !(vma->vm_flags & VM_NONLINEAR))
> >  		goto out;
> >  
> > -	if (!vma->vm_flags & VM_CAN_NONLINEAR)
> > +	if (!(vma->vm_flags & VM_CAN_NONLINEAR))
> 
> Ick.
> 
> [PATCH] typo time?

I appreciate the patch, but that changelog is just stupid.  Effectively
what it says is "Andrew, you get to type one up".  I'd prefer not to,
please.

> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  drivers/block/paride/pt.c                    |    2 -
>  drivers/block/pktcdvd.c                      |    4 +--
>  drivers/isdn/act2000/module.c                |   22 ++++++++---------
>  drivers/isdn/i4l/isdn_ttyfax.c               |    2 -
>  drivers/isdn/icn/icn.c                       |   22 ++++++++---------
>  drivers/isdn/isdnloop/isdnloop.c             |   16 ++++++------
>  drivers/media/video/pvrusb2/pvrusb2-ctrl.c   |    2 -
>  drivers/net/wireless/airo.c                  |    2 -
>  drivers/net/wireless/atmel.c                 |    2 -
>  drivers/net/wireless/prism54/isl_ioctl.c     |    4 +--
>  drivers/net/wireless/zd1211rw/zd_rf_uw2453.c |    2 -
>  drivers/video/i810/i810_main.c               |    2 -
>  drivers/video/sis/sis_main.c                 |    2 -
>  fs/ocfs2/alloc.c                             |    2 -
>  net/ieee80211/ieee80211_wx.c                 |    2 -
>  15 files changed, 44 insertions(+), 44 deletions(-)

seven different maintainers need to review and ack this.  Sigh.
