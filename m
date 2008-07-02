Return-Path: <linux-kernel-owner+w=401wt.eu-S932427AbYGBMZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427AbYGBMZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 08:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbYGBMZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 08:25:20 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51807 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758352AbYGBMZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 08:25:19 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <486B739B.8050807@s5r6.in-berlin.de>
Date: Wed, 02 Jul 2008 14:24:59 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080614 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Philippe De Muyter <phdm@macqel.be>
CC: Michael Kerrisk <mtk.manpages@googlemail.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org,
       libdc1394-devel@lists.sourceforge.net, hidehiro.kawai.ez@hitachi.com,
       linux1394-devel@lists.sourceforge.net
Subject: Re: mmap'ed memory in core files ?
References: <20080701132149.GA32510@frolo.macqel> <517f3f820807011116g6ce1b3e1qf166070f7a4c523f@mail.gmail.com> <20080702105027.GA1111@frolo.macqel> <cfd18e0f0807020358k317575c6ra0187428098f0160@mail.gmail.com> <20080702110437.GB6761@frolo.macqel>
In-Reply-To: <20080702110437.GB6761@frolo.macqel>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Wed, Jul 2, 2008 at 12:50 PM, Philippe De Muyter <phdm@macqel.be> wrote:
>>> Hi Michael,
>>>
>>> On Tue, Jul 01, 2008 at 08:16:11PM +0200, Michael Kerrisk wrote:
>>>> Have a look at the section "Controlling which mappings are written to
>>>> the core dump" in a recent core.5 man page:
>>>> http://www.kernel.org/doc/man-pages/online/pages/man5/core.5.html
>>> thanks for the info.  I didn't know about /proc/PID/coredump_filter.
>>>
>>> that part was promising :
>>>
>>>       bit 2  Dump file-backed private mappings.
>>>       bit 3  Dump file-backed shared mappings.
>>>
>>>    The default value of coredump_filter is 0x3; this reflects traditional
>>>    Linux behavior and means that only anonymous memory segments are dumped.
>>>
>>> Unfortunately, the part that applies to me (I have tested it) is the next one :
>>>
>>>    Memory-mapped I/O pages such as frame buffer are never dumped, [...],
>>>    regardless of the coredump_filter value.

This shouldn't be a problem to you as far as I understand.  I suppose 
"memory mapped I/O pages" means registers of PCI devices, mapped into 
the memory address space.

The DMA buffer which you would like to get included in the core file is 
normal RAM (I suppose: allocated by the kernel in the kernel's virtual 
address space, mapped into the application client's address space by 
mmap(), and also mapped into the FireWire controller's local bus address 
space for it to write received data into).

FireWire controllers also have memory-mapped I/O regions (per OHCI: at 
least one region of at least 2048 bytes size).  But your process never 
accesses them, only the kernel drivers do (to start and stop DMA 
programs and so on --- while the DMA programs and the DMA data buffers 
live in normal RAM).
-- 
Stefan Richter
-=====-==--- -=== ---=-
http://arcgraph.de/sr/
