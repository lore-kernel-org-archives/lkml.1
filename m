Return-Path: <linux-kernel-owner+w=401wt.eu-S1759247AbYFEPOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247AbYFEPOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 11:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbYFEPOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 11:14:40 -0400
Received: from mail.pager.net ([209.253.16.26]:34369 "EHLO barracuda.pager.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753496AbYFEPOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 11:14:40 -0400
X-Greylist: delayed 857 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jun 2008 11:14:39 EDT
X-ASG-Debug-ID: 1212678020-026a00640000-xx1T2L
X-Barracuda-URL: http://192.168.1.240:8000/cgi-bin/mark.cgi
From: Geoffrey Wossum <geoffrey@pager.net>
Organization: Long Range Systems
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
X-ASG-Orig-Subj: Re: AT32 ASoC Driver Patches on alsa-devel
Subject: Re: AT32 ASoC Driver Patches on alsa-devel
Date: Thu, 5 Jun 2008 10:00:56 -0500
User-Agent: KMail/1.9.9
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org
References: <200806050851.47319.geoffrey@pager.net> <20080605162206.0a34a54e@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080605162206.0a34a54e@hskinnemo-gx745.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806051000.56969.geoffrey@pager.net>
X-Barracuda-Connect: LRS-CiscoRouter[192.168.1.1]
X-Barracuda-Start-Time: 1212678020
X-Barracuda-Virus-Scanned: by Barracuda Spam Firewall at pager.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 June 2008 09:22:06 am Haavard Skinnemoen wrote:
> Geoffrey Wossum <geoffrey@pager.net> wrote:
> > For anyone that's interested, there's patches to add ALSA System-on-Chip
> > sound platform drivers for the AVR32 being discussed on the alsa-devel
> > mailing list right now.
>
> Hmm. For something that depends on a metric shitload of middle layers,
> it is surprisingly large...

Partly because the code attempts to handle every contingency an application 
might throw at (different sample rates, formats, clocking options, etc.).  
Partly because it also has some concern for power management.


> I have to admit I don't understand the current sound situation at all.
> With this driver, we now have:

To paraphrase Andy Tanenbaum, the great thing about standards is there's so 
many to choose from.


>   * An OSS driver for the AP7000 Audio Bitstream DAC
OSS <shudder>


>   * A "regular" ALSA driver for the AC97C (not based on ASoC)
I don't have an AC97 CODEC.


>   * An i2s driver for the AT73C213 chip using the SSC controller and SPI
Strongly coupled to the AT73C213, not the chip I'm using, although it did 
provide a good example of working code.  This is where I figured out I needed 
to use big endian.


>   * Some sort of "AT32 PCM" layer which apparently can only be used
>     with the SSC controller
This IS sort of confusing.  It's really more of a generic SSC / PDC driver 
than a "PCM layer".  Its existence is largely an artifact of it being in the 
AT91 ASoC platform code, which I "ported" to get the AT32 platform code.  Its 
existence in the AT91 platform driver is an artifact of the AT91 driver being 
based on the PXA platform driver.  In other words, I'm not really the one to 
explain the design rationale behind it.

 
>   * The above two being essentially identical to similar drivers for
>     AT91
Yes, I didn't particularly like making the AT32 code almost exactly like the 
AT91 code, and most of the differences are due to changes in some kernel APIs 
rather than the peripherals really being different (BTW, the changes in the 
AT32 are an improvement!).  But I needed an AT32 layer quickly, and I don't 
have any AT91 hardware, so I couldn't really go mucking about in the AT91 
code since I wouldn't be able to test it.  I don't feel especially bad, 
though, since at91_mci.c and atmel-mci.c commit essentially the same sin.


> Can someone please help me out here? In particular, what is ASoC and
> why should I want to use it?

Number 1 reason (for me):  The only driver for my CODEC (WM8510) was an ASoC 
driver.  Using sound system other than ASoC would require porting / rewriting 
this driver.  Since an AT91 ASoC platform driver already existed, and would 
be virtually the same as the AT32 platform driver, this was the best choice 
for getting sound quickly.  So this essentially boils down to code reuse.  
And if we switch CODEC's for some reason, it's less work.

Another highly compelling reason: power consumption.  Only powers up parts of 
the audio pathway that are currently needed.

For more reasons:  http://alsa-project.org/main/index.php/ASoC
Legal notice: I received no compensation for this endosement :)

---
Geoffrey
