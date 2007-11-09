Return-Path: <linux-kernel-owner+w=401wt.eu-S1754906AbXKISCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbXKISCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 13:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbXKISCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 13:02:41 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:55204 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbXKISCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 13:02:40 -0500
Date: Fri, 9 Nov 2007 13:01:56 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Zach Brown <zach.brown@oracle.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Peter Zijlstra <peterz@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-aio@kvack.org
Subject: Re: dio_get_page() lockdep complaints
Message-ID: <20071109130156.4b05a652@think.oraclecorp.com>
In-Reply-To: <47349D66.2040109@oracle.com>
References: <20070419073828.GB20928@kernel.dk>
	<1194627742.6289.175.camel@twins>
	<4734992C.7000408@oracle.com>
	<1194630300.7459.65.camel@heimdal.trondhjem.org>
	<47349D66.2040109@oracle.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Nov 2007 09:48:22 -0800
Zach Brown <zach.brown@oracle.com> wrote:

> 
> >> So reiser and NFS need to be fixed.  No?
> > 
> > Actually, it is rather mmap() needs to be fixed.
> 
> Sure, I'm willing to have that demonstrated.  My point was that DIO
> getting the mmap_sem inside i_mutex is currently correct.
> 
> reiserfs, though, seems to be out on a more precarious limb ;).

reiserfs is doing tail packing during the file_release call, which has
lots of advantages for removing complexity in file_write.

Without getting into a huge patch, the best fix would just be switching
to try lock.  If the tail doesn't get packed, the world doesn't end.

-chris
