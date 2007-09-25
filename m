Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639AbXIYOPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbXIYOPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 10:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbXIYOPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 10:15:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34786 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbXIYOPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 10:15:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.23-rc8-mm1, -rc7-mm1 kill audio on HP nx6325
Date: Tue, 25 Sep 2007 16:29:45 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>
References: <200709251408.54361.rjw@sisk.pl> <200709251520.09794.rjw@sisk.pl> <1190727843.4035.345.camel@chaos>
In-Reply-To: <1190727843.4035.345.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709251629.46493.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 25 September 2007 15:44, Thomas Gleixner wrote:
> On Tue, 2007-09-25 at 15:20 +0200, Rafael J. Wysocki wrote:
> > > The patch is correct. Instead of returning "Success" in the case of a
> > > failure of lookup_address, it now returns -EINVAL, which in turn makes
> > > the ioremap fail.
> > > 
> > > OTOH, the driver ioremap call looks straight forward. Can you apply the
> > > patch below and provide the resulting debug output please ?
> > 
> > lookup failed for 18446604438082158592
> > [--snipped some USB messages--]
> > ALSA /home/rafael/src/mm/linux-2.6.23-rc8-mm1/sound/pci/hda/hda_intel.c:1756: hda-intel: ioremap error: 2349334528 16384
> 
> Stupid me, hex formatting would have been easier to read :)
> 
> Lookup failed for 0xFFFF 8100 8C08 0000
> ioremap:          0x0000 0000 8C08 0000 length 16384
> 
> It seems, that this patch only reveals some other wreckage. The code is
> called as part of ioremap, where it adjusts the caching attributes of
> the mapping, which was setup right before change_page_attr_address() is
> called.

Hm, it looks like the first address is a kernel one and the second one is
physical, so they apparently match, which means that the lookup shouldn't fail,
if I understand this correctly.

Greetings,
Rafael
