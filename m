Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbZHCP7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbZHCP7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 11:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbZHCP7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 11:59:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39258 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083AbZHCP7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 11:59:49 -0400
Subject: Re: scheduling co-processors
From: Peter Zijlstra <peterz@infradead.org>
To: Sherif Fadel <fahmy@vt.edu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1249312084.5762.17.camel@sherif-laptop>
References: <1249312084.5762.17.camel@sherif-laptop>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 03 Aug 2009 17:59:42 +0200
Message-Id: <1249315182.7924.142.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-03 at 18:08 +0300, Sherif Fadel wrote:
> Hi,
> 
> I have a dual-core system on which I would like to treat one processor
> as a scheduling co-processor. I have already implemented some custom
> scheduling policies and tested them with SMP disabled, I would not like
> to see if it is possible to have the scheduling algorithm running on one
> core and the scheduled tasks running on another.
> 
> I do not know if I can somehow use cpus_allowed to restrict the kernel
> to one core and the running tasks to another. Is this possible? 

You'd have to hot-unplug the cpus to stop them from being used.

> If so,
> could you please inform me how one would go about this?

Write code ;-), mind you that running stuff on a cpu without the
scheduler present won't allow you to run regular linux stuff.

> In case you are wondering why I would need this, I am writing a bunch of
> high-overhead distributed scheduling algorithms and I want to mitigate
> their overhead in this way.

Seems unlikely to work imho, most of the overhead is remote accesses and
by moving everything to one cpu you'll incur those costs all the time.
