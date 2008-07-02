Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565AbYGBLEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbYGBLEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 07:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755364AbYGBLEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 07:04:41 -0400
Received: from mail.macqel.be ([194.78.208.39]:11988 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755314AbYGBLEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:04:41 -0400
Date: Wed, 2 Jul 2008 13:04:37 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org,
       libdc1394-devel@lists.sourceforge.net, hidehiro.kawai.ez@hitachi.com,
       linux1394-devel@lists.sourceforge.net
Subject: Re: mmap'ed memory in core files ?
Message-ID: <20080702110437.GB6761@frolo.macqel>
References: <20080701132149.GA32510@frolo.macqel> <517f3f820807011116g6ce1b3e1qf166070f7a4c523f@mail.gmail.com> <20080702105027.GA1111@frolo.macqel> <cfd18e0f0807020358k317575c6ra0187428098f0160@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0807020358k317575c6ra0187428098f0160@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC+= linux1394-devel@lists.sourceforge.net]

On Wed, Jul 02, 2008 at 12:58:05PM +0200, Michael Kerrisk wrote:
> [CC+= hidehiro.kawai.ez@hitachi.com]
> 
> On Wed, Jul 2, 2008 at 12:50 PM, Philippe De Muyter <phdm@macqel.be> wrote:
> > Hi Michael,
> >
> > On Tue, Jul 01, 2008 at 08:16:11PM +0200, Michael Kerrisk wrote:
> >> On 7/1/08, Philippe De Muyter <phdm@macqel.be> wrote:
> >> > Hello everybody,
> >> >
> >> >  I develop video acquisition software using the video1394 interface.
> >> >  The images grabbed by the camera and iee1394 bus are kept in kernel
> >> >  memory and made available to the user program through a mmap call done
> >> >  in the libdc1394 library :
> >> >
> >> >  dma_ring_buffer= mmap(0, vmmap.nb_buffers * vmmap.buf_size,
> >> >                 PROT_READ|PROT_WRITE,MAP_SHARED, craw->capture.dma_fd, 0);
> >> >
> >> >  Sometimes, my program crashes and produces a core file :)  It seems to
> >> >  me that the core file does not contain the mmap'ed memory and hence
> >> >  I cannot replay my program with the same image for debugging purpose.
> >> >
> >> >  Is it possible to configure the kernel through /proc, or through the mmap
> >> >  system call to have that mmapped segment in the core file, or do I need
> >> >  to modify the kernel itself to obtain the behaviour I want ?  If I
> >> >  need to modify the kernel, can some kind soul provide me some pointers ?
> >>
> >>
> >> Have a look at the section "Controlling which mappings are written to
> >> the core dump" in a recent core.5 man page:
> >> http://www.kernel.org/doc/man-pages/online/pages/man5/core.5.html
> >
> > thanks for the info.  I didn't know about /proc/PID/coredump_filter.
> >
> > that part was promising :
> >
> >       bit 2  Dump file-backed private mappings.
> >       bit 3  Dump file-backed shared mappings.
> >
> >    The default value of coredump_filter is 0x3; this reflects traditional
> >    Linux behavior and means that only anonymous memory segments are dumped.
> >
> > Unfortunately, the part that applies to me (I have tested it) is the next one :
> >
> >    Memory-mapped I/O pages such as frame buffer are never dumped, [...],
> >    regardless of the coredump_filter value.
> >
> > Is that a design decision, or a mere finding of the way it is implemented
> > now ?
> >
> > So, back to my original question :
> >
> > Can some kind soul provide me some pointers to the way I should modify
> > the kernel to make the inclusion of the video1394 mmapped segment in
> > core files possible ?
> 
> Perhaps Hidehiro, who wrote the coredump_filter feature, can provide insight.
> 
> Cheers,
> 
> Michael
> 
> -- 
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
> Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html

-- 
Philippe De Muyter  phdm at macqel dot be  Tel +32 27029044
Macq Electronique SA  rue de l'Aeronef 2  B-1140 Bruxelles  Fax +32 27029077
