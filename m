Return-Path: <linux-kernel-owner+w=401wt.eu-S1757043AbYDWUCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043AbYDWUCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 16:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756268AbYDWUCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 16:02:22 -0400
Received: from mail.AKNET.ru ([77.246.241.226]:50597 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755667AbYDWUCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 16:02:20 -0400
Message-ID: <480F95BE.60109@aknet.ru>
Date: Thu, 24 Apr 2008 00:02:06 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-mm1 (snd-pcsp doesn't like DEBUG_PAGEALLOC)
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>	<20080419021343.GA3503@nineveh.local>	<20080418200237.b5a9e805.akpm@linux-foundation.org>	<20080419041429.GA8508@anvil.corenet.prv>	<20080418212934.bbe84ee2.akpm@linux-foundation.org>	<s5h8wz7cng7.wl%tiwai@suse.de>	<480CD50F.20706@aknet.ru>	<s5hbq42b3j7.wl%tiwai@suse.de>	<480E2EE5.5040208@aknet.ru> <s5hiqy9dkhv.wl%tiwai@suse.de>
In-Reply-To: <s5hiqy9dkhv.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Takashi Iwai wrote:
>> +	printk(KERN_WARNING "PCSP: CONFIG_DEBUG_PAGEALLOC is enabled, "
>> +		KERN_WARNING "which may make the sound noisy.\n");
> Missing \n in the first line?
This was intentional - wanted it to
print in a single line. You see a space
there for that reason.
Should the second KERN_WARNING be removed
then, or what is the problem exactly?

>> - Prevent pcspkr from being built together
>> > with snd-pcsp.
>> >
>> > Signed-off-by: Stas Sergeev <stsp@aknet.ru>
> Thanks, applied to my git tree.
> git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git
> Meanwhile, we need to add a similar depenency to snd-pcsp as well, no?
I personally don't think so.
snd-pcsp has the excact copy of the pcspkr
code built-in, so I thought pcspkr can be
obsoleted in the future. From that point of
view, having snd-pcsp enabled and not even
seeing pcspkr in a menuconfig is fine.
While otherwise (you ocasionally enable
pcspkr and don't even see snd-pcsp then)
is not fine.
You mentioned earlier that you would like
to be able to swap those drivers dynamically,
but... what's the use? With such a dependancy
added, many people will not even know about
snd-pcsp as they already have pcspkr enabled.

> Fixed on ALSA tree now.
Oh...
