Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbYF1Egm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbYF1Egm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 00:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbYF1Egc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 00:36:32 -0400
Received: from vms044pub.verizon.net ([206.46.252.44]:45087 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbYF1Ega (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 00:36:30 -0400
Date: Sat, 28 Jun 2008 00:36:17 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [patch 00/28] PNP: convert fixed tables to lists, v4
In-reply-to: <20080627225651.663174474@ldl.fc.hp.com>
X-X-Sender: lenb@localhost.localdomain
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>,
       Jiri Slaby <jirislaby@gmail.com>, David Howells <dhowells@redhat.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Message-id: <alpine.LFD.1.10.0806280035490.14731@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20080627225651.663174474@ldl.fc.hp.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


v4 has replaced v3 in the acpi-test tree.

thanks,
-Len

On Fri, 27 Jun 2008, Bjorn Helgaas wrote:

> This patch series contains all my PNP patches that are not yet in Linus'
> tree, including both the "convert resource table to dynamic list" series
> and the "convert resource options to unified dynamic list" series.
> 
> This fixes all checkpatch warnings except a "do not add new typedefs"
> warning.  I kept the pnp_irq_mask_t typedef because I don't see a
> better way to declare bitmaps in various places and pass around pointers
> to them.
> 
> Len, I told you I was going to send incremental patches, but this is
> a replacement instead.
> 
> Changes since v3:
> 
>     - Move IRQ test from pnpacpi_parse_irq_option() to
>       pnpacpi_parse_ext_irq_option() (fixes "comparison is always true"
>       warning noticed by David Howells)
>     - Use pci_get_legacy_ide_irq(), not ATA_PRIMARY_IRQ()/ATA_SECONDARY_IRQ()
>       (thanks to Bartlomiej Zolnierkiewicz)
>     - Use snprintf() to make printks atomic
>     - Fix checkpatch warnings (line length, "//" comments)
> 
> Here are the significant changes since the last posting:
> 
>     - When replacing pnp_resource_table, the PNPACPI resource encoders
>       have to explicitly handle disabled resources; previously any
>       unused slots in the table were implicitly disabled.  This should
>       fix Jiri Slaby's oops on suspend/resume (though he hasn't tested
>       this version).
>       
>       This change is in the patch titled "PNP: replace pnp_resource_table
>       with dynamically allocated resources".
>       
>     - Added a new patch to keep disabled IRQ and DMA resources when parsing
>       current config.  This fixes a bug in the current (2.6.25) PNPACPI
>       code: consider a device with (mem, irq0, irq1, io), where irq0 is
>       disabled.  If we drop irq0 when parsing the _CRS, we will mistakenly
>       put irq1 in the irq0 slot when we encode resources for an _SRS call.
> 
>     - Added a new patch to avoid interrupts used by an IDE controller in
>       compatibility mode.  https://bugzilla.novell.com/show_bug.cgi?id=375836
> 
>     - Added a new PNPACPI patch to support HP vendor-specific descriptors.
>       This has long been supported by arch/ia64/kernel/acpi-ext.c, which
>       provides an hp_acpi_csr_space() interface, but I think it's better
>       and more generic to support it in PNPACPI.
> 
> Changes since v2 of "convert resource options to unified dynamic list":
> 
>     - fixed bisection problem in quirk_ad1815_mpu_resources()
>     - fixed checkpatch warning in pnp_show_options()
>       (pnp-convert-resource-options-to-single-linked-list-checkpatch-fixes.patch)
>     - replaced pnp_independent_option() with literal 0
>     - fixed coding style in pnp/manager.c
>     - added EXPORT_SYMBOL(pnp_possible_config)
>       (pnp-add-pnp_possible_config-can-a-device-could-be-configured-this-way-fix.patch)
> 
> Bjorn
> -- 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
