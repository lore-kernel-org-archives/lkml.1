Return-Path: <linux-kernel-owner+w=401wt.eu-S1758856AbXELO4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbXELO4Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 10:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbXELO4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 10:56:18 -0400
Received: from gw.goop.org ([64.81.55.164]:53765 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbXELO4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 10:56:18 -0400
Message-ID: <4645D594.4070801@goop.org>
Date: Sat, 12 May 2007 07:56:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>, xfs@oss.sgi.com
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an
 nlink problem?
References: <4642389E.4080804@goop.org> <20070509231643.GM85884050@sgi.com> <4642598E.3000607@goop.org> <20070510000119.GO85884050@sgi.com> <46426194.3040403@goop.org> <46439185.5060207@redhat.com> <464392B4.3070009@goop.org> <464393E1.3050705@redhat.com> <46439491.9010604@goop.org> <Pine.LNX.4.61.0705121323030.9570@yvahk01.tjqt.qr> <20070512135143.GG85884050@sgi.com>
In-Reply-To: <20070512135143.GG85884050@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> What I don't understand is that on unmount dirty xfs inodes get
> written out. Clearly this is not happening - either there's a hole
> in the writeback logic (unlikely - it was unchanged) or we've missed
> some case where we need to update the filesize and mark the inode
> dirty.
>
> Hmmmm - if the write was just a short append to the file, then the
> block that was written to should already be mapped. Then we'll just
> look up the extent by doing a BMAPI_READ lookup, set the type to
> IOMAP_READ and add the block to ioend we are building.
>   

Well, that result I mailed you showed that the difference was just over
16k, and that there was a 32 block difference in the final extent
length.  Does that fit with this theory?

> The type IOMAP_READ determines the I/O completion behaviour - in this case
> it is xfs_end_bio_read(), which fails to update the file size....
>
> Bingo.
>
> A patch for you to try, Jeremy. I've just started a test run on it...
>   

Thanks, I'll give it a spin.  Have you reproduced the bug yourself?


    J
