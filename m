Return-Path: <linux-kernel-owner+w=401wt.eu-S1764774AbXHDNXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764774AbXHDNXR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 09:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756455AbXHDNXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 09:23:08 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:56770 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756202AbXHDNXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 09:23:06 -0400
Date: Sat, 4 Aug 2007 15:23:04 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: David Vrabel <david.vrabel@csr.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sdio: enhance IO_RW_EXTENDED support
Message-ID: <20070804152304.65ed8f1b@poseidon.drzeus.cx>
In-Reply-To: <11858961933491-git-send-email-david.vrabel@csr.com>
References: <11858961933491-git-send-email-david.vrabel@csr.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 16:36:30 +0100
David Vrabel <david.vrabel@csr.com> wrote:

> These three patches enhance the support for the SDIO IO_RW_EXTENDED
> command. The block size of functions is managed and the I/O ops
> (sdio_readsb() etc) are extended to handle arbitrary lengths of data
> (by using multiple commands).
> 
> I've not yet had a chance to test this stuff as I don't (yet) have
> the time to write a Bluetooth Type-A driver so these are posted as an
> example of the sort of API I'd expect.
> 

Thanks. These are some nice improvements. I do have one suggestion
though:

Could we design it so that sdio_io_rw_ext_helper() sets the block size
itself? That way most drivers wouldn't have to care about that detail
and the core would be free to choose optimal values.

I suspect that some transactions might require a certain block size.
But we could satisfy that by stating that any transfer small enough to
fit into one block will not be split up.

(PS. You might want to add [PATCH x/3] to your subjects so that the
order of the patches is crystal clear)

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
