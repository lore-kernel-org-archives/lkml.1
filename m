Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbZERT7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbZERT7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 15:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbZERT7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 15:59:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57109 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbZERT7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 15:59:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Randy Dunlap <randy.dunlap@oracle.com>, Zorael <zorael@gmail.com>
Subject: Re: [i915] Kernel does not compile when set to use i915 kernel mode-setting per default (CONFIG_DRM_I915_KMS=y)
Date: Mon, 18 May 2009 21:59:12 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <fcd863fc0905181109h372e5967t9d179b820a62132d@mail.gmail.com> <200905182101.06511.rjw@sisk.pl> <20090518121140.d0bacafd.randy.dunlap@oracle.com>
In-Reply-To: <20090518121140.d0bacafd.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905182159.12575.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 May 2009, Randy Dunlap wrote:
> On Mon, 18 May 2009 21:01:06 +0200 Rafael J. Wysocki wrote:
> 
> > Adding CCs.
> > 
> > On Monday 18 May 2009, you wrote:
> > > (First post, so please CC to zorael@gmail.com in case it doesn't automatically.)
> > > 
> > > 
> > > I'm trying to compile 2.6.30-rc6 to enable kernel mode-setting *per
> > > default*, for my Intel 945GME video chipset. Alas, when compiling, it
> > > halts with the following tidbit:
> > > 
> > > ...
> > >   LD      .tmp_vmlinux1
> > > drivers/built-in.o: In function `intel_opregion_free':
> > > /usr/src/linux/drivers/gpu/drm/i915/i915_opregion.c:422: undefined
> > > reference to `acpi_video_exit'
> > > drivers/built-in.o: In function `intel_opregion_init':
> > > /usr/src/linux/drivers/gpu/drm/i915/i915_opregion.c:393: undefined
> > > reference to `acpi_video_register'
> > > make[1]: *** [.tmp_vmlinux1] Error 1
> > > make[1]: Leaving directory `/usr/src/linux-2.6.29'
> > > make: *** [debian/stamp/build/kernel] Error 2
> > > 
> > > 
> > > grepping acpi_video_register recursively I see it's defined as an
> > > empty function in ./include/acpi/video.h, and as a more proper
> > > function in ./drivers/acpi/video.c. Does somehow setting it to use KMS
> > > per default via CONFIG_DRM_I915_KMS=y stop it from reading those
> > > files?
> > > 
> > > I used to run with KMS by default in the early -30rc*s, but at some
> > > point (rc2?), it stopped compiling succesfully. If I don't enable it
> > > per default, it *does* compile, though I don't know how to explicitly
> > > enable it at boot-time. So I'm living without KMS for the time being.
> > > Woe.
> > > 
> > > Anything obvious I'm doing wrong?
> 
> 
> Len posted a patch for this.  It's below.
> Len, do you have this patch queued for Linus?

Ah, it's commit ecb4aed78dcf09e48c8c34c8c2fa7f5c69344be6, which went in
slightly after -rc6.  So it should be fixed.

Zorael, please test the current Linus' tree.

Thanks,
Rafael
