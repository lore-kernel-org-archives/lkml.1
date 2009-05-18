Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302AbZERTL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbZERTL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 15:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbZERTLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 15:11:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44002 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbZERTLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 15:11:05 -0400
Subject: Re: [i915] Kernel does not compile when set to use i915 kernel
 mode-setting per default (CONFIG_DRM_I915_KMS=y)
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Zorael <zorael@gmail.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200905182101.06511.rjw@sisk.pl>
References: <fcd863fc0905181109h372e5967t9d179b820a62132d@mail.gmail.com>
	 <200905182101.06511.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 18 May 2009 21:10:36 +0200
Message-Id: <1242673836.32543.1288.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-18 at 21:01 +0200, Rafael J. Wysocki wrote:
> Adding CCs.
> 
> On Monday 18 May 2009, you wrote:
> > (First post, so please CC to zorael@gmail.com in case it doesn't automatically.)
> > 
> > 
> > I'm trying to compile 2.6.30-rc6 to enable kernel mode-setting *per
> > default*, for my Intel 945GME video chipset. Alas, when compiling, it
> > halts with the following tidbit:
> > 
> > ...
> >   LD      .tmp_vmlinux1
> > drivers/built-in.o: In function `intel_opregion_free':
> > /usr/src/linux/drivers/gpu/drm/i915/i915_opregion.c:422: undefined
> > reference to `acpi_video_exit'
> > drivers/built-in.o: In function `intel_opregion_init':
> > /usr/src/linux/drivers/gpu/drm/i915/i915_opregion.c:393: undefined
> > reference to `acpi_video_register'
> > make[1]: *** [.tmp_vmlinux1] Error 1
> > make[1]: Leaving directory `/usr/src/linux-2.6.29'
> > make: *** [debian/stamp/build/kernel] Error 2
> > 
> > 
> > grepping acpi_video_register recursively I see it's defined as an
> > empty function in ./include/acpi/video.h, and as a more proper
> > function in ./drivers/acpi/video.c. Does somehow setting it to use KMS
> > per default via CONFIG_DRM_I915_KMS=y stop it from reading those
> > files?
> > 
> > I used to run with KMS by default in the early -30rc*s, but at some
> > point (rc2?), it stopped compiling succesfully. If I don't enable it
> > per default, it *does* compile, though I don't know how to explicitly
> > enable it at boot-time. So I'm living without KMS for the time being.
> > Woe.
> > 
> > Anything obvious I'm doing wrong?

CONFIG_ACPI_VIDEO=y IIRC, Kconfig should be fixed, and I seem to
remember seeing patch fly by.

