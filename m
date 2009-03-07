Return-Path: <linux-kernel-owner+w=401wt.eu-S1755716AbZCGRUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbZCGRUT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 12:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755417AbZCGRUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 12:20:06 -0500
Received: from main.gmane.org ([80.91.229.2]:45047 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755385AbZCGRUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 12:20:04 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Subject: [PATCH] Re: ALSA HDA Intel stoped to work in 2.6.16-*
Date: Sat, 07 Mar 2009 08:50:16 -0800
Message-ID: <gou8k9$reh$1@ger.gmane.org>
References: <87wtfhx7rm.fsf@nurf.casa> <s5hzmkcsv38.wl%tiwai@suse.de> <87slq3x3w1.fsf@nurf.casa> <s5hu0ajrbxv.wl%tiwai@suse.de> <87fym3w7m3.fsf@nurf.casa> <s5h3bi2a26o.wl%tiwai@suse.de> <8764mxiny5.fsf@nurf.casa> <s5h4q2fo0t4.wl%tiwai@suse.de> <87zmk6eq1t.fsf@nurf.casa> <20060304145114.GY9295@stusta.de> <s5hek1fmzf4.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: gimpelevich.san-francisco.ca.us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At Mon, 6 Mar 2006 15:16:15 +0100,
Takashi Iwai wrote:

> At Sat, 4 Mar 2006 15:51:14 +0100,
> Adrian Bunk wrote:
>> 
>> On Sat, Mar 04, 2006 at 02:29:02AM -0300, Otavio Salvador wrote:
>> > Takashi Iwai <tiwai@suse.de> writes:
>> > 
>> > > Are you sure that your device has PCI SUB-system id 8086:2668 ?
>> > 
>> > oh no! Sorry!
>> > 
>> > 0000:00:1b.0 0403: 8086:2668 (rev 04)
>> >         Subsystem: 152d:0729
>> >                    ^^^^^^^^^
>> 
>> Can you make a patch with the correct id test whether it fixes your 
>> problem (without model=basic)?
> 
> This one should work for his device.
> 
> 
> Takashi
> ===
> 
> [PATCH] Add default entry for CTL Travel Master U553W
> 
> Added the default entry of ALC880 configuration table for
> CTL Travel Master U553W.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> 
> ---
> diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
> index b767552..d5cd3a1 100644
> --- a/sound/pci/hda/patch_realtek.c
> +++ b/sound/pci/hda/patch_realtek.c
> @@ -2948,6 +2948,8 @@ static struct hda_board_config alc260_cf
>       { .modelname = "basic", .config = ALC260_BASIC },
>       { .pci_subvendor = 0x104d, .pci_subdevice = 0x81bb,
>         .config = ALC260_BASIC }, /* Sony VAIO */
> +     { .pci_subvendor = 0x152d, .pci_subdevice = 0x0729,
> +       .config = ALC260_BASIC }, /* CTL Travel Master U553W */
>       { .modelname = "hp", .config = ALC260_HP },
>       { .pci_subvendor = 0x103c, .pci_subdevice = 0x3010, .config = ALC260_HP },
>       { .pci_subvendor = 0x103c, .pci_subdevice = 0x3011, .config = ALC260_HP },

It has been three years since the above patch was posted with a request for
testing. No testing reply ever appeared, and the patch was committed as
submitted. On the relevant hardware, I determined the patch to be incorrect.
For the git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
head, the following patch appears to fix it correctly:


Signed-off-by: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 6c26afc..87ec806 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5692,7 +5692,7 @@ static struct snd_pci_quirk alc260_cfg_tbl[] = {
        SND_PCI_QUIRK(0x104d, 0x81cc, "Sony VAIO", ALC260_BASIC),
        SND_PCI_QUIRK(0x104d, 0x81cd, "Sony VAIO", ALC260_BASIC),
        SND_PCI_QUIRK(0x10cf, 0x1326, "Fujitsu S702X", ALC260_FUJITSU_S702X),
-       SND_PCI_QUIRK(0x152d, 0x0729, "CTL U553W", ALC260_BASIC),
+       SND_PCI_QUIRK(0x152d, 0x0729, "CTL U553W", ALC260_WILL),
        SND_PCI_QUIRK(0x161f, 0x2057, "Replacer 672V", ALC260_REPLACER_672V),
        SND_PCI_QUIRK(0x1631, 0xc017, "PB V7900", ALC260_WILL),
        {}

