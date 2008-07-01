Return-Path: <linux-kernel-owner+w=401wt.eu-S1760393AbYGAVod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760393AbYGAVod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 17:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbYGAVo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 17:44:26 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:40899 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751872AbYGAVoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 17:44:25 -0400
Date: Wed, 2 Jul 2008 07:44:23 +1000
From: Bron Gondwana <brong@fastmail.fm>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Philippe De Muyter <phdm@macqel.be>, linux-kernel@vger.kernel.org,
       robm@fastmail.fm
Subject: Re: mmap'ed memory in core files ?
Message-ID: <20080701214423.GA29875@brong.net>
References: <20080701132149.GA32510@frolo.macqel> <517f3f820807011116g6ce1b3e1qf166070f7a4c523f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517f3f820807011116g6ce1b3e1qf166070f7a4c523f@mail.gmail.com>
Organization: brong.net
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 08:16:11PM +0200, Michael Kerrisk wrote:
> On 7/1/08, Philippe De Muyter <phdm@macqel.be> wrote:
> > Hello everybody,
> >
> >  I develop video acquisition software using the video1394 interface.
> >  The images grabbed by the camera and iee1394 bus are kept in kernel
> >  memory and made available to the user program through a mmap call done
> >  in the libdc1394 library :
> >
> >  dma_ring_buffer= mmap(0, vmmap.nb_buffers * vmmap.buf_size,
> >                 PROT_READ|PROT_WRITE,MAP_SHARED, craw->capture.dma_fd, 0);
> >
> >  Sometimes, my program crashes and produces a core file :)  It seems to
> >  me that the core file does not contain the mmap'ed memory and hence
> >  I cannot replay my program with the same image for debugging purpose.
> >
> >  Is it possible to configure the kernel through /proc, or through the mmap
> >  system call to have that mmapped segment in the core file, or do I need
> >  to modify the kernel itself to obtain the behaviour I want ?  If I
> >  need to modify the kernel, can some kind soul provide me some pointers ?
> 
> 
> Have a look at the section "Controlling which mappings are written to
> the core dump" in a recent core.5 man page:
> http://www.kernel.org/doc/man-pages/online/pages/man5/core.5.html

Interesting (and somewhat off topic to your conversation here) - it
appears that when dumping mappings, the kernel ignores the maximum
core size set with "limit".

This is particularly interesting on a 64 bit kernel where a bug in
your code causes you to try to read something about 2Gb into your
alleged mmaped file (actual size ~500 bytes) and the segfault causes
a coredump.

Bron.
