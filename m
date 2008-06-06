Return-Path: <linux-kernel-owner+w=401wt.eu-S1758906AbYFFObw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906AbYFFObw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 10:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbYFFObo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 10:31:44 -0400
Received: from mail.pager.net ([209.253.16.26]:48194 "EHLO barracuda.pager.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755896AbYFFObn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 10:31:43 -0400
X-ASG-Debug-ID: 1212762701-23fd00610000-xx1T2L
X-Barracuda-URL: http://192.168.1.240:8000/cgi-bin/mark.cgi
From: Geoffrey Wossum <geoffrey@pager.net>
Organization: Long Range Systems
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
X-ASG-Orig-Subj: Re: AT32 ASoC Driver Patches on alsa-devel
Subject: Re: AT32 ASoC Driver Patches on alsa-devel
Date: Fri, 6 Jun 2008 09:32:15 -0500
User-Agent: KMail/1.9.9
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org
References: <200806050851.47319.geoffrey@pager.net> <200806051210.47986.geoffrey@pager.net> <20080606112915.4b1d5d42@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080606112915.4b1d5d42@hskinnemo-gx745.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806060932.15461.geoffrey@pager.net>
X-Barracuda-Connect: UNKNOWN[192.168.1.1]
X-Barracuda-Start-Time: 1212762701
X-Barracuda-Virus-Scanned: by Barracuda Spam Firewall at pager.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 June 2008 04:29:15 am Haavard Skinnemoen wrote:
> Geoffrey Wossum <geoffrey@pager.net> wrote:
> > On Thursday 05 June 2008 11:24:09 am Haavard Skinnemoen wrote:
> > > Geoffrey Wossum <geoffrey@pager.net> wrote:
> > > > On Thursday 05 June 2008 09:22:06 am Haavard Skinnemoen wrote:
> > > > > Geoffrey Wossum <geoffrey@pager.net> wrote:

> Ok. Since the SSC module is a multi-purpose module, the SSC driver was
> designed to be as thin and flexible as possible. So we just added some
> platform_driver glue and a request/free interface and left everything
> else up to the higher-level driver.
>
> I suppose we could add a few more helper functions. Suggestions are
> welcome.

It's hard to try to add all the possible permutations of functionality.  
Probably just getting register bit field constants defined would help out 
tremendously. 


> >  One issue is the SSC
> > interface, which you have said could be used on the AT91.  After that,
> > the main differences are that the DMA buffer has to be allocated
> > differently, and the mmap() implementation is different.
>
> Oh. That's a bit surprising to me...can you elaborate on the
> differences?

Well, I used a coherent DMA buffer on the AVR32.  I was trying to rule out 
caching effects for the issues I was having at first.  Eventually it should 
be switched back to a writecombined DMA buffer.  I assume this will require 
adding some dma_sync_*() calls, which strangely seem to be missing from  
at91-pcm.c.

The mmap() would still look different, though.  The AT91 uses  
dma_mmap_writecombine(), which only exists on the ARM.  Glancing at that 
routine, it seems to jump through a lot of hoops.  I've never worked on an 
ARM with an MMU, so I don't really know why it's necessary.  But the AVR32 
just requires a call to remap_pfn_range().

---
Geoffrey


