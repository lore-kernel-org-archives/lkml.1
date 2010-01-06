Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838Ab0AFMHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab0AFMHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 07:07:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755824Ab0AFMHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 07:07:08 -0500
Received: from smtp.nokia.com ([192.100.122.230]:30556 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799Ab0AFMHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 07:07:06 -0500
Subject: Re: sections mismatch detection
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B44762C.1090605@suse.cz>
References: <1262772683.4263.147.camel@localhost>
	 <20100106104823.GA30439@merkur.ravnborg.org>  <4B44762C.1090605@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jan 2010 14:04:49 +0200
Message-Id: <1262779489.3177.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 06 Jan 2010 12:04:53.0046 (UTC) FILETIME=[745EE560:01CA8EC8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-06 at 12:38 +0100, Michal Marek wrote:
> On 6.1.2010 11:48, Sam Ravnborg wrote:
> > On Wed, Jan 06, 2010 at 12:11:23PM +0200, Artem Bityutskiy wrote:
> >> Hi,
> >>
> >> I wonder is it good time to enable DEBUG_SECTION_MISMATCH by default
> >> now? I mean, remove the following from lib/Kconfig.debug:
> >>
> >> config DEBUG_SECTION_MISMATCH
> >>         bool "Enable full Section mismatch analysis"
> >>         depends on UNDEFINED
> >>         # This option is on purpose disabled for now.
> >>         # It will be enabled when we are down to a resonable number
> >>         # of section mismatch warnings (< 10 for an allyesconfig build)
> >>
> >> Just spotted this, and decided to remind.
> > 
> > My original criteria for enabling this was that we had a warnign free build
> > for all*config on x86 and a few other architectures.
> > While focusing on this I never reached this goal as I usually ended
> > up with some problems related to CPU hotplug.
> > I dunno how close we are today at the "zero warning" target.
> >
> ...
> > 
> > But I can see a steady flow of section mismatch fixes so I think the
> > situation looks better these days.
> 
> There is also steady flow of new code ;-). FWIW, a 2.6.32.2 x86 distro
> build shows 29 section mismatch warnings, 12 of these come from
> drivers/staging, the remaining are (duplicates removed):
> 
> WARNING: drivers/pci/built-in.o(.text+0x10a12): Section mismatch in
> reference from the function dmar_ir_support() to the variable
> .init.data:dmar_tbl
> WARNING: vmlinux.o(.devinit.text+0x3aa2): Section mismatch in reference
> from the function ezx_pcap_probe() to the function
> .init.text:set_irq_noprobe()
> WARNING: drivers/char/hw_random/virtio-rng.o(.data+0x44): Section
> mismatch in reference from the variable virtio_rng to the function
> .devexit.text:virtrng_remove()
> WARNING: drivers/scsi/hpsa.o(.text+0x192c): Section mismatch in
> reference from the function hpsa_pci_init() to the function
> .devinit.text:hpsa_interrupt_mode()
> WARNING: drivers/virtio/virtio_balloon.o(.data+0x44): Section mismatch
> in reference from the variable virtio_balloon to the function
> .devexit.text:virtballoon_remove()
> 
> I'll try a current mainline build with DEBUG_SECTION_MISMATCH=y to see
> if/how this changed.

I thought this option was there disabled by default for enough time. And
if we want to fix section mismatches some day, we should better enable
it by default. Otherwise high flow of new section mismatches will never
end.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

