Return-Path: <linux-kernel-owner+w=401wt.eu-S1760650AbYEMRMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760650AbYEMRMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 13:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758272AbYEMRM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 13:12:29 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37646 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756038AbYEMRM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 13:12:28 -0400
Date: Tue, 13 May 2008 18:01:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Takashi Iwai <tiwai@suse.de>, Rene Herman <rene.herman@keyaccess.nl>,
       Glauber Costa <gcosta@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Pete Clements <clem@clem.clem-digital.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: 2.6.26-rc1 regression: ISA DMA broken (bisected)
Message-ID: <20080513180107.1a3893f1@core>
In-Reply-To: <200805131059.32911.bjorn.helgaas@hp.com>
References: <4823AAF2.7070102@keyaccess.nl>
	<s5hzlr0105c.wl%tiwai@suse.de>
	<200805131059.32911.bjorn.helgaas@hp.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008 10:59:32 -0600
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> On Friday 09 May 2008 12:06:55 am Takashi Iwai wrote:
> > Thanks for catching it.  Yeah, the patch looks buggy.  We had an
> > implicit assumption that dev = NULL for ISA devices that require 24bit
> > DMA.
> 
> Naive question #1:  Why don't we have a struct device for these
> ISA devices?  PNP builds a struct device with DMA_24BIT_MASK
> for ISAPNP devices.

Because nobody has done the needed work to get all the old ISA drivers
converted. I guess isa_device would actually be a platform_device
wrapper ?

