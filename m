Return-Path: <linux-kernel-owner+w=401wt.eu-S1754397AbXEFNhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbXEFNhq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 09:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435AbXEFNhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 09:37:46 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:57378
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbXEFNhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 09:37:46 -0400
Message-ID: <463DE7CF.5010400@microgate.com>
Date: Sun, 06 May 2007 08:35:59 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Antonino Ingargiola <tritemio@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Oliver Neukum <oliver@neukum.org>,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible
 bug]
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>	 <1178381287.3379.8.camel@x2>	 <20070505173647.544f6707@the-village.bc.nu>	 <200705052007.16742.oliver@neukum.org>	 <20070505225241.54a5d01d@the-village.bc.nu> <5486cca80705060029p433c6acar22faaeced2d7da37@mail.gmail.com>
In-Reply-To: <5486cca80705060029p433c6acar22faaeced2d7da37@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Antonino Ingargiola wrote:
> For my use case would be more sensible to accept the new data and
> discard the older one in the tty buffer: the tty buffer would be a
> moving window of the most recent incoming data. This because if
> someone does not read the incoming data maybe he's not interested in
> it. When he finally reads the data (assuming there was buffer
> underrun) he's likely interested to the more recent chunk of incoming
> data and not to an "head" of the data firstly received. Since I
> acquire measurement data from serial this make perfect sense for me.
> But does this make sense in general too?

There is no one policy here that will make everyone happy.
Some will want all the data before some was lost,
others the data after some was lost.

The real goal is to minimize any data loss.

> However, whatever policy the buffer uses, the fundamental point it's that
> when I flush the input buffer I should be sure that each byte read
> after the flush is *new* (current) data and not old one. This because
> when the input stream can be stopped I can check that there are 0 byte
> in the buffer, but when the stream can't be stopped I must use a
> flush-and-sleep (multiple times) heuristic before I can read a single
> *reliable* byte.

The flush minimizes stale data the application must process.
As Alan said in his response there are other sources of
stale data beyond the kernel's control. But we absolutely should
be flushing all buffers we control.

In the end, if more reliability is needed the application must
implement its own discipline of framing (defining block boundaries) and
checking (CRC) on the raw data stream.

--
Paul

