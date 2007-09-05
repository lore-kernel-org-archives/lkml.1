Return-Path: <linux-kernel-owner+w=401wt.eu-S1757858AbXIEPkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858AbXIEPkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 11:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756852AbXIEPk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 11:40:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40128 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756769AbXIEPk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 11:40:27 -0400
Date: Wed, 5 Sep 2007 08:38:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roger Gammans <roger@computer-surgery.co.uk>
Cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@suse.cz>,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: hda_intel : Patch + Regression in 2.6.18 -> 2.6.22
Message-Id: <20070905083844.6637da1e.akpm@linux-foundation.org>
In-Reply-To: <20070822222902.GA28563@computer-surgery.co.uk>
References: <20070822222902.GA28563@computer-surgery.co.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 22 Aug 2007 23:29:02 +0100 Roger Gammans <roger@computer-surgery.co.uk> wrote:
> Hi

A distinct regression, a confirmed fix, yet no reply after more than two weeks.

> I'm fighting a problem with my (new) Acer laptop.  (Aspire 9303)
> 
> In 2.6.18 the audio worked fine, but now I've upgraded to 2.6.22
> it has stopped working. 
> 
> I note that there is a acer specific quirk mode in patch_realtek.c
> enabled for all acer devices introduced in the timeframe. Disabling
> the quirk so that the driver uses it auot mode makes playback work
> fine again.
> 
> To be clear this pathc seems to work for me:-
> 
> --- /usr/src/linux-source-2.6.22/sound/pci/hda/patch_realtek.c 2007-07-09 00:32:17.000000000 +0100
> +++ linux-source-2.6.22/sound/pci/hda/patch_realtek.c   2007-08-20 22:21:37.000000000 +0100
> @@ -6392,7 +6392,7 @@
>         SND_PCI_QUIRK(0x1462, 0x4319, "MSI", ALC883_TARGA_DIG),
>         SND_PCI_QUIRK(0x1462, 0x4324, "MSI", ALC883_TARGA_DIG),
>         SND_PCI_QUIRK(0x1462, 0xa422, "MSI", ALC883_TARGA_2ch_DIG),
> -       SND_PCI_QUIRK(0x1025, 0, "Acer laptop", ALC883_ACER),
> +/*     SND_PCI_QUIRK(0x1025, 0, "Acer laptop", ALC883_ACER) , */
>         SND_PCI_QUIRK(0x15d9, 0x8780, "Supermicro PDSBA", ALC883_3ST_6ch),
>         SND_PCI_QUIRK(0x161f, 0x2054, "Medion laptop", ALC883_MEDION),
>         SND_PCI_QUIRK(0x1071, 0x8258, "Evesham Voyaeger", ALC883_LAPTOP_EAPD), 
> 
> 
> Unfortunately I think it's pretty clear it will break for others.
> 
> The lspci reports the following on the appropriate device:-
>   00:10.1 0403: 10de:026c (rev a2)
>         Subsystem: 1025:0112
>         Flags: 66MHz, fast devsel, IRQ 19
>         Memory at c0000000 (32-bit, non-prefetchable) [size=16K]
>         Capabilities: <access denied>
> 

Jaroslav, Takashi: can you please comment on this?

Thanks.
