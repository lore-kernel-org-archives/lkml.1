Return-Path: <linux-kernel-owner+w=401wt.eu-S1756472AbXD1RLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472AbXD1RLk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756464AbXD1RLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:11:40 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:56591 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467AbXD1RLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:11:39 -0400
Date: Sat, 28 Apr 2007 19:11:37 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS
 is under heavy write load (massive starvation)
In-Reply-To: <20070428163740.GA17061@elte.hu>
Message-ID: <Pine.LNX.4.64.0704281909320.14529@artax.karlin.mff.cuni.cz>
References: <1177660767.6567.41.camel@Homer.simpson.net>
 <alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org>
 <Pine.LNX.4.64.0704280824420.2502@artax.karlin.mff.cuni.cz>
 <alpine.LFD.0.98.0704280849150.9964@woody.linux-foundation.org>
 <20070428163740.GA17061@elte.hu>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So perhaps if there's any privileged reads going on then we should limit
> writes to a depth of 2 at most, with some timeout mechanism that would

SCSI has a "high priority" bit in the command block, so you can just set 
it --- but I am not sure how well do disks support it.

Mikulas

> gradually allow the deepening of the hardware queue, as long as no
> highprio reads come inbetween? With 2 pending requests and even assuming
> worst-case seeks the user-visible latency would be on the order of 20-30
> msecs, which is at the edge of human perception. The problem comes when
> a hardware queue of 32-64 entries starves that one highprio read which
> then results in a 2+ seconds latency.
>
> 	Ingo
>
