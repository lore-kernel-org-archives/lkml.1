Return-Path: <linux-kernel-owner+w=401wt.eu-S1752739AbYHYGfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbYHYGfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 02:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbYHYGfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 02:35:18 -0400
Received: from hosted05.westnet.com.au ([203.10.1.219]:49240 "EHLO
	hosted05.westnet.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbYHYGfQ (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 02:35:16 -0400
Message-ID: <48B2529B.8030906@snapgear.com>
Date: Mon, 25 Aug 2008 16:35:07 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jared Hulbert <jaredeh@gmail.com>
CC: Jamie Lokier <jamie@shareable.org>, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
References: <48AD00C4.6060302@gmail.com> <20080821110749.GA1926@shareable.org>	 <6934efce0808210711t686a88eci6eb294dbb54d68fe@mail.gmail.com>	 <48AE0476.80109@snapgear.com> <6934efce0808211948kd12ba76k1ee847a0e08010e0@mail.gmail.com>
In-Reply-To: <6934efce0808211948kd12ba76k1ee847a0e08010e0@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Branch: TNG-Outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Jared,

Jared Hulbert wrote:
>> That would be enough I think. If you could manually select
>> which files are contiguous-and-uncompressed that would be
>> useful for some too here.
> 
> So.... If you don't have an MMU when do you call ->fault?  Does the
> noMMU code just loop through ->fault()ing all the pages in an mmap()?

Sort of. It actually just uses a single ->read to bring in
the entire file contents. There is a few limitations on the use
of mmap() for non-mmu. Documentation/nommu-mmap.txt gives
more details. With no MMU it does rely on being able to kmalloc()
a single RAM region big enough to hold the entire file.


>> One thing for sure is that many people who do non-MMU setups
>> are interested in XIP to get the space savings. These are very
>> often small devices with very constrained RAM and flash. (For
>> whatever it is worth single NOR flash only boards are common in
>> these smaller form factors :-)
> 
> True.

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
SnapGear -- a Secure Computing Company      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
