Return-Path: <linux-kernel-owner+w=401wt.eu-S932233AbZHCUeD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233AbZHCUeD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 16:34:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932120AbZHCUeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 16:34:01 -0400
Received: from complete.lackof.org ([198.49.126.79]:58325 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119AbZHCUeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 16:34:00 -0400
Date: Mon, 3 Aug 2009 14:33:57 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Julia Lawall <julia@diku.dk>
Cc: kyle@mcmartin.ca, deller@gmx.de, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 5/12] drivers/parisc: Correct redundant test
Message-ID: <20090803203357.GA2386@lackof.org>
References: <Pine.LNX.4.64.0907271813310.2682@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907271813310.2682@ask.diku.dk>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 06:13:48PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> pa_pdc_cell has already been tested.  It seems that this test should be on the
> recently returned value io_pdc_cell.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @r exists@
> local idexpression x;
> expression E;
> @@
> 
> if (x == NULL || ...) { ... when forall
>    return ...; }
> ... when != \(x=E\|x--\|x++\|--x\|++x\|x-=E\|x+=E\|x|=E\|x&=E\|&x\)
> (
> *x == NULL
> |
> *x != NULL
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Good catch!

Reviewed-by: Grant Grundler <grundler@parisc-linux.org>

thanks,
grant

> ---
>  drivers/parisc/lba_pci.c            |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/parisc/lba_pci.c b/drivers/parisc/lba_pci.c
> index ede6146..3aeb327 100644
> --- a/drivers/parisc/lba_pci.c
> +++ b/drivers/parisc/lba_pci.c
> @@ -992,7 +992,7 @@ lba_pat_resources(struct parisc_device *pa_dev, struct lba_device *lba_dev)
>  		return;
>  
>  	io_pdc_cell = kzalloc(sizeof(pdc_pat_cell_mod_maddr_block_t), GFP_KERNEL);
> -	if (!pa_pdc_cell) {
> +	if (!io_pdc_cell) {
>  		kfree(pa_pdc_cell);
>  		return;
>  	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-parisc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
