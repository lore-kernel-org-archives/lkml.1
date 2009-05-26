Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbZEZFYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbZEZFYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 01:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbZEZFYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 01:24:13 -0400
Received: from sh.osrg.net ([192.16.179.4]:37800 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbZEZFYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 01:24:13 -0400
Date: Tue, 26 May 2009 14:23:38 +0900
To: bharrosh@panasas.com
Cc: jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com
Subject: Re: [PATCH 03/13] scsi: unify allocation of scsi command and sense
 buffer
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4A1A64A1.2050409@panasas.com>
References: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
	<1243236668-3398-6-git-send-email-jens.axboe@oracle.com>
	<4A1A64A1.2050409@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090526142346O.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 26 May 2009 14:23:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 May 2009 12:28:01 +0300
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On 05/25/2009 10:30 AM, Jens Axboe wrote:
> > Fold the sense buffer into the command, thereby eliminating a slab
> > allocation and free per command.
> > 
> > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> 
> Jens Hi.
> 
> I'm "TO:" this to Tomo.
> 
> This is the way it used to be for a long time. It was only recently changed by
> Tomo because of a bug on none-cache-coherent arches that need to dma-access the
> sense_buffer and also on the other hand change scsi_cmnd members by CPU.
> 
> In my opinion all you need is an __aligned(SMP_CACHE_BYTES) declaration at
> sense_buffer[] and let there be a hole at the end before the array. But Tomo
> did not like that, so he separated the two.

IIRC, it was not my opinion :) I don't think that putting
CACHE_ALIGNMENT here is a good idea though.

If this separated sense buffer allocation actually hurts the
performance, then I prefer the ->alloc_cmnd and ->destroy_cmnd hook
idea. Then most of llds are happy about the current sense buffer
scheme and some can use ->alloc_cmnd and ->destroy_cmnd hooks for the
better performance.
