Return-Path: <linux-kernel-owner+w=401wt.eu-S1757061AbYGDLNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061AbYGDLNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 07:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbYGDLNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 07:13:24 -0400
Received: from mail.macqel.be ([194.78.208.39]:22208 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbYGDLNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 07:13:23 -0400
Date: Fri, 4 Jul 2008 13:13:18 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org,
       libdc1394-devel@lists.sourceforge.net, stefanr@s5r6.in-berlin.de,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Subject: Re: mmap'ed memory in core files ?
Message-ID: <20080704111318.GA28377@frolo.macqel>
References: <20080701132149.GA32510@frolo.macqel> <517f3f820807011116g6ce1b3e1qf166070f7a4c523f@mail.gmail.com> <20080702105027.GA1111@frolo.macqel> <cfd18e0f0807020358k317575c6ra0187428098f0160@mail.gmail.com> <486C4CC5.2060006@hitachi.com> <20080703092247.GA13430@frolo.macqel> <486DBA21.3080106@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486DBA21.3080106@hitachi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hidehiro,
On Fri, Jul 04, 2008 at 02:50:25PM +0900, Hidehiro Kawai wrote:
[...]
> > I see the following ways to solve my problem :
> >     - do not tag the zone as VM_RESERVED in ieee1394::dma_region_mmap
> >     - tag the zone as VM_ALWAYSDUMP in ieee1394::dma_region_mmap
> >     - add a bit in coredump_filter to dump the VM_RESERVED zones.
> > 
> > As I don't know the real meaning of VM_RESERVED, I do not know which choice
> > is the best one for the official kernel tree, but locally I'll go for
> > adding VM_ALWAYSDUMP in ieee1394::dma_region_mmap.
> 
> I'm afraid I don't know real usages of VM_RESERVED and VM_IO, either.
> Allowing everyone to choose whether dump the dma region or not,
> perhaps we need to introduce a new VM flag (e.g. VM_DUMPABLE) and
> a coredump_filter bit which controls (VM_IO | VM_RESERVED) &&
> VM_DUMPABLE area, for example.
> 
> I think it is also OK to just add VM_ALWAYSDUMP flag to the dma
> region if the device driver knows the region is safely readable
> and small enough.

I have just submitted a patch doing that for ieee1394 dma regions:

http://marc.info/?l=linux-kernel&m=121510404729225&w=2

Thanks for your help

Philippe
