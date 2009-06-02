Return-Path: <linux-kernel-owner+w=401wt.eu-S1755785AbZFBPFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbZFBPFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 11:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbZFBPFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 11:05:42 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:40486 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755231AbZFBPFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 11:05:41 -0400
Date: Tue, 2 Jun 2009 11:05:09 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Larry H." <research@subreption.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] Use kzfree in tty buffer management to enforce data 
 sanitization
In-Reply-To: <alpine.LFD.2.01.0905311002010.3435@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0906021103490.23962@gentwo.org>
References: <20090531015537.GA8941@oblivion.subreption.com> <alpine.LFD.2.01.0905301902530.3435@localhost.localdomain> <84144f020905302324r5e342f2dlfd711241ecfc8374@mail.gmail.com> <20090531112630.2c7f4f1d@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0905311002010.3435@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 May 2009, Linus Torvalds wrote:

> I suspect the "use page allocator" is historical - ie the tty layer
> originally always did that, and then when people wanted to suppotr smaller
> areas than one page, they added the special case. I have this dim memory
> of the _original_ kmalloc not handling page-sized allocations well (due to
> embedded size/pointer overheads), but I think all current allocators are
> perfectly happy to allocate PAGE_SIZE buffers without slop.
>
> If I'm right, then we could just use kmalloc/kfree unconditionally. Pekka?

Yes. They do that in various ways. SLOB/SLUB will fall back to the
page allocator for large allocation sizes.

