Return-Path: <linux-kernel-owner+w=401wt.eu-S1757415AbZEEJ5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbZEEJ5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 05:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbZEEJ5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 05:57:40 -0400
Received: from smtp.nokia.com ([192.100.122.233]:45603 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503AbZEEJ5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 05:57:39 -0400
Date: Tue, 5 May 2009 12:57:21 +0300
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>
To: "ext Gadiyar, Anand" <gadiyar@ti.com>
Cc: "pierre@ossman.eu" <pierre@ossman.eu>, Tony Lindgren <tony@atomide.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] OMAP: HSMMC: Do not enable buffer ready interrupt if
	using DMA
Message-ID: <20090505095721.GA12287@angel.research.nokia.com>
Reply-To: Jarkko Lavinen <jarkko.lavinen@nokia.com>
References: <5A47E75E594F054BAF48C5E4FC4B92AB02FB2F2A90@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB02FB2F2A90@dbde02.ent.ti.com>
X-Operating-System: GNU/Linux angel.research.nokia.com
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 05 May 2009 09:57:23.0308 (UTC) FILETIME=[E32702C0:01C9CD67]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 09:39:22AM +0200, ext Gadiyar, Anand wrote:
> From: Anand Gadiyar <gadiyar@ti.com>
> 
> OMAP: HSMMC: Do not enable buffer ready interrupt if using DMA
> 
> This considerably reduces the number of interrupts during a transfer
> and ought to result in some power saving.

I tried the patch with reading from the raw mmc block device to
/dev/null with dd (with bs 32k and 1M).  I cannot see any
difference in interrupt count from /proc/interrupts or in read
speed. At least the patch works. Cpu was 34340es3.

I also trid without the patch just disabling the Buffer
Read/write Ready bits from INT_EN_MASK which is then written to
both MMCHS_IE and MMCHS_ISE.  Still no change in read speed nor
mmc irq count.

Cheers
Jarkko Lavinen
