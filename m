Return-Path: <linux-kernel-owner+w=401wt.eu-S1760041AbYGPQBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760041AbYGPQBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 12:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756927AbYGPQBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 12:01:04 -0400
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:39784 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759907AbYGPQBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 12:01:01 -0400
Subject: Re: [PATCH][RFC] slub: increasing order reduces memory usage
	of	some key caches
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: penberg@cs.helsinki.fi, mpm@selenic.com, linux-mm <linux-mm@kvack.org>,
       lkml <linux-kernel@vger.kernel.org>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <487DFFBE.5050407@linux-foundation.org>
References: <1216211371.3122.46.camel@castor.localdomain>
	 <487DF5D4.9070101@linux-foundation.org>
	 <1216216730.3122.60.camel@castor.localdomain>
	 <487DFFBE.5050407@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 15:30:57 +0100
Message-Id: <1216218657.3122.66.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-07-16 at 09:03 -0500, Christoph Lameter wrote:
> Richard Kennedy wrote:
> 
> > before
> > dentry             82136  82137    208   19    1 : tunables    0    0    0 : slabdata   4323   4323      0
> > after
> > dentry             79482  79482    208   39    2 : tunables    0    0    0 : slabdata   2038   2038      0
> 
> 19 objects with an order 1 alloc and 208 byte size? Urgh. 8192/208 = 39 and not 19.
> 
> Kmemcheck or something else active? We seem to be loosing 50% of our memory.
> 
> Pekka: Is the slabinfo emulation somehow broken?
> 
> I'd really like to see the output of slabinfo dentry.
> 
/proc/slabinfo says it shows pages/slab not order -- so the numbers are consistent if nothing else.

I'm getting the log message 
> SLUB: increasing order dentry->[1] [208]
from my code, so it looks correct. It's just the standard code is
picking order 0.

I'm just rebuilding the kernel & will get you that slabinfo

Richard 

