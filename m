Return-Path: <linux-kernel-owner+w=401wt.eu-S1753561AbXKRJly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbXKRJly (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 04:41:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbXKRJlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 04:41:46 -0500
Received: from s2.ukfsn.org ([217.158.120.143]:53487 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbXKRJlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 04:41:45 -0500
From: Nick Warne <nick@ukfsn.org>
Reply-To: nick@ukfsn.org
To: linux-kernel@vger.kernel.org
Subject: Re: sb live (emu10k1) stops working between 2.6.23.1 and 2.6.23.7
Date: Sun, 18 Nov 2007 09:41:41 +0000
User-Agent: KMail/1.9.7
Cc: Jim Faulkner <jfaulkne@ccs.neu.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711180941.41399.nick@ukfsn.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I've done some more testing this morning, and it appears that the "ALSA:
> emu10k1 - Fix memory corruption" patch from 2.6.23.6 has broken digital
> output on my SB Live Value card.  Simply replacing the 2.6.23.7 emumixer.c
> with the version included in 2.6.23.1 I was able to get digital output
> working again under 2.6.23.7.

Hi Jim,

Just to prove you are not alone, I also get the exactly the same issue:

lspci:
00:0f.0 Multimedia audio controller: Creative Labs SB Live! EMU10k1 (rev 07)

log:

Advanced Linux Sound Architecture Driver Version 1.0.14 (Fri Jul 20 09:12:58 
2007 UTC).
PCI: Found IRQ 5 for device 0000:00:0f.0
ALSA device list: #0: SBLive 5.1 [SB0060] (rev.7, serial:0x80611102) at 
0xe000, irq 5

I use a restore file at boot, so run /sbin/alsactl restore

And updating this morning to 2.6.23.8 produces:

/usr/sbin/alsactl: set_control:991: warning: name mismatch (IEC958 Playback 
Mask/IEC958 Playback Default) for control #228
/usr/sbin/alsactl: set_control:993: warning: index mismatch (3/0) for control 
#228
/usr/sbin/alsactl: set_control:993: warning: index mismatch (0/1) for control 
#229
/usr/sbin/alsactl: set_control:993: warning: index mismatch (1/2) for control 
#230
/usr/sbin/alsactl: set_control:985: warning: iface mismatch (3/2) for control 
#231
/usr/sbin/alsactl: set_control:987: warning: device mismatch (2/0) for control 
#231
/usr/sbin/alsactl: set_control:989: warning: subdevice mismatch (0/0) for 
control #231
/usr/sbin/alsactl: set_control:991: warning: name mismatch (IEC958 Playback 
Default/SB Live Analog/Digital Output Jack) for control #231

Nick




> On Fri, 16 Nov 2007, Jim Faulkner wrote:

>
> Hello,
>
> I have an SB Live Value card which uses the emu10k1 driver.  I use digital
> output to an external amplifier.  This has worked fine for many years, up
> to and including kernel 2.6.23.1.  Under 2.6.23.7, I have been unable
> to get any audio output.  I get the following errors when loading my
> asound.state under 2.6.23.7 using `alsactl restore`:
> alsactl: set_control:991: warning: name mismatch (IEC958 Playback
> Mask/IEC958 Playback Default) for control #222
> alsactl: set_control:993: warning: index mismatch (3/0) for control #222
> alsactl: set_control:993: warning: index mismatch (0/1) for control #223
> alsactl: set_control:993: warning: index mismatch (1/2) for control #224
> alsactl: set_control:985: warning: iface mismatch (3/2) for control #225
> alsactl: set_control:987: warning: device mismatch (2/0) for control #225
> alsactl: set_control:989: warning: subdevice mismatch (0/0) for control
> #225
> alsactl: set_control:991: warning: name mismatch (IEC958 Playback
> Default/SB Live Analog/Digital Output Jack) for control #225
> alsactl: set_control:993: warning: index mismatch (2/0) for control #225
> alsactl: set_control:995: failed to obtain info for control #225
> (Operation not permitted)
>
> I receive no errors when I load my asound.state under 2.6.23.1.
-- 
Free Software Foundation Associate Member 5508
