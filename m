Return-Path: <linux-kernel-owner+w=401wt.eu-S1161443AbXBGWCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161443AbXBGWCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 17:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161453AbXBGWCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 17:02:23 -0500
Received: from hancock.steeleye.com ([71.30.118.248]:58020 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161443AbXBGWCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 17:02:22 -0500
Subject: Re: [PATCH 4/5] scsi: megaraid_sas - preallocate memory for ioctl
	processing
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sumant Patro <sumantp@lsil.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, neela.kolli@lsi.com, bo.yang@lsi.com,
       sumant.patro@lsi.com
In-Reply-To: <20070207133020.4c58e271.akpm@linux-foundation.org>
References: <1170800394.10482.41.camel@dumbo>
	 <20070207133020.4c58e271.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 07 Feb 2007 17:02:13 -0500
Message-Id: <1170885734.3852.30.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-07 at 13:30 -0800, Andrew Morton wrote:
> I suspect all this horror is due to stupidity in the DMA API.
> 
> pci_alloc_consistent() just goes and assumes GFP_ATOMIC, whereas
> the caller (megasas_mgmt_fw_ioctl) would have been perfectly happy
> to use GFP_KERNEL.
> 
> I bet this fixes it

It does, but the DMA API was expanded to cope with this exact case, so
use dma_alloc_coherent() directly in the megaraid code instead.  The dev
is just &pci_dev->dev.

James


