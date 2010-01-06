Return-Path: <linux-kernel-owner+w=401wt.eu-S1755647Ab0AFLi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab0AFLi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 06:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755468Ab0AFLi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 06:38:27 -0500
Received: from cantor.suse.de ([195.135.220.2]:33568 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246Ab0AFLi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 06:38:26 -0500
Message-ID: <4B44762C.1090605@suse.cz>
Date: Wed, 06 Jan 2010 12:38:20 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sections mismatch detection
References: <1262772683.4263.147.camel@localhost> <20100106104823.GA30439@merkur.ravnborg.org>
In-Reply-To: <20100106104823.GA30439@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6.1.2010 11:48, Sam Ravnborg wrote:
> On Wed, Jan 06, 2010 at 12:11:23PM +0200, Artem Bityutskiy wrote:
>> Hi,
>>
>> I wonder is it good time to enable DEBUG_SECTION_MISMATCH by default
>> now? I mean, remove the following from lib/Kconfig.debug:
>>
>> config DEBUG_SECTION_MISMATCH
>>         bool "Enable full Section mismatch analysis"
>>         depends on UNDEFINED
>>         # This option is on purpose disabled for now.
>>         # It will be enabled when we are down to a resonable number
>>         # of section mismatch warnings (< 10 for an allyesconfig build)
>>
>> Just spotted this, and decided to remind.
> 
> My original criteria for enabling this was that we had a warnign free build
> for all*config on x86 and a few other architectures.
> While focusing on this I never reached this goal as I usually ended
> up with some problems related to CPU hotplug.
> I dunno how close we are today at the "zero warning" target.
>
...
> 
> But I can see a steady flow of section mismatch fixes so I think the
> situation looks better these days.

There is also steady flow of new code ;-). FWIW, a 2.6.32.2 x86 distro
build shows 29 section mismatch warnings, 12 of these come from
drivers/staging, the remaining are (duplicates removed):

WARNING: drivers/pci/built-in.o(.text+0x10a12): Section mismatch in
reference from the function dmar_ir_support() to the variable
.init.data:dmar_tbl
WARNING: vmlinux.o(.devinit.text+0x3aa2): Section mismatch in reference
from the function ezx_pcap_probe() to the function
.init.text:set_irq_noprobe()
WARNING: drivers/char/hw_random/virtio-rng.o(.data+0x44): Section
mismatch in reference from the variable virtio_rng to the function
.devexit.text:virtrng_remove()
WARNING: drivers/scsi/hpsa.o(.text+0x192c): Section mismatch in
reference from the function hpsa_pci_init() to the function
.devinit.text:hpsa_interrupt_mode()
WARNING: drivers/virtio/virtio_balloon.o(.data+0x44): Section mismatch
in reference from the variable virtio_balloon to the function
.devexit.text:virtballoon_remove()

I'll try a current mainline build with DEBUG_SECTION_MISMATCH=y to see
if/how this changed.

Michal
