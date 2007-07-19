Return-Path: <linux-kernel-owner+w=401wt.eu-S965581AbXGSTDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965581AbXGSTDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 15:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933714AbXGSTDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 15:03:33 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50053 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932956AbXGSTDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 15:03:33 -0400
Message-ID: <469FB583.7070502@cs.helsinki.fi>
Date: Thu, 19 Jul 2007 22:03:31 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 1.5.0.12 (Macintosh/20070509)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Roland Dreier <rdreier@cisco.com>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Subject: Re: kmalloc zero size changes break i386
References: <200707191201.35777.ak@suse.de> <84144f020707190708p1c4d63cnbb0397a602c3527d@mail.gmail.com> <adamyxsfmnc.fsf@cisco.com> <alpine.LFD.0.999.0707191107570.27353@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707191107570.27353@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Ok, I think I see it: I think the mm/slab.c conversion of kmalloc(0) is
> totally broken.
> 
> The problem? It returns ZERO_SIZE_PTR from __find_general_cachep(), not 
> from __kmalloc(). So anythign that uses __find_general_cachep() will get 
> an invalid cachep pointer, which was not the point.
 >
 > Does something like this fix it?

I wondered about that too but I didn't spot any callers that would 
actually break. Andi? Roland?

> Christoph, please go over this and see if there are other cases like that.

__do_kmalloc_node probably.


				Pekka
