Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbZDEAoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbZDEAoV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 20:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbZDEAoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 20:44:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60442 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619AbZDEAoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 20:44:11 -0400
Message-ID: <49D7FD94.2040001@zytor.com>
Date: Sat, 04 Apr 2009 17:38:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Anton Vorontsov <avorontsov@ru.mvista.com>
CC: Kumar Gala <galak@kernel.crashing.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 3/3] powerpc/86xx: Add MMC SPI support for MPC8610HPCD
 boards
References: <20090404192826.GC12183@oksana.dev.rtsoft.ru>
In-Reply-To: <20090404192826.GC12183@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov wrote:
> This patch adds spi and mmc-spi-slot nodes, plus a gpio-controller
> for PIXIS' sdcsr bank that is used for managing SPI chip-select and
> for reading card's states.
> 
> Note that spi-max-frequency is lowered since at high frequencies SD
> cards don't work reliably (there is some problem with the chip select
> line, it's probably quite slow because it's routed via PIXIS).
> 
> Previously there was a work around: we didn't use chip-select line
> at all, but some cards don't like that, so we'd better use the low
> frequency.
> 
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>

I have to admit being somewhat confused.  The CS# line is pulled low and
stays low for the duration of a command, so it shouldn't affect the SPI
frequency, only the delay between commands.

You're saying "some cards don't like not using the CS# line" ... in
particular, I know there are hardware devices which toggle the clock at
low frequency (< 400 kHz) for a while (I think the minimum is 88 clocks
or so) and then permanently assert the CS# line before giving the
starting CMD0.  Even so, the CMD0 is supposed to be sent at < 400 kHz
since the card will still be in open drain mode at that point.

Does that disagree with your observations?  If so, I'd be really
interested to find out what you have seen in more detail, as it adds to
the understanding of MMC/SD cards in the field.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

