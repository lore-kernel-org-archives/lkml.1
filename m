Return-Path: <linux-kernel-owner+w=401wt.eu-S1422788AbXBGVT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422788AbXBGVT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 16:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422789AbXBGVT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 16:19:59 -0500
Received: from smtp.osdl.org ([65.172.181.24]:37363 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422787AbXBGVT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 16:19:56 -0500
Date: Wed, 7 Feb 2007 13:19:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sumant Patro <sumantp@lsil.com>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, neela.kolli@lsi.com, bo.yang@lsi.com,
       sumant.patro@lsi.com
Subject: Re: [PATCH 2/5] scsi: megaraid_sas - added bios_param in
 scsi_host_template
Message-Id: <20070207131952.681c6775.akpm@linux-foundation.org>
In-Reply-To: <1170799043.10482.20.camel@dumbo>
References: <1170799043.10482.20.camel@dumbo>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Feb 2007 13:57:23 -0800
Sumant Patro <sumantp@lsil.com> wrote:

> +static int
> +megasas_bios_param(struct scsi_device *sdev, struct block_device *bdev,
> +		 sector_t capacity, int geom[])
> +{
> +	int 		heads;
> +	int 		sectors;
> +	sector_t	cylinders;
> +	ulong		dummy;

Plain old `unsigned long' is preferred.

> +	/* Default heads (64) & sectors (32) */
> +	heads 		= 64;
> +	sectors 	= 32;
> +
> +	dummy		= heads * sectors;
> +	cylinders	=  capacity;
> +
> +	sector_div(cylinders, dummy);
> +
> +	/*
> +	 * Handle extended translation size for logical drives > 1Gb
> +	 */
> +	
> +	if ((ulong)capacity >= 0x200000) {

Here we're casting a sector_t down to a 32-bit number.  Are you sure that
`capacity' here can never exceed 0xffffffff?

