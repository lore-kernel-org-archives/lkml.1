Return-Path: <linux-kernel-owner+w=401wt.eu-S1756229AbYHYOCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbYHYOCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 10:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754391AbYHYOCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 10:02:38 -0400
Received: from hosted05.westnet.com.au ([203.10.1.219]:43029 "EHLO
	hosted05.westnet.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720AbYHYOCh (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 10:02:37 -0400
Message-ID: <48B2BB71.3090803@snapgear.com>
Date: Tue, 26 Aug 2008 00:02:25 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: Jared Hulbert <jaredeh@gmail.com>, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
References: <48AD00C4.6060302@gmail.com> <20080821110749.GA1926@shareable.org> <6934efce0808210711t686a88eci6eb294dbb54d68fe@mail.gmail.com> <48AE0476.80109@snapgear.com> <6934efce0808211948kd12ba76k1ee847a0e08010e0@mail.gmail.com> <48B2529B.8030906@snapgear.com> <20080825114346.GB20960@shareable.org>
In-Reply-To: <20080825114346.GB20960@shareable.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Branch: TNG-Outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Jamie,

Jamie Lokier wrote:
> Greg Ungerer wrote:
>> Sort of. It actually just uses a single ->read to bring in
>> the entire file contents. There is a few limitations on the use
>> of mmap() for non-mmu. Documentation/nommu-mmap.txt gives
>> more details. With no MMU it does rely on being able to kmalloc()
>> a single RAM region big enough to hold the entire file.
> 
> That's unfortunate, if you're using FDPIC-ELF or BFLT-XIP, you really want
> to kmalloc() one region for code (i.e. mmap not the whole file), and
> one separate for data.

That is what the BFLT loader does. For the XIP case it mmap()s
the text directly from the file, and then mmap()s a second region
for the data/bss (reading the data into that region).

I was referring to general mmap() of a file case above, not
the exec path.


>  Asking for a single larger region sometimes
> creates much higher memory pressure while kmalloc() attempts to
> defragment by evicting everything.

Sure.


> But that's fiddly to do right in general.
> 
> The natural thing for AXFS to do to support no-MMU FDPIC-ELF or
> BFLT-XIP is store the code segment uncompressed and contiguous, and
> the data segment however the filesystem prefers, and the profiling
> information to work out where these are is readily available from the
> mmap() calls, which are always the same when an executable is run.

Yep.

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
SnapGear -- a Secure Computing Company      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
