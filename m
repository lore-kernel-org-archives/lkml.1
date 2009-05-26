Return-Path: <linux-kernel-owner+w=401wt.eu-S1753674AbZEZEiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbZEZEiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 00:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbZEZEhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 00:37:53 -0400
Received: from sh.osrg.net ([192.16.179.4]:55929 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327AbZEZEhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 00:37:51 -0400
Date: Tue, 26 May 2009 13:36:42 +0900
To: rdreier@cisco.com
Cc: bharrosh@panasas.com, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com
Subject: Re: [PATCH 03/13] scsi: unify allocation of scsi command and sense
 buffer
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <aday6sk8wne.fsf@cisco.com>
References: <1243236668-3398-6-git-send-email-jens.axboe@oracle.com>
	<4A1A64A1.2050409@panasas.com>
	<aday6sk8wne.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090526132914W.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 26 May 2009 13:36:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 May 2009 18:45:25 -0700
Roland Dreier <rdreier@cisco.com> wrote:

>  > Ideally there should be a MACRO that is defined to WORD_SIZE on cache-coherent
>  > ARCHs and to SMP_CACHE_BYTES on none-cache-coherent systems and use that size
>  > at the __align() attribute. (So only stupid ARCHES get hurt)
> 
> this seems to come up repeatedly -- I had a proposal a _long_ time ago
> that never quite got merged, cf http://lwn.net/Articles/2265/ and
> http://lwn.net/Articles/2269/ -- from 2002 (!?).  The idea is to go a

Yeah, I think that Benjamin did last time:

http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg12632.html

IIRC, James didn't like it so I wrote the current code. I didn't see
any big performance difference with scsi_debug:

http://marc.info/?l=linux-scsi&m=120038907123706&w=2

Jens, you see the performance difference due to this unification?


Personally, I don't fancy __cached_alignment__ annotation much. I
prefer to leave it behind a memory allocator.


> step further and create a __dma_buffer annotation for structure members.


