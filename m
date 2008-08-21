Return-Path: <linux-kernel-owner+w=401wt.eu-S1760965AbYHUS7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760965AbYHUS7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 14:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755436AbYHUS7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 14:59:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012AbYHUS7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 14:59:40 -0400
Date: Thu, 21 Aug 2008 14:59:39 -0400
From: "'Aristeu Rozanski'" <arozansk@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tosoni <jp.tosoni@acksys.fr>,
       "'Laurent Pinchart'" <laurentp@cse-semaphore.com>,
       linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] 8250: add support for DTR/DSR hardware flow control
Message-ID: <20080821185938.GG7154@redhat.com>
References: <200808071032.16709.laurentp@cse-semaphore.com> <000f01c8f88c$ad29d950$2e01a8c0@acksys.local> <20080818162526.1975dace@lxorguk.ukuu.org.uk> <20080820214336.GN17926@cathedrallabs.org> <20080821112309.6519c29f@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080821112309.6519c29f@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > About a RS485 ioctl: could you consider the attached files which are already
> > > > in the Linux kernel (in include/asm-cris).
> > > > They define a TIOCSERSETRS485 (ioctl.h), and the data structure (rs485.h)
> > > > with allows to specify timings. Sounds just like what we want ?
> > > 
> > > I had a deeper look at this for RS485 and the answer is "sort of". I've
> > > reworked the structure to keep it the same size irrespective of 32/64bit
> > > systems, and to make stuff flags that can be, plus add some extra u32
> > > words in case we need to (.. when we need to ;)) add stuff later.
> > > 
> > > Comments, thoughts - will this do what people in the RS485 world need ?
> > as for DTR/DSR patch, will be used the same approach?
> 
> I'm still trying to get a sensible answer on how other Unixes handle it
I did some research on that:
Solaris and AIX:
	TC{G,S}ETX for extended options and only input flow control (DTRXOFF)
SCO:
	{S,G}ETFLOW for configuring flow control, TXHARD, RXHARD for DTRDSR
FreeBSD:
	cflags has 'dtrflow' and 'dsrflow'

Having the option to set individually which pins to use for input and output
flow control and which ones should be on/off all the time seem to be a powerful
way to do it, instead of having a "CDTRDSR".

-- 
Aristeu

