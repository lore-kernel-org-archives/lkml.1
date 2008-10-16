Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbYJPXfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbYJPXfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 19:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbYJPXfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:35:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751029AbYJPXfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:35:42 -0400
Date: Thu, 16 Oct 2008 16:35:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dougthompson@xmission.com
Cc: benh@kernel.crashing.org, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 1/1] edac cell: fix incorrect edac_mode
Message-Id: <20081016163532.273ea02f.akpm@linux-foundation.org>
In-Reply-To: <48f78434.Hj5aU4wgiL/VVJvn%dougthompson@xmission.com>
References: <48f78434.Hj5aU4wgiL/VVJvn%dougthompson@xmission.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008 12:13:08 -0600
dougthompson@xmission.com wrote:

> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
> The cell_edac driver is setting the edac_mode field of the
> csrow's to an incorrect value, causing the sysfs show routine
> for that field to go out of an array bound and Oopsing the kernel
> when used.

Well that sounds a bit wrong of it.

> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Doug Thompson <dougthompson@xmission.com>
> ---
> 
>  drivers/edac/cell_edac.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-work.orig/drivers/edac/cell_edac.c	2008-10-15 15:35:21.000000000 +1100
> +++ linux-work/drivers/edac/cell_edac.c	2008-10-15 15:35:29.000000000 +1100
> @@ -142,7 +142,7 @@ static void __devinit cell_edac_init_csr
>  		csrow->nr_pages = (r.end - r.start + 1) >> PAGE_SHIFT;
>  		csrow->last_page = csrow->first_page + csrow->nr_pages - 1;
>  		csrow->mtype = MEM_XDR;
> -		csrow->edac_mode = EDAC_FLAG_EC | EDAC_FLAG_SECDED;
> +		csrow->edac_mode = EDAC_SECDED;
>  		dev_dbg(mci->dev,
>  			"Initialized on node %d, chanmask=0x%x,"
>  			" first_page=0x%lx, nr_pages=0x%x\n",

Seems to be needed in 2.6.27.x?  Applies OK to 2.6.26, 2.6.25, etc.

How far back shold we port this?

Thanks.
