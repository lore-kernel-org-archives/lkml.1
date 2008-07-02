Return-Path: <linux-kernel-owner+w=401wt.eu-S1760037AbYGBNRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760037AbYGBNRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 09:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbYGBNQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 09:16:58 -0400
Received: from mail.macqel.be ([194.78.208.39]:14790 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448AbYGBNQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 09:16:57 -0400
Date: Wed, 2 Jul 2008 15:16:52 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org,
       libdc1394-devel@lists.sourceforge.net, hidehiro.kawai.ez@hitachi.com,
       linux1394-devel@lists.sourceforge.net
Subject: Re: mmap'ed memory in core files ?
Message-ID: <20080702131652.GA12138@frolo.macqel>
References: <20080701132149.GA32510@frolo.macqel> <517f3f820807011116g6ce1b3e1qf166070f7a4c523f@mail.gmail.com> <20080702105027.GA1111@frolo.macqel> <cfd18e0f0807020358k317575c6ra0187428098f0160@mail.gmail.com> <20080702110437.GB6761@frolo.macqel> <486B739B.8050807@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486B739B.8050807@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 02:24:59PM +0200, Stefan Richter wrote:
>>> On Wed, Jul 2, 2008 at 12:50 PM, Philippe De Muyter <phdm@macqel.be> 
>>> wrote:
>>>> Hi Michael,
>>>>
>>>> On Tue, Jul 01, 2008 at 08:16:11PM +0200, Michael Kerrisk wrote:
>>>>> Have a look at the section "Controlling which mappings are written to
>>>>> the core dump" in a recent core.5 man page:
>>>>> http://www.kernel.org/doc/man-pages/online/pages/man5/core.5.html
>>>> thanks for the info.  I didn't know about /proc/PID/coredump_filter.
>>>>
>>>> that part was promising :
>>>>
>>>>       bit 2  Dump file-backed private mappings.
>>>>       bit 3  Dump file-backed shared mappings.
>>>>
>>>>    The default value of coredump_filter is 0x3; this reflects 
>>>> traditional
>>>>    Linux behavior and means that only anonymous memory segments are 
>>>> dumped.
>>>>
>>>> Unfortunately, the part that applies to me (I have tested it) is the 
>>>> next one :
>>>>
>>>>    Memory-mapped I/O pages such as frame buffer are never dumped, [...],
>>>>    regardless of the coredump_filter value.
>
> This shouldn't be a problem to you as far as I understand.  I suppose 
> "memory mapped I/O pages" means registers of PCI devices, mapped into the 
> memory address space.
>
> The DMA buffer which you would like to get included in the core file is 
> normal RAM (I suppose: allocated by the kernel in the kernel's virtual 
> address space, mapped into the application client's address space by 
> mmap(), and also mapped into the FireWire controller's local bus address 
> space for it to write received data into).

I agree with your analysis, but the sentence takes as exemple 'frame buffer'
which I don't think are registers. I have tested with a video1394 client,
and I do not get the mmapped video memory in the core file, even with
/proc/PID/coredump_filter set to 0xf.  So, while I agree it seems technically
feasible, it does not seem to be currently implemented :(

Philippe
