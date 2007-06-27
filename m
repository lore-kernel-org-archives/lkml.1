Return-Path: <linux-kernel-owner+w=401wt.eu-S1758867AbXF0PtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867AbXF0PtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 11:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754864AbXF0PtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 11:49:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52567 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752894AbXF0Ps7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 11:48:59 -0400
Date: Wed, 27 Jun 2007 08:48:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata fixes
In-Reply-To: <46821613.9010305@garzik.org>
Message-ID: <alpine.LFD.0.98.0706270844370.8675@woody.linux-foundation.org>
References: <20070627073526.GA18787@havoc.gtf.org>
 <20070627003841.68fd0ea9.akpm@linux-foundation.org>
 <46821613.9010305@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 Jun 2007, Jeff Garzik wrote:
> 
> Such would be a diagnostic that would trigger on valid SCSI commands, when the
> user is doing nothing wrong and the system can indeed complete the command
> just fine.  Additionally, this is moving us in the direction of what the IDE
> driver has apparently been doing.

Indeed. At least the IDE CD-ROM driver does

	if ((rq->data_len & 15) || (addr & mask))
		info->dma = 0;

where the "mask" is the dma_alignment mask. So it requires the length to 
be a multiple of 16, and also requires a certain alignment of the data 
(which defaults to 32 bytes for some reason I cannot for the life of me 
remember).

The generic BIO layer does that DMA alignment check too when mapping user 
pages.

		Linus
