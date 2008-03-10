Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbYCJM6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbYCJM6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 08:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbYCJM6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 08:58:41 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:46141 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbYCJM6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 08:58:40 -0400
Date: Mon, 10 Mar 2008 13:56:30 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Roel Kluin <12o3l@tiscali.nl>, Alex Dubov <oakad@yahoo.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: MMC: logical-bitwise and confusion in  tifm_sd_transfer_data()?
Message-ID: <20080310135630.5184b87b@mjolnir.drzeus.cx>
In-Reply-To: <47D4490C.7030204@tiscali.nl>
References: <47D4490C.7030204@tiscali.nl>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 09 Mar 2008 21:31:08 +0100
Roel Kluin <12o3l@tiscali.nl> wrote:

> from drivers/mmc/host/tifm_sd.c:183:
> 
> if ((r_data->flags & MMC_DATA_WRITE)
>     && DATA_CARRY)
> 
> shouldn't this be bit-wise &?

First off, I'm not the maintainer of that driver, Alex Dubov is.

Second, the code seems broken, but not in the way you suggest. It should probably have been:

if ((r_data->flags & MMC_DATA_WRITE)
	&& (host->cmd_flags & DATA_CARRY))

Alex, could you have a look?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
