Return-Path: <linux-kernel-owner+w=401wt.eu-S965559AbXIGMEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965559AbXIGMEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 08:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965200AbXIGMEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 08:04:35 -0400
Received: from tzmxr02.htp-tel.de ([81.14.243.18]:50703 "EHLO
	TZMXR02.htp-tel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965170AbXIGMEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 08:04:34 -0400
Message-ID: <46E13E31.1050409@leemhuis.info>
Date: Fri, 07 Sep 2007 14:04:01 +0200
From: Thorsten Leemhuis <fedora@leemhuis.info>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Romano Giannetti <romano@dea.icai.upcomillas.es>,
       Andrew Morton <akpm@linux-foundation.org>, roger@computer-surgery.co.uk,
       linux-kernel@vger.kernel.org, perex@suse.cz
Subject: easy alsa patches for the stable kernel? (was: Re: hda_intel : Patch
 + Regression in 2.6.18 -> 2.6.22)
References: <20070822222902.GA28563@computer-surgery.co.uk>	<20070905083844.6637da1e.akpm@linux-foundation.org>	<s5hlkbl6qsn.wl%tiwai@suse.de>	<20070905091633.87cfaa81.akpm@linux-foundation.org>	<s5hhcm96oza.wl%tiwai@suse.de>	<1189091390.3212.3.camel@rukbat>	<s5hir6n6ck6.wl%tiwai@suse.de>	<1189115313.7275.5.camel@rukbat>	<1189153347.15955.5.camel@rukbat> <s5h7in26aj3.wl%tiwai@suse.de>
In-Reply-To: <s5h7in26aj3.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.09.2007 12:21, Takashi Iwai wrote:
> At Fri, 07 Sep 2007 10:22:27 +0200,
> Romano Giannetti wrote:
>> Takashi: good news!
>>
>> diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
>> index 3557865..496d119 100644
>> --- a/sound/pci/hda/patch_realtek.c
>> +++ b/sound/pci/hda/patch_realtek.c
>> @@ -9044,6 +9044,7 @@ static const char *alc268_models[ALC268_MODEL_LAST] = {
>>  static struct snd_pci_quirk alc268_cfg_tbl[] = {
>>         SND_PCI_QUIRK(0x1043, 0x1205, "ASUS W7J", ALC268_3ST),
>>         SND_PCI_QUIRK(0x1179, 0xff10, "TOSHIBA A205", ALC268_TOSHIBA),
>> +       SND_PCI_QUIRK(0x1179, 0xff50, "TOSHIBA A305", ALC268_TOSHIBA),
>>         SND_PCI_QUIRK(0x103c, 0x30cc, "TOSHIBA", ALC268_TOSHIBA),
>>         SND_PCI_QUIRK(0x1025, 0x0126, "Acer", ALC268_ACER),
>>         SND_PCI_QUIRK(0x1025, 0x0130, "Acer Extensa 5210", ALC268_ACER),
> 
> Ah good.  I added it to ALSA HG tree now.

Just wondering: should easy-and-obvious and less-risky patches like this
one be send to the stable-kernel-maintainers in parallel to adding them
to the HG-Tree (or shortly afterwards)? It could safe users lots of
trouble if such improvements make it quickly into production-ready
kernel-releases (and from there they might even find their way into some
distribution kernels quickly). Hardware then would "just work".

Sure, before the stable-maintainer will take such patches they needs to
be added to linus git-tree beforehand as well. And sure, patches like
the one above are not fixing a regression (at least in this case if I
read the thread correctly; the old subject thus is misleading afaics),
but it's similar to a new PCI-ID that gets added to a existing driver --
and that's done now in the stable-series afaics (¹).

The alsa-maintainers seem to be in the best position to do this, but it
seems they rarely do it. I for example was hit by a regression (sound
worked in 2.6.20 and broke afterwards; was fixed in 2.6.23-git by the
following patch in case anybody is wondering:
http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a4eed138add1018846d17e813560b0c7c0ae8e01
), but the alsa-developers did not submit it for stable afaics. Sure, I
could do that myself, but as I said: the alsa-maintainers really have
the best overview over the alsa-patches and should know which patches
are safe to apply for older kernels.

CU
knurd

(¹) -- see for example
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.22.y.git;a=commit;h=fd2efeae63567dde934bb54772bb1b991275b04a
or
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.22.y.git;a=commit;h=3443d563dc53875b15d919c4bece391f1ffd4776
which made in into
http://kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.22.3
