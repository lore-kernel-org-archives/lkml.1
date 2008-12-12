Return-Path: <linux-kernel-owner+w=401wt.eu-S1757287AbYLLLW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbYLLLW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 06:22:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbYLLLWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 06:22:46 -0500
Received: from mailhost.ics.forth.gr ([139.91.157.55]:36645 "EHLO
	mailhost.ics.forth.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbYLLLWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 06:22:45 -0500
X-Greylist: delayed 6395 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Dec 2008 06:22:45 EST
X-DKIM: Sendmail DKIM Filter v2.3.2 mailhost.ics.forth.gr mBC9a7jQ000977
X-AuditID: 8b5b9d37-a35c3bb000001a42-e7-494230878aee 
Message-ID: <4942314E.80408@ics.forth.gr>
Date: Fri, 12 Dec 2008 11:39:26 +0200
From: Thanos Makatos <mcatos@ics.forth.gr>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Inexplicable I/O latency using worker threads
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all.

I am facing a weird problem with a virtual block driver I made concerning excessive I/O latency.

My block driver intercepts requests and redirects them to a real block device,
but not just be setting the bio->bi_bdev field, I create new bios.

Anyway, my problem is that for load balancing reasons I need per-CPU worker threads
where I enqueue requests and let them do all the work. If I use 2 threads in a round
robin manner (request 1 served by CPU 0, 2 by CPU1, 3 by CPU0 and so on), performance
is inexplicably low.

If I choose only one CPU to act as a worker the problem is gone. The difference of measured
I/O latency is more than 30 times.

What could be happening?

I'm using a vanilla 2.6.18.8.

Thanx in advance.
