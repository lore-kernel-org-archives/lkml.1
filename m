Return-Path: <linux-kernel-owner+w=401wt.eu-S1764807AbXLMSsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764807AbXLMSsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 13:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759420AbXLMSsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 13:48:21 -0500
Received: from rtr.ca ([76.10.145.34]:2186 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758559AbXLMSsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 13:48:19 -0500
Message-ID: <47617E72.6080504@rtr.ca>
Date: Thu, 13 Dec 2007 13:48:18 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: QUEUE_FLAG_CLUSTER: not working in 2.6.24 ?
References: <47617B92.6020908@rtr.ca> <47617C07.3020501@rtr.ca>
In-Reply-To: <47617C07.3020501@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> (resending with corrected email address for Jens)
> 
> Jens,
> 
> I'm experimenting here with trying to generate large I/O through libata,
> and not having much luck.
> 
> The limit seems to be the number of hardware PRD (SG) entries permitted
> by the driver (libata:ata_piix), which is 128 by default.
> 
> The problem is, the block layer *never* sends an SG entry larger than 
> 8192 bytes,
> and even that size is exceptionally rare.  Nearly all I/O segments are 
> 4096 bytes,
> so I never see a single I/O larger than 512KB (128 * 4096).
> 
> If I patch various parts of block and SCSI, this limit doesn't budge,
> but when I change the hardware PRD limit in libata, it scales by exactly
> whatever I set the new value to.  This tells me that adjacent I/O segments
> are not being combined.
> 
> I thought that QUEUE_FLAG_CLUSTER (aka. SCSI host .use_clustering=1) should
> result in adjacent single pages being combined into larger physical 
> segments?
> 
> This is x86-32 with latest 2.6.24-rc*.
> I'll re-test on older kernels next.
...

Problem confirmed.  2.6.23.8 regularly generates segments up to 64KB for libata,
but 2.6.24 uses only 4KB segments and a *few* 8KB segments.

???
