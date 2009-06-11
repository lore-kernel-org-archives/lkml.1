Return-Path: <linux-kernel-owner+w=401wt.eu-S1760785AbZFKPes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760785AbZFKPes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 11:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbZFKPel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 11:34:41 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:50158 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbZFKPek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 11:34:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:content-type
         :content-transfer-encoding:message-id;
        b=DkTL1PWGLqOeqygMrTr69c/XqzTzbnR8CI41ovhiqmA/eEA8UqXfFO5NmfnsgG0myT
         I6ivJbP0YX/5k/90qqiOsSiPGh9iOcchIqXKvHKDXTImplmI9QEZPEPyF4m+KV5jmtp0
         G4YBxdk79O/d/TlOUZKpOdP3DtGxAw4IvNclg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: sound skipping regression introduced in 2.6.30-rc8
Date: Thu, 11 Jun 2009 17:40:00 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090611-07944-gc1b019d-dirty; KDE/4.2.3; i686; ; )
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
References: <20090610.112804.193703669.davem@davemloft.net> <200906111614.07525.bzolnier@gmail.com> <s5hiqj24zp3.wl%tiwai@suse.de>
In-Reply-To: <s5hiqj24zp3.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906111740.01043.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 June 2009 16:23:04 Takashi Iwai wrote:
> At Thu, 11 Jun 2009 16:14:07 +0200,
> Bartlomiej Zolnierkiewicz wrote:
> > 
> > On Thursday 11 June 2009 15:56:14 Takashi Iwai wrote:
> > > At Thu, 11 Jun 2009 15:32:33 +0200,
> > > Bartlomiej Zolnierkiewicz wrote:
> > > > 
> > > > On Thursday 11 June 2009 14:02:20 David Miller wrote:
> > > > > From: Takashi Iwai <tiwai@suse.de>
> > > > > Date: Wed, 10 Jun 2009 21:37:14 +0200
> > > > > 
> > > > > > Also, it'd be helpful if you can check whether the problem exists in
> > > > > > the current sound git tree (for-linus branch), too.
> > > > > >   git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git for-linus
> > > > > 
> > > > > Same behavior as 2.6.30, but debugging messages are formatted differently
> > > > > :-)
> > > > > 
> > > > > [ 1109.062182] PCM: Lost interrupts? (stream=0, delta=16384, intr_ptr=73728)
> > > > > [ 1125.126123] PCM: Lost interrupts? (stream=0, delta=16384, intr_ptr=861184)
> > > > > [ 1131.398094] PCM: Lost interrupts? (stream=0, delta=16384, intr_ptr=1178624)
> > > > > [ 1135.579406] PCM: Lost interrupts? (stream=0, delta=16384, intr_ptr=1395712)
> > > > > [ 1145.115367] PCM: Lost interrupts? (stream=0, delta=16384, intr_ptr=1869824)
> > > > > [ 1152.688670] PCM: Lost interrupts? (stream=0, delta=16384, intr_ptr=2249728)
> > > > 
> > > > [ Just another data point. ]
> > > > 
> > > > I'm experiencing similar problem with the sound in recent -next kernels.
> > > 
> > > Which driver?
> > 
> > snd_intel8x0
> > 
> > > > Though the only debug data that I'm getting with xrun_debug == 1 is:
> > > > 
> > > > XRUN: pcmC0D0p:0
> > > > XRUN: pcmC0D0p:0
> > > > XRUN: pcmC0D0p:0
> > > > XRUN: pcmC0D0p:0
> > > > XRUN: pcmC0D0p:0
> > > > 
> > > > with xrun_debug == 3:
> > > > XRUN: pcmC0D0p:0
> > > > Pid: 4718, comm: audacious Not tainted 2.6.30-next-20090611-07944-gc1b019d-dirty #21
> > > > Call Trace:
> > > 
> > > The semantics of xrun_debug proc file was a bit changed.  Now it's
> > > bit flags, and 4 corresponds to the additional jiffies check (1 is to 
> > > show the debug message, 2 to show stack trace).
> > > 
> > > Try to set 5 to xrun_debug.  Do you get other messages?
> > 
> > With xrun_debug == 5 I get:
> > 
> > PCM: hw_ptr skipping! (pos=14336, delta=15893, period=1024, jdelta=3/90)
> > PCM: hw_ptr skipping! (pos=11264, delta=15893, period=1024, jdelta=3/90)
> > PCM: hw_ptr skipping! (pos=7168, delta=15888, period=1024, jdelta=3/90)
> > PCM: hw_ptr skipping! (pos=8192, delta=15915, period=1024, jdelta=3/90)
> > PCM: hw_ptr skipping! (pos=15360, delta=15888, period=1024, jdelta=3/90)
> > XRUN: pcmC0D0p:0
> > PCM: hw_ptr skipping! (pos=6144, delta=15890, period=1024, jdelta=3/90)
> > PCM: hw_ptr skipping! (pos=3072, delta=15890, period=1024, jdelta=3/90)
> > 
> > [ They seem to be the same as reported by davem against 2.6.30. ]
> 
> Yes.
> 
> > and the skipping is gone.
> 
> Does the patch below fix the problem?

Unfortunately, it did not fix the issue.

> If not, how about to revert the commit below?
> 
>     commit da2436a23c038055b1da6fe30b6ea2886b1e07b0
>     Author: Jaroslav Kysela <perex@perex.cz>
>     Date:   Mon Apr 13 21:31:25 2009 +0200
>     [ALSA] intel8x0: do not use zero value from PICB register

Same here.
