Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbZAISpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbZAISpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 13:45:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbZAISpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 13:45:43 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:36956 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbZAISpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 13:45:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=UzircQ3O7txaZuD4j1xaszfwNqyQKTdUoUxB3IFPj5z+YivGZNTDsdcHi8Vu5Hck9L
         aEu5EXjGZr7i8WOvf4/RocCbwmbfP+LvUVi7mzb7taea4ms9XLnlK2469tPe5K1Z8+9t
         OfpUFin7mvXD5lBspjnta2QwFhhIsAwlo0fjg=
Message-ID: <9f4f8abe0901091045k4a06e2c9v29a7e8a7387e7a48@mail.gmail.com>
Date: Fri, 9 Jan 2009 10:45:41 -0800
From: "Vineet Gupta" <vineetg76@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Query about DMA map API implementation in non-coherent archs
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I work for Linux port of "ARC" CPU a 32 bit RISC processor, with
explicit Cache Maintenance Instructions but non Coherent DMA. We do
have ways to make coherent memory by disabing per PAGE cache bit in
MMU.

I ran into a few road blocks when implementing the Streaming DMA mapping APIs.

As per dma-mapping and dma-api docs, for streaming DMA mappings arch
needs to provide 2 seperate APIs

1. map API to convert cpu address into DMA address
2. sync API to flush/invalidate the dcaches for non-coherent archs
(essentially when changing the ownership of buffer between cpu and
device).

However from what I understood, the map API need not take care of
proper cache sync.However both ARM and MIPS do the cache sync
operations in map API as well (this is done standalone in sync APIs
too). Is there a specific reason for this.

Drivers such as libata don't even call any sync API. For e.g. libata
only calls dma_map_sg ( ) while setting up the DMA.

Does that mean that the semantics of map API ought to have cache
coherency built in or the arch code has this to workaround drivers not
calling proper sync APIs.

Also DMA-MAP.txt "recommends" that the memory passed to map API be
from kmalloc or get_free_pages to make sure it is physically
contiguous. However "recommends" is a bit ambigous. What if someone
passes a vmalloc address which is only one page worth (ignoring the
gaurd page added by kernel). Should the map API return error or should
it walk the page tables to find the physical address.


Thanks,
Vineet
