Return-Path: <linux-kernel-owner+w=401wt.eu-S1760710AbXHTTA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760710AbXHTTA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 15:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbXHTTAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 15:00:51 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:44831 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753491AbXHTTAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 15:00:49 -0400
Date: Mon, 20 Aug 2007 12:00:49 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pavel Machek <pavel@ucw.cz>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dkegel@google.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>, Nick Piggin <npiggin@suse.de>
Subject: Re: [RFC 2/9] Use NOMEMALLOC reclaim to allow reclaim if PF_MEMALLOC
 is set
In-Reply-To: <20070818071035.GA4667@ucw.cz>
Message-ID: <Pine.LNX.4.64.0708201158270.28863@schroedinger.engr.sgi.com>
References: <20070814153021.446917377@sgi.com> <20070814153501.305923060@sgi.com>
 <20070818071035.GA4667@ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Aug 2007, Pavel Machek wrote:

> > The reclaim is of particular important to stacked filesystems that may
> > do a lot of allocations in the write path. Reclaim will be working
> > as long as there are clean file backed pages to reclaim.
> 
> I don't get it. Lets say that we have stacked filesystem that needs
> it. That filesystem is broken today.
> 
> Now you give it second chance by reclaiming clean pages, but there are
> no guarantees that we have any.... so that filesystem is still broken
> with your patch...?

There is a guarantee that we have some because the user space program is 
executing. Meaning the executable pages can be retrieved. The amount 
dirty memory in the system is limited by the dirty_ratio. So the VM can 
only get into trouble if there is a sufficient amount of anonymous pages 
and all executables have been reclaimed. That is pretty rare.

Plus the same issue can happen today. Writes are usually not completed 
during reclaim. If the writes are sufficiently deferred then you have the 
same issue now.

