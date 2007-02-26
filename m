Return-Path: <linux-kernel-owner+w=401wt.eu-S1030310AbXBZQI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030310AbXBZQI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 11:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030299AbXBZQI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 11:08:59 -0500
Received: from mx1.suse.de ([195.135.220.2]:60210 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030308AbXBZQI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 11:08:57 -0500
Date: Mon, 26 Feb 2007 17:08:56 +0100
From: Bernhard Walle <bwalle@suse.de>
To: linux-kernel@vger.kernel.org
Subject: GFP_DMA in sd_revalidate_disk
Message-ID: <20070226160856.GA19701@strauss.suse.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

[since I got no reply in linux-scsi, I'll try here]

Is GFP_DMA really needed in sd_revalidate_disk() in every circumstances?
That's the code:

    buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL | __GFP_DMA);
    if (!buffer) {
        printk(KERN_WARNING "(sd_revalidate_disk:) Memory allocation "
               "failure.\n");
        goto out;
    }

Or should could the check (sdp->host->unchecked_isa_dma ? __GFP_DMA : 0)
applied here, too?

Thanks!


Regards,
Bernhard
