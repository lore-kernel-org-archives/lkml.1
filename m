Return-Path: <linux-kernel-owner+w=401wt.eu-S1757015AbZALUCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015AbZALUCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 15:02:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755646AbZALUCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 15:02:13 -0500
Received: from ext-cn0ut-4.online-age.net ([63.210.253.233]:12389 "EHLO
	ext-cn0ut-4.online-age.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754101AbZALUCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 15:02:12 -0500
Date: Mon, 12 Jan 2009 21:01:56 +0100
From: Enrik Berkhan <Enrik.Berkhan@ge.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, David Vrabel <david.vrabel@csr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Reference counting of MMC host driver modules
Message-ID: <20090112200156.GA22537@ngeserver2.localdomain>
References: <49678443.8040909@ge.com> <49679570.3070403@csr.com> <20090109200024.GA14754@ngeserver2.localdomain> <49686F0C.7030807@s5r6.in-berlin.de> <20090111104111.5a0f00e1@mjolnir.drzeus.cx> <20090112154150.GA27289@ngeserver2.localdomain> <496B7969.5050706@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496B7969.5050706@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 12 Jan 2009 20:02:04.0820 (UTC) FILETIME=[A3F0A540:01C974F0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Enrik Berkhan wrote:
> > When removing the mmc_host_driver, everything seems to be fine; the
> > MMC/SD block device has been deactivated by mmc_blk_remove(), that in
> > turn has stopped the queue via mmc_cleanup_queue(). mmc_cleanup_queue()
> > calls blk_cleanup_queue() on the underlying struct request_queue. By
> > this, the reference count of the struct request_queues kboj drops to
> > zero. The MD driver still has the block device open and, actually,
> > things work fine unless the memory of the struct request_queue isn't
> > touched, because it is marked dead. Of course, accessing the MD device
> > returns EIO, but that's fine.
> > 
> > When the mmc_host_driver is reloaded, new struct request_queues will be
> > allocated and with some probability, the old memory will be re-used for
> > them or the old memory locations will be re-used for something else. The
> > key point is that the queues still in use by the MD layer will
> > effectively no longer be marked dead or completely corrupted.
> 
> So in short, the request_queue's reference count goes to zero even
> though something still points to it?

Exactly. AFAICS.

I haven't checked yet if this happens using other block device
infrastructure, too.

Enrik
