Return-Path: <linux-kernel-owner+w=401wt.eu-S1753730AbXFXWoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbXFXWoV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 18:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbXFXWoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 18:44:13 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:38352 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751742AbXFXWoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 18:44:12 -0400
Date: Mon, 25 Jun 2007 00:44:11 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tomasz =?utf-8?Q?K=C5=82oczko?= <kloczek@rudy.mif.pg.gda.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Message-ID: <20070624224411.GB21724@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Tomasz =?utf-8?Q?K=C5=82oczko?= <kloczek@rudy.mif.pg.gda.pl>,
	linux-kernel@vger.kernel.org
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl> <20070624200837.16e11305@the-village.bc.nu> <Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl> <20070624215724.025a5de5@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070624215724.025a5de5@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 09:57:24PM +0100, Alan Cox wrote:
> > Sory Alan but I don't want philosophical/historical discuss.
> > Try to answer on question "ALSA or OSS ?" using *only* technical arguments.
> 
> We dropped OSS for ALSA for technical reasons. Those being that ALSA
> - has a better audio API
> - is more flexible
> - provides OSS as emulation
> - supports more hardware

I sent a patch to the ALSA developers 4 years ago.
It was never included in the kernel :/

Here's the comment from a script that I once wrote to
make some closed-source dinosar code run (speech recognition)
on modern linux:

# Note that ALSA (Advanced Linux Sound Architecture), the sound drivers that
# replace the older OSS as of kernel 2.5, also introduce a problem for some
# soundcards: unlike the OSS drivers, the ALSA drivers limit the recording
# buffer to the hardware limit of your sound card.  For example, the SB Live!
# only has two 'period' buffers (called fragments before), and although
# viavoice requests an 'arbitrary number of periods, size 1024 bytes', it
# only gets two periods of 1024 bytes: 2048 bytes in total!  The ViaVoice
# engine however doesn't even process sound until it sees at least 6102 bytes.
# The 'solution' for this is to increase the buffer size (from 1024 to say
# 8192), this script also takes care of that.  Unfortunately, also that is
# possibly not enough: the sound is read from the hardware in chunks of
# 'period size' and having only two buffers this is often causing an underrun.
# When ALSA sees an underrun... it stops the sound stream.

My (four year old) patch can be found here:

http://www.xs4all.nl/~carlo17/alsa/index.html

I STILL think that ALSA should restart the stream after an underrun,
but I am not someone who asks twice :p usually.

-- 
Carlo Wood <carlo@alinoe.com>
