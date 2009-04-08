Return-Path: <linux-kernel-owner+w=401wt.eu-S1765780AbZDHSdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765780AbZDHSdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 14:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764952AbZDHSdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 14:33:01 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:51350 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765440AbZDHSc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 14:32:59 -0400
Date: Wed, 8 Apr 2009 12:32:43 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata: Prepare for hard drives w/ non-512 sector sizes
Message-ID: <20090408183243.GK20983@parisc-linux.org>
References: <20090408065955.GA29845@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408065955.GA29845@havoc.gtf.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 02:59:55AM -0400, Jeff Garzik wrote:
> I checked this into libata-dev.git#sectsize and #NEXT...  comments
> welcome.  It's willy's patch, cut down such that it introduces no
> major behavior changes [READ CAPACITY improves slightly].

Umm.  If you wanted me to split the patch up, why didn't you ask?

I really do think I should be credited as 'Author' here.  You credit me
in the patch description, but the automated tools don't show that.

> @@ -2354,10 +2355,25 @@ saving_not_supp:
>   */
>  static unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf)
>  {
> -	u64 last_lba = args->dev->n_sectors - 1; /* LBA of the last block */
> +	struct ata_device *dev = args->dev;
> +	u64 last_lba = dev->n_sectors - 1; /* LBA of the last block */
> +	u32 sector_size;
> +	u8 log_per_phys = 1;

This was a bug I had fixed, but possibly not sent out.  It should be 0,
not 1 (it's the power of 2, not the raw count).

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
