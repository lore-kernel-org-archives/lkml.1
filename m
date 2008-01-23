Return-Path: <linux-kernel-owner+w=401wt.eu-S1752878AbYAWMqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbYAWMqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 07:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbYAWMqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 07:46:43 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:55491 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750855AbYAWMqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 07:46:42 -0500
Date: Wed, 23 Jan 2008 13:45:53 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Marc Pignat <marc.pignat@hevs.ch>
Cc: Andrew Victor <linux@maxim.org.za>, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org, Remy Bohmer <linux@bohmer.net>,
       Chip Coldwell <coldwell@redhat.com>
Subject: Re: [PATCH 6/6] atmel_serial: Add DMA support
Message-ID: <20080123134553.144ca487@dhcp-252-066.norway.atmel.com>
In-Reply-To: <200801231330.32777.marc.pignat@hevs.ch>
References: <1201013444-30370-1-git-send-email-hskinnemoen@atmel.com>
	<200801221752.43830.marc.pignat@hevs.ch>
	<20080123125300.5d8d7006@dhcp-252-066.norway.atmel.com>
	<200801231330.32777.marc.pignat@hevs.ch>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jan 2008 13:30:32 +0100
Marc Pignat <marc.pignat@hevs.ch> wrote:
> On Wednesday 23 January 2008, Haavard Skinnemoen wrote:
> > Right. Does that mean I shouldn't Cc it on patches?
> extract from the linux-arm-kernel 'Mailing List Etiquette':
>              10. Cross-posting between linux-arm* lists and other lists. [[40]rmk]
>                 Please do not do this. Subscribers on other lists may not be
>                 subscribed to the linux-arm lists, so when they try to reply to
>                 such a message, they will receive a bounce. This is deemed by
>                 others to be rude behaviour on the part of the person who
>                 originally cross-posted.

Ok, sorry about that.

> > Dunno. I suppose the PDC_BUFFER_SIZE and/or PDC_RX_TIMEOUT definitions
> > needs to be revisited? Chip?
> I just think there is no need to warn, even if definitions are sub-optimal.

I agree, so I replaced it with a comment.

> > I don't really understand why the buffer size depends on the cache line
> > size either. Why don't we just set it to something nice and large, like
> > 512 (actually 1024 since there are two buffers), and be done with it?
> Probably for dma safety/performance, The PDC buffer start should be aligned to
> cache line, and the size be a multiple of cache line size.

Ok, but then any power of two larger than the cache line size should be
fine, assuming kmalloc() returns a properly aligned buffer.

Other than that, I can't see any reason why a platform with 64 byte
cache lines should need larger buffers than one with 32 byte cache
lines.

> > And while we're at it, might as well move the SUPPORT_PDC definition
> > into Kconfig where it belongs...
> For me there is no need to disbable pdc support once working. PDC can be
> enabled/disabled in the board setup code. -> simply remove this definition.

There are still issues with the DMA code that the PIO code doesn't
have. So I think it should be selectable until we can sort out the
error/break handling.

Haavard
