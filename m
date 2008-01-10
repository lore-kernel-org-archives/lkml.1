Return-Path: <linux-kernel-owner+w=401wt.eu-S1759351AbYAJIyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351AbYAJIyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 03:54:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754390AbYAJIyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 03:54:33 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:45672 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753740AbYAJIyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 03:54:32 -0500
Date: Thu, 10 Jan 2008 09:54:28 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "Bryan Wu" <cooloney.lkml@gmail.com>
Cc: "Cai, Cliff" <Cliff.Cai@analog.com>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] split MMC_CAP_4_BIT_DATA
Message-ID: <20080110095428.3b93fd18@poseidon.drzeus.cx>
In-Reply-To: <386072610801090845r14510fb8tbcca76d605458a96@mail.gmail.com>
References: <386072610801081832w2befcbafwe9215067f022ed5d@mail.gmail.com>
	<0F1B54C89D5F954D8535DB252AF412FA014FAD4A@chinexm1.ad.analog.com>
	<20080109082325.212ec90d@poseidon.drzeus.cx>
	<386072610801090845r14510fb8tbcca76d605458a96@mail.gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008 00:45:27 +0800
"Bryan Wu" <cooloney.lkml@gmail.com> wrote:

> 
> Actually, Blackfin BF54x on-chip SDIO host controller is supposed to
> support 1-bit and 4-bit MMC or SD. But in the real platform, when MMC
> works at 4-bit mode there will be a FIFO underrun error
> (http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=3535).
> While SD works at 4-bit mode is OK. We believe this is a hardware
> issue of the SDIO host controller of BF54x.

Odd. As there shouldn't be a difference, I'm inclined to believe that this is card dependent. So it could as well appear with some SD cards as well.

How much have you tested this issue? That tracker entry isn't very verbose.

Also, how can an underrun appear? The system should have flow control. And an underrun does not sound like a bus problem, rather that you have a card with different speed characteristics than the hardware/driver can handle.

> 
> We intend to workaround in our own BF54x SDIO host controller driver,
> but there is no place for us to determine MMC or SD. One choice is to
> hack common code like this:

_If_ it truly cannot handle 4-bit MMC, then Mike's patch is the way to go. But I'm not yet convinced that the problem is related to MMC vs SD.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
