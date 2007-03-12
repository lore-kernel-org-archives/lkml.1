Return-Path: <linux-kernel-owner+w=401wt.eu-S1030401AbXCLPsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030401AbXCLPsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 11:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030430AbXCLPsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 11:48:45 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:51001 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030401AbXCLPso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 11:48:44 -0400
Date: Mon, 12 Mar 2007 15:46:47 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, perex@suse.cz,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [SOUND] hda_intel: build fix
Message-ID: <20070312154647.GC11974@linux-mips.org>
References: <20070310190513.GA24435@linux-mips.org> <s5h8xe2soxt.wl%tiwai@suse.de> <20070312135351.GA11974@linux-mips.org> <s5hzm6ijzep.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <s5hzm6ijzep.wl%tiwai@suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 03:43:10PM +0100, Takashi Iwai wrote:

> Fair enough.  I agree that removing const is the only reasonable fix
> right now.   But from semantics, const is a good thing, and people may
> try to add it again later if we get rid of them now.  So, how about to
> comment out such as /*const*/ in each place to remind that it's
> intentional?

I consider that harder to read and uglier.  If anything maybe something
like:

#define __const_devinit
[...]
static __const_devinit struct snd_kcontrol_new snd_ice1712_delta1010lt_wordclock_status __devinitdata =

Worth it?  I doubt.

> Also, in your patch to ice1712, you don't have to remove const from the
> codes in snd_ice1712_read_eeprom() and snd_ice1712_probe() functions.
> They should work as const pointer.

No, that results in warnings:

  CC      sound/pci/ice1712/ice1712.o
sound/pci/ice1712/ice1712.c: In function ‘snd_ice1712_read_eeprom’:
sound/pci/ice1712/ice1712.c:2354: warning: assignment from incompatible pointer type
sound/pci/ice1712/ice1712.c: In function ‘snd_ice1712_probe’:
sound/pci/ice1712/ice1712.c:2693: warning: assignment from incompatible pointer type

  Ralf
