Return-Path: <linux-kernel-owner+w=401wt.eu-S1757006AbYJHWYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbYJHWYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 18:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755347AbYJHWY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 18:24:29 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:29654 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339AbYJHWY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 18:24:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tjD9Nd45rFQ7k0GV8+xKTQtuH1wRt7LAx3r5fh9Is7kRZasSmKXy830ltphxovVE9j
         sc/wRkcTD5TGIkrQCfPqhsJRGW2gPIrmUdU2NWPCc8NYjSeAPfAsCu7igfI6gxYclhy3
         suCjTVL3KyIh2W4YY5KoODR/Yc9ck/3DrNk7I=
Message-ID: <c32efac40810081524q15b0a747oe49de0cf0a2aa2e2@mail.gmail.com>
Date: Wed, 8 Oct 2008 15:24:27 -0700
From: "Dave Hylands" <dhylands@gmail.com>
To: "Remy Bohmer" <linux@bohmer.net>
Subject: Re: Toggling GPIO at 38Khz
Cc: "Jon Smirl" <jonsmirl@gmail.com>,
       "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <3efb10970810081157s5e0f8034n63856d2da42b3ad3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9e4733910810072043m6c69f3bdv104bd32928fe64ae@mail.gmail.com>
	 <3efb10970810081157s5e0f8034n63856d2da42b3ad3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> So how do I reliably generate 38Khz without destroying latency in the
>> system? I also don't want to measure the speed of the code I'm
>> executing - same code has to run on 90Mhz ARM and 3Ghz Core2. If a do
>> a loop with nanosleep() I need to know how fast my code is to subtract
>> it's execution time form the sleep time. The existing LIRC code works
>> this way and measures it's timing loop.
>> hrtimers look promising, but hrtimers doesn't have a periodic API. Is

The 38 kHz decoders will actually work across a range of frequencies
usually about +/- 4 kHz.

If you have a spare UART, you could configure it at 76800 baud and
just send out an appropriate bit pattern (taking into consideration
start bit, stop bit, parity, etc.

115200 baud might also work (3 bit times per 1/38400 of a second). It
won't be a perfect square wave, butI think it would still work.

You could also do something similar if you have a SPI interface. Just
set the clock to the right frequency and use the bits sent out to
generate your pulses.

-- 
Dave Hylands
Shuswap, BC, Canada
http://www.DaveHylands.com/
