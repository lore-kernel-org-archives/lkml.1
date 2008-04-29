Return-Path: <linux-kernel-owner+w=401wt.eu-S1759036AbYD2Ijm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036AbYD2Ijm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 04:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbYD2Ija
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 04:39:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:57490 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991AbYD2Ij1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 04:39:27 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [patch 00/55] PNP cleanup, v5
Date: Tue, 29 Apr 2008 04:38:00 -0400
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adam Belay <ambx1@neo.rr.com>, Adam M Belay <abelay@mit.edu>,
       Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080428223347.233593713@ldl.fc.hp.com>
In-Reply-To: <20080428223347.233593713@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804290438.00657.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn,
I'm running this version on my primary development machine,
and I've pulled it into the acpi tree a few minutes ago.

thanks,
-Len

On Monday 28 April 2008, Bjorn Helgaas wrote:
> I'm trying to stabilize something so we can get it into -mm, 
> so this only addresses Rene's comments on v4. 
> 
> As a reminder, if anybody tests this and sees problems, the
> dmesg log with CONFIG_PNP_DEBUG enabled would be a great help
> to me.
> 
> Changes between v4 and v5:
> 
>   - moved #ifdef DEBUG inside dbg_pnp_show_resources()
>   - removed cast of flags to int; print the long directly
>   - changed printk "0x%x" to "%#x"
>   - set "type" in pnp_clean_resource_table()
>   - fix return type of pnp_{port,mem,irq,dma}_flags()
>   - new patch converts pnp_assign_*() and /sys interfaces to pnp_get_resource()
>   - added Rene's acks
> 
> Changes between v3 and v4:
> 
>   - changed pnp_check_port(), etc., to take resource instead of index
>   - added some decoder/encoder/assign debug output (under CONFIG_PNP_DEBUG)
>   - fixed some ISAPNP register index bisectability problems
>   - removed the list-based resource management (will work on that separately)
> 
> Changes between v2 and v3:
> 
>   - several updates from Rene Herman's review:
> 	- tweak EISA ID conversion and keep high-order bit for ISAPNP
> 	- fix pnp_add_card_id() so bisection works better
> 	- fix some "x <= 0" tests when x is unsigned
> 	- make resource accessors inlines, not #defines
> 	- fix pnp_{port,mem,irq,dma}_valid() return int, not resource_size_t
> 	- fold isapnp_read_resources() back into isapnp_get_resources()
>   - factored out pnp_init_resource() from pnp_{init,clean}_resource_table()
>   - initialize generic pnp_dev fields earlier, to help dev_printk
>   - add pnp_resource to hold ISAPNP register index
>   - convert to resource management from table to list (finally)
>   - remove pnp_dev->regs (only set by ISAPNP, never used)
>   - in /sys/.../resources, don't sort resources by type
> 
> Changes between first post and v2:
> 
>   - export pnp_get_resource()
>   - fix EISA ID conversion and make a common function for ISAPNP/PNPBIOS
>   - fix typos in pnp_check_{port,mem,etc} that made resource assign fail
> 
>   - the following fixes should precede this series (they're in -mm already):
> 	- parport_pc: wrap PNP probe code in CONFIG_PNP
> 	- radio-cadet: wrap PNP probe code in CONFIG_PNP
> 	- smsc-ircc2: wrap PNP probe code in CONFIG_PNP
> 	- nsc-ircc: wrap PNP probe code in CONFIG_PNP
> 
> Bjorn
> 


