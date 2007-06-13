Return-Path: <linux-kernel-owner+w=401wt.eu-S1759105AbXFMQuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759105AbXFMQuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 12:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759043AbXFMQtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 12:49:49 -0400
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:44062 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758867AbXFMQts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 12:49:48 -0400
Message-ID: <46702020.7090802@kernel.org>
Date: Wed, 13 Jun 2007 09:49:36 -0700
From: Josh Triplett <josh@kernel.org>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Force rcutorture tasks to spread over CPUs
References: <20070613042804.GA6132@linux.vnet.ibm.com>
In-Reply-To: <20070613042804.GA6132@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> Of late, the scheduler seems to have decided to make things too easy for
> RCU -- on some configurations, all of the rcutorture tasks end up on the
> same CPU, which doesn't do a very good job of torturing RCU.  This patch
> helps the scheduler spread these tasks out by forcing a 20-millisecond
> burst of CPU-bound execution on each of rcutorture's tasks, which seems
> to work reasonably well in practice.

Given the scheduler behavior you observed, this seems reasonable to me, and it
seems reasonable to do this balancing by default.  You might consider adding a
module param to set the timeout, and disable the barrier code entirely when 0,
so people can still test the previous behavior.

Independently from this change, you might also consider adding a way to set
CPU affinity for rcutorture threads.  This would allow explicitly spreading
readers and writers across all CPUs, and possibly also allow clumping these
threads together on CPUs in bug-revealing ways.

> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Acked-by: Josh Triplett <josh@kernel.org>

- Josh Triplett
