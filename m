Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbXJJKfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbXJJKfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 06:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbXJJKe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 06:34:58 -0400
Received: from [80.75.67.54] ([80.75.67.54]:47097 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752059AbXJJKe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 06:34:57 -0400
X-Greylist: delayed 1523 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Oct 2007 06:34:57 EDT
Subject: Re: TR: codec audio Cirrus CS42L51 - Audio capture problems
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Pierre Savary <pierre.savary@kerlink.fr>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       sylvain.lesage@kerlink.fr
In-Reply-To: <000901c80b16$6779ca00$366d5e00$@savary@kerlink.fr>
References: <000901c80b16$6779ca00$366d5e00$@savary@kerlink.fr>
Content-Type: text/plain
Date: Wed, 10 Oct 2007 11:09:32 +0100
Message-Id: <1192010972.12060.407.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-10 at 10:20 +0200, Pierre Savary wrote:

> 
> I am currently writing a driver for the CS42L51 audio codec to work with
> at91sam9260, using I2C and I2S. I used the couple of files {
> /sound/soc/at91/eti_b1_wm8731.c , /sound/soc/codecs/wm8731.c } as a model.
> I succeeded in playing sounds using the codec (WAV or MP3), via /dev/dsp. 
> 
> Unfortunately, I encounter problems implementing the opposite, i.e.
> recording sounds. For example, when I launch the command  "cat /dev/dsp >
> foo.wav", or the command "wavrec foo.wav", I get "read error: Input/output
> error".
> 
> I have observed the clock signals and the RD signal (data sent from the
> codec), and when I launch the command, these signals seem correct (data is
> provided by the codec on RD pin and all signals are correctly synchronized
> together).
> 
> I didn't modify the driver dedicated to the configuration of at91sam9260
> registers  (at91-i2s.c) and it seems to me it should work in both ways
> (playback and record). I notably checked that the RFMR and RCMR registers of
> at91sam9260 were well configured.
> 
> Do someone has an idea on where the error could come from ? I must precise
> that, as I don't work with a kernel debugger, I didn't localize where the
> error occurs.
> 

Can you try "arecord -f cd -Dhw:0,0 > file.wav" as this will rule out
any OSS emulation or PCM plugin issues (this command will read directly
from your hardware).

Fwiw, this error is usually seen in capture when the upper alsa layers
don't receive any data from your hardware. This could mean your DMA or
your I2S port is not configured correctly.

Liam



