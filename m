Return-Path: <linux-kernel-owner+w=401wt.eu-S1758800AbYEMXSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbYEMXSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 19:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754790AbYEMXSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 19:18:40 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:15821 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbYEMXSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 19:18:39 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: 2.6.26-rc1 regression: ISA DMA broken (bisected)
Date: Tue, 13 May 2008 17:18:39 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Takashi Iwai <tiwai@suse.de>,
       Glauber Costa <gcosta@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Pete Clements <clem@clem.clem-digital.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ALSA devel <alsa-devel@alsa-project.org>
References: <4823AAF2.7070102@keyaccess.nl> <20080513180107.1a3893f1@core> <4829D0E5.8050905@keyaccess.nl>
In-Reply-To: <4829D0E5.8050905@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805131718.40138.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 May 2008 11:33:25 am Rene Herman wrote:
> On 13-05-08 19:01, Alan Cox wrote:
> > On Tue, 13 May 2008 10:59:32 -0600, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> >> On Friday 09 May 2008 12:06:55 am Takashi Iwai wrote:
> >>> Thanks for catching it.  Yeah, the patch looks buggy.  We had an
> >>> implicit assumption that dev = NULL for ISA devices that require 24bit
> >>> DMA.
> >> Naive question #1:  Why don't we have a struct device for these
> >> ISA devices?  PNP builds a struct device with DMA_24BIT_MASK
> >> for ISAPNP devices.
> > 
> > Because nobody has done the needed work to get all the old ISA drivers
> > converted. I guess isa_device would actually be a platform_device
> > wrapper ?
> 
> No, isa_device is its own thing, on its own isa_bus (*). It has a struct 
> device * readily available though...
> 
> (*) drivers/base/isa.c, and explanatory changelog at:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=a5117ba7da37deb09df5eb802dace229b3fb1e9f

Thanks for the nice changelog.

isa_register_driver() currently doesn't set a DMA mask.  Should it?

I only see about 35 dma_alloc_coherent() calls that pass NULL.  I
guess even those would be a fair amount of work to change, and I
suppose there would be more that I missed.

Bjorn
