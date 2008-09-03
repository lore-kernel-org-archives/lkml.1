Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbYICSne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbYICSne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 14:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbYICSnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 14:43:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49575 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbYICSnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 14:43:23 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
       andmike@linux.vnet.ibm.com, mike.miller@hp.com, genanr@emsphone.com
Subject: Re: [PATCH 5/6] Added flush_disk to factor out common buffer cache flushing code.
References: <20080829231254.25065.66052.stgit@bluto.andrew>
	<20080829231320.25065.44013.stgit@bluto.andrew>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 03 Sep 2008 14:19:43 -0400
In-Reply-To: <20080829231320.25065.44013.stgit@bluto.andrew> (Andrew
	Patterson's message of "Fri, 29 Aug 2008 17:13:20 -0600")
Message-ID: <x4963pd9jnk.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Patterson <andrew.patterson@hp.com> writes:

> Added flush_disk to factor out common buffer cache flushing code.
>
> We need to be able to flush the buffer cache for for more than
> just when a disk is changed, so we factor out common cache flush code
> in check_disk_change() to an internal flush_disk() routine.  This
> routine will then be used for both disk changes and disk resizes (in a
> later patch).
>
> Include the disk name in the text indicating that there are busy
> inodes on the device and increase the KERN severity of the message.
>
> Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

> +static void flush_disk(struct block_device *bdev)
> +{
> +	if (__invalidate_device(bdev)) {
> +		char name[BDEVNAME_SIZE] = "";
> +
> +		if (bdev->bd_disk)
> +			disk_name(bdev->bd_disk, 0, name);
> +		printk(KERN_WARNING "VFS: busy inodes on changed media %s\n",
> +		       name);
> +	}

This message will scare folks growing their devices online.  Can you
think of some better verbiage for this?
