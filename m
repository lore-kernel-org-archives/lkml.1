Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612AbXKVTYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbXKVTYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 14:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbXKVTYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 14:24:40 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:35540 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbXKVTYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 14:24:40 -0500
Date: Thu, 22 Nov 2007 20:24:36 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: djenkins@mvista.co.uk
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: MMC/SDIO sub-system: block mode versus byte mode
Message-ID: <20071122202436.4d414f3a@poseidon.drzeus.cx>
In-Reply-To: <1195733711.29143.3.camel@libdev3.libertesoft.co.uk>
References: <1195728103.20691.125.camel@libdev3.libertesoft.co.uk>
	<20071122124244.4d3808be@poseidon.drzeus.cx>
	<1195733711.29143.3.camel@libdev3.libertesoft.co.uk>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2007 12:15:11 +0000
Dean Jenkins <djenkins@mvista.co.uk> wrote:

> Hi Pierre,
> 
> Thanks for information.
> 
> My card does support 256 byte transfers in byte mode but I was expecting
> block mode to be used as block mode is supported by the card. Indeed,
> sdio_io_rw_ext_helper() checks for support of block mode before using
> byte mode. eg. block mode is preferred over byte mode in the design of
> sdio_io_rw_ext_helper().

Not really, no. What it preferred is a low number of transfers. Hence we try to shuffle as much data as possible using blocks first.

> 
> Yes, I do think single block transfers is broken :(
> 
> Both sdio_io_rw_ext_helper() and mmc_io_rw_extended() are broken for
> single block transfers.
> 
> Will you be doing a fix or how does a fix get proposed ?
> 

I agree that mmc_io_rw_extended() is broken, but I do not think sdio_io_rw_ext_helper() is. I'll be doing a fix eventually, but it probably won't get that high on my todo list as it will only be useful together with some new API. Since your card was content with byte transfers, it shouldn't be that much need for a rush.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
