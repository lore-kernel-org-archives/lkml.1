Return-Path: <linux-kernel-owner+w=401wt.eu-S932455AbXIEQ1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455AbXIEQ1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 12:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756799AbXIEQ0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 12:26:54 -0400
Received: from mail.computer-surgery.co.uk ([217.155.72.205]:1883 "EHLO
	nicole.computer-surgery.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756705AbXIEQ0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 12:26:53 -0400
Date: Wed, 5 Sep 2007 17:26:50 +0100
To: Takashi Iwai <tiwai@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jaroslav Kysela <perex@suse.cz>
Subject: Re: hda_intel : Patch + Regression in 2.6.18 -> 2.6.22
Message-ID: <20070905162650.GC31328@computer-surgery.co.uk>
References: <20070822222902.GA28563@computer-surgery.co.uk> <20070905083844.6637da1e.akpm@linux-foundation.org> <s5hlkbl6qsn.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hlkbl6qsn.wl%tiwai@suse.de>
X-GPG-Fingerprint: 72AF 0ACC 9A53 E59F B1B6  DC14 1983 A13E 5C3D 3CEB
X-GPG-Key: 1024D/5C3D3CEB (wwwkeys.uk.pgp.net)
X-Geo-Address: The Apple Barn, Maidstone Road, Pembury, Kent, TN2 4AD ,UK
X-Company: The Computer Surgery (Repair Centres) Ltd. No: 4180148
User-Agent: Mutt/1.5.9i
From: Roger Gammans <roger@computer-surgery.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for picking this up again Andew.

On Wed, Sep 05, 2007 at 06:05:44PM +0200, Takashi Iwai wrote:
> The patch would definitely break many other machines, so no, it can't
> be applied as is.  Note that there is an equivalent workaround by
> adding "model=auto" module option.

Ah, I hadn't spotted that.

> The support for Acer Aspire was already improved in mm tree.  At
> least, we have the support for Aspire 9810 and co.  If it's the
> compatible one, the chance is high.

Yes, I played a little with that, looking back at what Ive got 
here the following patch worked on what I pulled about
2weeks ago byi:-
 git pull git://git.kernel.org/pub/scm/linux/kernel/git/perex/alsa.git/
 

> Roger, could you try git-alsa patch in the latest mm together with
> model=acer-aspiore option?  If it works, I can easily add your device
> ID to the table.

I assume youe think of somehting like this which I tried earlier -
but would have been wasier if I'd have known about the mode option..

        SND_PCI_QUIRK(0x1462, 0xa422, "MSI", ALC883_TARGA_2ch_DIG),
        SND_PCI_QUIRK(0x1025, 0x006c, "Acer Aspire 9810", ALC883_ACER_ASPIRE),
        SND_PCI_QUIRK(0x1025, 0x0110, "Acer Aspire", ALC883_ACER_ASPIRE),
+       SND_PCI_QUIRK(0x1025, 0x0112, "Acer Aspire", ALC883_ACER_ASPIRE),
        SND_PCI_QUIRK(0x15d9, 0x8780, "Supermicro PDSBA", ALC883_3ST_6ch),
        SND_PCI_QUIRK(0x161f, 0x2054, "Medion laptop", ALC883_MEDION),

(Patch headers removed as patch manually editted  I appeat to got onto some on 
branch mode with git and it producing odd patches (ones with '++' at the start
 of some lines)) 

This does indeed work. I'm sorry I should have replied with this sooner, 
buts since it appeared noone was listening...

TTFN
-- 
Roger. 	                        Home| http://www.sandman.uklinux.net/
Master of Peng Shui.      (Ancient oriental art of Penguin Arranging)
Work|Independent Sys Consultant | http://www.computer-surgery.co.uk/
 New key Fpr: 72AF 0ACC 9A53 E59F B1B6  DC14 1983 A13E 5C3D 3CEB 
