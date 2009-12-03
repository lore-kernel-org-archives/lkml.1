Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbZLCSuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbZLCSuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 13:50:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756399AbZLCSuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 13:50:10 -0500
Received: from claw.goop.org ([74.207.240.146]:53862 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756339AbZLCSuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 13:50:09 -0500
Message-ID: <4B180867.3050706@goop.org>
Date: Thu, 03 Dec 2009 10:50:15 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: jayakumar.lkml@gmail.com, damm@opensource.se, linux-kernel@vger.kernel.org,
       armbru@redhat.com
Subject: Re: [PATCH 1/3] fb-defio: If FBINFO_VIRTFB is defined, do not set
 VM_IO flag.
References: <1259854318-16907-1-git-send-email-konrad.wilk@oracle.com> <1259854318-16907-2-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1259854318-16907-2-git-send-email-konrad.wilk@oracle.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/09 07:31, Konrad Rzeszutek Wilk wrote:
> Most users (except sh_mobile_lcdcfb.c) get their framebuffer from
> vmalloc. Setting VM_IO is not necessary as the memory obtained
> from vmalloc is System RAM type and is not susceptible to PCI memory
> constraints.
>   

Looks good, but you forgot signoffs on these.  Do you want me to add them?

Thanks,
    J
> ---
>  drivers/video/fb_defio.c |    4 +++-
>  include/linux/fb.h       |    1 +
>  2 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/video/fb_defio.c b/drivers/video/fb_defio.c
> index c27ab1e..94414fc 100644
> --- a/drivers/video/fb_defio.c
> +++ b/drivers/video/fb_defio.c
> @@ -144,7 +144,9 @@ static const struct address_space_operations fb_deferred_io_aops = {
>  static int fb_deferred_io_mmap(struct fb_info *info, struct vm_area_struct *vma)
>  {
>  	vma->vm_ops = &fb_deferred_io_vm_ops;
> -	vma->vm_flags |= ( VM_IO | VM_RESERVED | VM_DONTEXPAND );
> +	vma->vm_flags |= ( VM_RESERVED | VM_DONTEXPAND );
> +	if (!(info->flags & FBINFO_VIRTFB))
> +		vma->vm_flags |= VM_IO;
>  	vma->vm_private_data = info;
>  	return 0;
>  }
> diff --git a/include/linux/fb.h b/include/linux/fb.h
> index de9c722..369767b 100644
> --- a/include/linux/fb.h
> +++ b/include/linux/fb.h
> @@ -763,6 +763,7 @@ struct fb_tile_ops {
>  	 *  takes over; acceleration engine should be in a quiescent state */
>  
>  /* hints */
> +#define FBINFO_VIRTFB		0x0004 /* FB is System RAM, not device. */
>  #define FBINFO_PARTIAL_PAN_OK	0x0040 /* otw use pan only for double-buffering */
>  #define FBINFO_READS_FAST	0x0080 /* soft-copy faster than rendering */
>  
>   

