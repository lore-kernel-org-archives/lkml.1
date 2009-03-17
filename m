Return-Path: <linux-kernel-owner+w=401wt.eu-S1758669AbZCQSTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669AbZCQSTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 14:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbZCQSTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 14:19:01 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:42154 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbZCQSTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 14:19:00 -0400
Date: Tue, 17 Mar 2009 13:58:37 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Nitin Gupta <ngupta@vflare.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3]: xvmalloc memory allocator
In-Reply-To: <d760cf2d0903171028o600dc94cn7a5238520d104455@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0903171355410.26058@qirst.com>
References: <49BF8ABC.6040805@vflare.org> <49BF8B8B.40408@vflare.org>  <alpine.DEB.1.10.0903171237180.21582@qirst.com> <d760cf2d0903171028o600dc94cn7a5238520d104455@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Mar 2009, Nitin Gupta wrote:

> Creating slabs for sizes in range, say, [32, 3/4*PAGE_SIZE] separated by
> 64bytes
> will require 48 slabs! Then for slab of each size class will have wastage
> due to
> unused slab objects in each class.
> Larger difference in slab sizes (and thus small no. of them), will surely
> cause too much
> wastage due to internal fragmentation.

The slabs that match existing other slabs of similar sizes will be aliased
and not created. Create the 48 slabs and you likely will only use 10 real
additional ones. The rest will just be pointing to existing ones.

> Another (more important) point to consider is that, use of slabs will
> eat-up vmalloc area to keep slab memory backed by VA space. On 32-bit
> systems, vmalloc area is small and limits amount of memory that can be
> allocated for compressed pages. With xvmalloc we map/unmap pages on
> demand thus removing dependence on vmalloc VA area.

Slab memory is not backed by vmalloc space.

> > Have you had a look at the SLOB approach?
> Nope. I will see how this may help.

Slob is another attempt to reduce wastage due to the rounding up of
object sizes to 2^N in SLAB/SLUB.

