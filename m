Return-Path: <linux-kernel-owner+w=401wt.eu-S1752871AbYAWNSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbYAWNSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 08:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbYAWNSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 08:18:34 -0500
Received: from mail.hevs.ch ([153.109.23.15]:45539 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbYAWNSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 08:18:33 -0500
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH 6/6] atmel_serial: Add DMA support
Date: Wed, 23 Jan 2008 14:18:38 +0100
User-Agent: KMail/1.9.7
Cc: Andrew Victor <linux@maxim.org.za>, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org, Remy Bohmer <linux@bohmer.net>,
       Chip Coldwell <coldwell@redhat.com>
References: <1201013444-30370-1-git-send-email-hskinnemoen@atmel.com> <200801231330.32777.marc.pignat@hevs.ch> <20080123134553.144ca487@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080123134553.144ca487@dhcp-252-066.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801231418.38997.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Wednesday 23 January 2008, Haavard Skinnemoen wrote:
> On Wed, 23 Jan 2008 13:30:32 +0100
> Marc Pignat <marc.pignat@hevs.ch> wrote:
> > On Wednesday 23 January 2008, Haavard Skinnemoen wrote:
...
> 
> Ok, but then any power of two larger than the cache line size should be
> fine, assuming kmalloc() returns a properly aligned buffer.
Yes. The memory should be allocated using GFP_KERNEL | GFP_DMA flags, but this
is probably a nop on at91 and avr32.

I prepare a patch using the generic dma api (allocation + dma mapping in one
call = simpler code).

> 
> Other than that, I can't see any reason why a platform with 64 byte
> cache lines should need larger buffers than one with 32 byte cache
> lines.
If the memory at the end of the cacheline is used by the cpu, it will be
corrupted while you call dma_sync_single_for_cpu(..., DMA_FROM_DEVICE);

...
> There are still issues with the DMA code that the PIO code doesn't
> have. So I think it should be selectable until we can sort out the
> error/break handling.
ok

> 
> Haavard
> 

Regards

Marc


