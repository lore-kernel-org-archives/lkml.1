Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab0CJXEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 18:04:54 -0500
Received: from gir.skynet.ie ([193.1.99.77]:59345 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757385Ab0CJXEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 18:04:53 -0500
Date: Wed, 10 Mar 2010 23:04:35 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: Initialised pci bus legacy_mem field before use
Message-ID: <20100310230435.GC14715@csn.ul.ie>
References: <20100310224834.GB14715@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100310224834.GB14715@csn.ul.ie>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 10:48:34PM +0000, Mel Gorman wrote:
> PPC64 is failing to boot the latest mmotm due to an uninitialised pointer in
> pci_create_legacy_files(). The surprise is that machines boot at all and it
> would appear to affect current mainline as well.  This patch fixes the problem.
> 

I forgot to point out that triggering this problem depends on
CONFIG_DEBUG_LOCK_ALLOC which is why it probably slipped through
testing.

> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  drivers/pci/pci-sysfs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index de29645..9976685 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -655,8 +655,8 @@ void pci_create_legacy_files(struct pci_bus *b)
>  		goto legacy_io_err;
>  
>  	/* Allocated above after the legacy_io struct */
> -	sysfs_bin_attr_init(b->legacy_mem);
>  	b->legacy_mem = b->legacy_io + 1;
> +	sysfs_bin_attr_init(b->legacy_mem);
>  	b->legacy_mem->attr.name = "legacy_mem";
>  	b->legacy_mem->size = 1024*1024;
>  	b->legacy_mem->attr.mode = S_IRUSR | S_IWUSR;

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
