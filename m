Return-Path: <linux-kernel-owner+w=401wt.eu-S1753183AbZBBLjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbZBBLjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 06:39:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbZBBLjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 06:39:37 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:57334 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbZBBLjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 06:39:36 -0500
Message-ID: <4986DB72.4070809@s5r6.in-berlin.de>
Date: Mon, 02 Feb 2009 12:39:30 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC][PATCH] create workqueue threads only when needed
References: <20090127001708.GA4815@nowhere> <4986B205.2040807@s5r6.in-berlin.de> <1233565528.18767.80.camel@pasglop> <200902021014.10203.oliver@neukum.org>
In-Reply-To: <200902021014.10203.oliver@neukum.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> Am Monday 02 February 2009 10:05:28 schrieb Benjamin Herrenschmidt:
[I wrote]
>> > Work which /may/ sleep longer, for example performs SCSI transactions,
>> > needs to go into a private workqueue or other kind of context.
>> 
>> Well, it's a bit silly to allocate a private workqueue with all it's
>> associated per CPU kernel threads for something as rare as resetting
>> your eth NIC ... or even SCSI error handling in fact.
> 
> How do you avoid a deadlock if SCSI error handling doesn't use
> a dedicated workqueue?

SCSI error handling happens in dedicated per-Scsi_Host threads.  These
look like candidates for some kind of thread pool implementation too
though (like Arjan's kernel/async.c), especially since a Scsi_Host
instance is sometimes actually a per-target instance.

But I thought primarily about scsi_add_device and scsi_remove_device and
friends.  Incidentally, device probing is exactly what Arjan's fastboot
facility is targeting.  (Sometimes device shutdown is slow too and wants
to be parallelized versus other bus event handling then.)
-- 
Stefan Richter
-=====-==--= --=- ---=-
http://arcgraph.de/sr/
