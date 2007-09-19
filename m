Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbXISU7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbXISU7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 16:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbXISU7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 16:59:34 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52348 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751832AbXISU7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 16:59:33 -0400
Date: Wed, 19 Sep 2007 13:59:32 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Alexey Dobriyan <adobriyan@sw.ru>
cc: Andrew Morton <akpm@linux-foundation.org>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1: BUG kmalloc-16: Object padding overwritten
 (sysfs?)
In-Reply-To: <20070919123954.fb552e80.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0709191355340.3136@schroedinger.engr.sgi.com>
References: <20070919123907.GA15591@localhost.sw.ru> <20070919125918.GA6760@localhost.sw.ru>
 <20070919123954.fb552e80.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007, Andrew Morton wrote:

> > 	find /sys/slab | xargs cat

Hmmm... This works fine here. Doing the cat may trigger slab validation 
and show objects corruptions that were heretofore unnoticed.

Could you see if running

slabinfo -v

gives the same results?

> So do you beleive the bug lies in the /sys/slab implementation?

I would think that this is evidence of memory corruption occurring. The 
issues were detected while SLUB attempted to flush per cpu queues.
