Return-Path: <linux-kernel-owner+w=401wt.eu-S1753287AbYAWMaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbYAWMaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 07:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbYAWMa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 07:30:28 -0500
Received: from mail.hevs.ch ([153.109.23.15]:43617 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbYAWMa1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 07:30:27 -0500
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH 6/6] atmel_serial: Add DMA support
Date: Wed, 23 Jan 2008 13:30:32 +0100
User-Agent: KMail/1.9.7
Cc: Andrew Victor <linux@maxim.org.za>, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org, Remy Bohmer <linux@bohmer.net>,
       Chip Coldwell <coldwell@redhat.com>
References: <1201013444-30370-1-git-send-email-hskinnemoen@atmel.com> <200801221752.43830.marc.pignat@hevs.ch> <20080123125300.5d8d7006@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080123125300.5d8d7006@dhcp-252-066.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801231330.32777.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Wednesday 23 January 2008, Haavard Skinnemoen wrote:
> On Tue, 22 Jan 2008 17:52:43 +0100
> Marc Pignat <marc.pignat@hevs.ch> wrote:
> 
> > Hi!
> > 
> > I removed linux-arm-kernel@lists.arm.linux.org.uk from cc, it is a
> > subscriber-only list.
> 
> Right. Does that mean I shouldn't Cc it on patches?
extract from the linux-arm-kernel 'Mailing List Etiquette':
             10. Cross-posting between linux-arm* lists and other lists. [[40]rmk]
                Please do not do this. Subscribers on other lists may not be
                subscribed to the linux-arm lists, so when they try to reply to
                such a message, they will receive a bounce. This is deemed by
                others to be rude behaviour on the part of the person who
                originally cross-posted.
> 
> > On Tuesday 22 January 2008, Haavard Skinnemoen wrote:
> > > From: Chip Coldwell <coldwell@redhat.com>
> > ...
> > > @@ -47,6 +50,11 @@
> > >  
> > >  #include "atmel_serial.h"
> > >  
> > > +#define SUPPORT_PDC
> > > +#define PDC_BUFFER_SIZE		(L1_CACHE_BYTES << 3)
> > > +#warning "Revisit"
> > why add this warning?
> 
> Dunno. I suppose the PDC_BUFFER_SIZE and/or PDC_RX_TIMEOUT definitions
> needs to be revisited? Chip?
I just think there is no need to warn, even if definitions are sub-optimal.

> 
> I don't really understand why the buffer size depends on the cache line
> size either. Why don't we just set it to something nice and large, like
> 512 (actually 1024 since there are two buffers), and be done with it?
Probably for dma safety/performance, The PDC buffer start should be aligned to
cache line, and the size be a multiple of cache line size.

> 
> And while we're at it, might as well move the SUPPORT_PDC definition
> into Kconfig where it belongs...
For me there is no need to disbable pdc support once working. PDC can be
enabled/disabled in the board setup code. -> simply remove this definition.

Regards

Marc

