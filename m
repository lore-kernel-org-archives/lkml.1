Return-Path: <linux-kernel-owner+w=401wt.eu-S1759129AbYDAXl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129AbYDAXl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 19:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755807AbYDAXlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 19:41:49 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:43238 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbYDAXls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 19:41:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=O3wp7VbAavBgtORJ0skLl8UmELn7wP1h66aJrd0piGId61upbECl7qCAFjdMMZmOzACBtQ0zm7X/WoSr8eqvLLp7ZJlbs7qVe1q7PHaran2ouvOHpyHfGwKgVdi1npbhcTfPohe5RU3MXCMjUyuGRtpwYCH3J2unWnxMtIIFIoM=
Message-ID: <47F2C8A2.3070303@keyaccess.nl>
Date: Wed, 02 Apr 2008 01:43:30 +0200
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 00/37] PNP resource_table cleanups, v2
References: <20080401151634.730901933@ldl.fc.hp.com>
In-Reply-To: <20080401151634.730901933@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
From: Rene Herman <rene.herman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01-04-08 17:16, Bjorn Helgaas wrote:

> This series of patches does some PNP housecleaning and
> consolidation.

Quite a series...

[patch 01/37] ISAPNP: move config register addresses out of isapnp.h

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 02/37] PNPACPI: continue after _CRS and _PRS errors

   No opinion.

[patch 03/37] PNP: make pnp_add_id() internal to PNP core

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 04/37] PNP: change pnp_add_id() to allocate its own pnp_id structures

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 05/37] PNP: add pnp_eisa_id_to_string()

   +void pnp_eisa_id_to_string(u32 id, char *str)
   +{
   +       id = be32_to_cpu(id);
   +       str[0] = '@' + ((id >> 26) & 0x1f);
   +       str[1] = '@' + ((id >> 21) & 0x1f);
   +       str[2] = '@' + ((id >> 16) & 0x1f);
   +       str[3] = hex_asc((id >> 12) & 0xf);
   +       str[4] = hex_asc((id >>  8) & 0xf);
   +       str[5] = hex_asc((id >>  4) & 0xf);
   +       str[6] = hex_asc((id >>  0) & 0xf);
   +       str[7] = '\0';
   +}

   I'd much prefer 'A' - 1 over '@'. While no doubt not a practical issue,
   it's more portable that way and more importantly, clearer.

   By the way, the original isapnp_parse_id explicitly encodes the top _6_
   bits in str[0] (& 0x3f) which seems odd. Bit 31 had better be 0 indeed,
   but I wonder why the original didn't just assume such.

   Other than that,

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 06/37] PNP: add pnp_alloc_dev()

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 07/37] PNP: make pnp_add_card_id() internal to PNP core

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 08/37] PNP: change pnp_add_card_id() to allocate its own pnp_id 
structures

   Same problem with hexadecimal as before. Bisection would get a bogus
   card id here, but fixed in 09/37.

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 09/37] ISAPNP: pull pnp_add_card_id() out of isapnp_parse_card_id()

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 10/37] PNP: add pnp_alloc_card()

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 11/37] PNPACPI: pnpacpi_encode_ext_irq() wrongly set "irq" instead of 
"extended_irq"

   No opinion.

[patch 12/37] PNPACPI: use temporaries to reduce repetition

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 13/37] PNPACPI: hoist dma_flags() out of 
pnpacpi_parse_allocated_dmaresource()

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 14/37] PNPACPI: extend irq_flags() to set IORESOURCE_IRQ_SHAREABLE 
when appropriate

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 15/37] PNPACPI: pass pnp_dev instead of acpi_handle

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 16/37] PNP: remove pnp_resource_table from internal get/set interfaces

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 17/37] PNP: remove more pnp_resource_table arguments

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 18/37] PNP: add pnp_init_resources(struct pnp_dev *) interface

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 19/37] PNP: remove pnp_resource_table from internal 
pnp_clean_resource_table interface

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 20/37] PNP: make generic pnp_add_irq_resource()

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 21/37] PNP: make generic pnp_add_dma_resource()

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 22/37] PNP: make generic pnp_add_io_resource()

   int pnp_add_io_resource(..., resource_size_t len, ...)
   {
         [ ... ]

         if (len <= 0 || end >= 0x10003) {

   len is a u32 or u64, so (len <= 0) == (len == 0)

   But:

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 23/37] PNP: make generic pnp_add_mem_resource()

   1: Same comment for pnp_add_mem_resource as 22/37

   2: There are 4 tests for ACPI_READ_WRITE_MEMORY here which are turned
      into IORESOURCE_MEM_WRITEABLE or 0. Not sure, but should they be
      turned into IORESOURCE_MEM_WRITEABLE or IORESOURCE_READONLY?

   Otherwise and if not,

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 24/37] PNP: use dev_printk when possible

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 25/37] PNPACPI: remove redundant warnings about _CRS/_PRS failures

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 26/37] PNPACPI: remove some pnp_dbg calls

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 27/37] PNP: use conventional "i" for loop indices

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 28/37] PNP: add pnp_get_resource() interface

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 29/37] PNP: convert encoders to use pnp_get_resource(), not 
pnp_resource_table

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 30/37] PNP: convert resource accessors to use pnp_get_resource(), not 
pnp_resource_table

   Is there a reason to not make pnp_{port,mem,irq,dma}_{start,end,flags}()
   inlines?

   static inline resource_size_t pnp_port_start(struct pnp_dev *dev,
                                                unsigned int bar)
   {
           struct resource *res = pnp_get_resource(dev, IORESOURCE_IO, bar);
           return res->start;
   }

   and so on.

   Also, you have pnp_{port,mem,irq,dma}_valid() returning a resource_size_t.
   They should return int, I presume.

[patch 31/37] PNP: convert resource checks to use pnp_get_resource(), not 
pnp_resource_table

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 32/37] PNP: convert resource assign functions to use 
pnp_get_resource(), not pnp_resource_table

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 33/37] PNP: remove PNP_MAX_* uses

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 34/37] PNP: remove unused interfaces using pnp_resource_table

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 35/37] rtc: dont reference pnp_resource_table directly

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 36/37] PNP: make pnp_resource_table private to PNP core

   Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 37/37] PNP: make interfaces private to the PNP core

   Acked-By: Rene Herman <rene.herman@gmail.com>

Rene.
