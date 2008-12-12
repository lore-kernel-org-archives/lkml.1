Return-Path: <linux-kernel-owner+w=401wt.eu-S1759502AbYLLRsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502AbYLLRsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 12:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757246AbYLLRsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 12:48:15 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44602 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757133AbYLLRsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 12:48:14 -0500
Message-ID: <4942A38C.7050907@redhat.com>
Date: Fri, 12 Dec 2008 12:46:52 -0500
From: Chris Snook <csnook@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Thanos Makatos <mcatos@ics.forth.gr>
CC: linux-kernel@vger.kernel.org
Subject: Re: Inexplicable I/O latency using worker threads
References: <4942314E.80408@ics.forth.gr>
In-Reply-To: <4942314E.80408@ics.forth.gr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanos Makatos wrote:
> Hello all.
> 
> I am facing a weird problem with a virtual block driver I made concerning excessive I/O latency.
> 
> My block driver intercepts requests and redirects them to a real block device,
> but not just be setting the bio->bi_bdev field, I create new bios.
> 
> Anyway, my problem is that for load balancing reasons I need per-CPU worker threads
> where I enqueue requests and let them do all the work. If I use 2 threads in a round
> robin manner (request 1 served by CPU 0, 2 by CPU1, 3 by CPU0 and so on), performance
> is inexplicably low.
> 
> If I choose only one CPU to act as a worker the problem is gone. The difference of measured
> I/O latency is more than 30 times.
> 
> What could be happening?
> 
> I'm using a vanilla 2.6.18.8.
> 
> Thanx in advance.

a) I/O scheduling
b) lock contention

Do you really need to load balance I/O to a single bdev across multiple CPUs? 
Disk I/O generally isn't very CPU-intensive.

-- Chris
