Return-Path: <linux-kernel-owner+w=401wt.eu-S1754377AbXIYNGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbXIYNGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 09:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbXIYNGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 09:06:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34406 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbXIYNGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 09:06:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.23-rc8-mm1, -rc7-mm1 kill audio on HP nx6325
Date: Tue, 25 Sep 2007 15:20:09 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>
References: <200709251408.54361.rjw@sisk.pl> <1190722710.4035.320.camel@chaos>
In-Reply-To: <1190722710.4035.320.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709251520.09794.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 25 September 2007 14:18, Thomas Gleixner wrote:
> On Tue, 2007-09-25 at 14:08 +0200, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > This patch from Andi:
> > 
> > x86_64-mm-cpa-einval.patch
> > 
> > makes the hda_intel audio driver stop working on my HP nx6325.
> > 
> > The following line appears in dmesg (from 2.6.23-rc7-mm1:
> > 
> > ALSA /home/rafael/src/mm/linux-2.6.23-rc7-mm1/sound/pci/hda/hda_intel.c:1755: hd
> > a-intel: ioremap error
> > 
> > and the driver doesn't work afterwards.
> > 
> > Still, I'm not sure if the patch above is wrong or rather it exposes a problem
> > in the driver.
> 
> The patch is correct. Instead of returning "Success" in the case of a
> failure of lookup_address, it now returns -EINVAL, which in turn makes
> the ioremap fail.
> 
> OTOH, the driver ioremap call looks straight forward. Can you apply the
> patch below and provide the resulting debug output please ?

lookup failed for 18446604438082158592
[--snipped some USB messages--]
ALSA /home/rafael/src/mm/linux-2.6.23-rc8-mm1/sound/pci/hda/hda_intel.c:1756: hda-intel: ioremap error: 2349334528 16384

Greetings,
Rafael
