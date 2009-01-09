Return-Path: <linux-kernel-owner+w=401wt.eu-S1757781AbZAIVfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781AbZAIVfO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:35:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757282AbZAIVex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:34:53 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34231 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506AbZAIVew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:34:52 -0500
Subject: Re: Increase dirty_ratio and dirty_background_ratio?
From: Peter Zijlstra <peterz@infradead.org>
To: david@lang.hm
Cc: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, npiggin@suse.de
In-Reply-To: <alpine.DEB.1.10.0901091420190.3525@asgard.lang.hm>
References: <alpine.LFD.2.00.0901070833430.3057@localhost.localdomain>
	 <20090107.125133.214628094.davem@davemloft.net>
	 <20090108030245.e7c8ceaf.akpm@linux-foundation.org>
	 <20090108.082413.156881254.davem@davemloft.net>
	 <alpine.LFD.2.00.0901080842180.3283@localhost.localdomain>
	 <1231433701.14304.24.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0901080858500.3283@localhost.localdomain>
	 <20090108195728.GC14560@duck.suse.cz> <20090109180241.GA15023@duck.suse.cz>
	 <alpine.DEB.1.10.0901091420190.3525@asgard.lang.hm>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 09 Jan 2009 22:34:31 +0100
Message-Id: <1231536871.29452.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-09 at 14:31 -0800, david@lang.hm wrote:

> for that matter, it's not getting to where it makes sense to have wildly 
> different storage on a machine
> 
> 10's of GB of SSD for super-fast read-mostly
> 100's of GB of high-speed SCSI for fast writes
> TB's of SATA for high capacity
> 
> does it make sense to consider tracking the dirty pages per-destination so 
> that in addition to only having one process writing to the drive at a time 
> you can also allow for different amounts of data to be queued per device?
> 
> on a machine with 10's of GB of ram it becomes possible to hit the point 
> where at one point you could have the entire SSD worth of data queued up 
> to write, and at another point have the same total amount of data queued 
> for the SATA storage and it's a fraction of a percent of the size of the 
> storage.

That's exactly what we do today. Dirty pages are tracked per backing
device and the writeback cache size is proportionally divided based on
recent write speed ratios of the devices.
