Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbZIHNqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbZIHNqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 09:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753845AbZIHNqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 09:46:38 -0400
Received: from fifo99.com ([67.223.236.141]:45651 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800AbZIHNqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 09:46:37 -0400
Subject: Re: [PATCH 3/8] writeback: switch to per-bdi threads for flushing
 data
From: Daniel Walker <dwalker@fifo99.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz
In-Reply-To: <1252401791-22463-4-git-send-email-jens.axboe@oracle.com>
References: <1252401791-22463-1-git-send-email-jens.axboe@oracle.com>
	 <1252401791-22463-4-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain
Date: Tue, 08 Sep 2009 06:46:46 -0700
Message-Id: <1252417606.14793.3.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 11:23 +0200, Jens Axboe wrote:
> This gets rid of pdflush for bdi writeout and kupdated style cleaning.
> pdflush writeout suffers from lack of locality and also requires more
> threads to handle the same workload, since it has to work in a
> non-blocking fashion against each queue. This also introduces lumpy
> behaviour and potential request starvation, since pdflush can be starved
> for queue access if others are accessing it. A sample ffsb workload that
> does random writes to files is about 8% faster here on a simple SATA drive
> during the benchmark phase. File layout also seems a LOT more smooth in
> vmstat:


This patch has a checkpatch error, and couple of warnings.. Here's one
of the warnings which I though was concerning..

WARNING: trailing semicolon indicates no statements, indent implies
otherwise
#388: FILE: fs/fs-writeback.c:177:
+               } else if (wb->task);
+                       wake_up_process(wb->task);

I suppose that could be a defect .. btw, patch 7 of 8 also has a few
trivial warnings.

Daniel

