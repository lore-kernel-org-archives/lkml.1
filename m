Return-Path: <linux-kernel-owner+w=401wt.eu-S1771262AbYHDVoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1771262AbYHDVoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1770999AbYHDVmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:42:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42425 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1770993AbYHDVmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:42:45 -0400
Message-ID: <4897777C.1070801@linux-foundation.org>
Date: Mon, 04 Aug 2008 16:41:16 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Rene Herman <rene.herman@keyaccess.nl>, Matthew Wilcox <matthew@wil.cx>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>
Subject: Re: No, really, stop trying to delete slab until you've finished
 making slub perform as well
References: <20080801182324.572058187@lameter.com> <20080803015847.GD26461@parisc-linux.org> <4896225D.9090203@cs.helsinki.fi> <48966B6D.604@keyaccess.nl> <48977330.4090501@cs.helsinki.fi>
In-Reply-To: <48977330.4090501@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
>> General interested question -- I recently "accidentally" read some of
>> slub and I believe that it doesn't feature the cache colouring support
>> that slab did? Is that true, and if so, wasn't it needed/useful?
> 
> I don't know why Christoph decided not to implement it. Christoph?

IMHO cache coloring issues seem to be mostly taken care of by newer more
associative cpu caching designs.

Note that the SLAB design origin is Solaris (See the paper by Jeff Bonwick in
1994 that is quoted in mm/slab.c). Logic for cache coloring is mostly avoided
today due to the complexity it would introduce. See also
http://en.wikipedia.org/wiki/CPU_cache.

What one could add to support cache coloring in SLUB is a prearrangement of
the order of object allocation order by constructing the initial freelist for
a page in a certain way. See mm/slub.c::new_slab()
