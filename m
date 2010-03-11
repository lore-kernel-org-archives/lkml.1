Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934092Ab0CKSUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:20:34 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55340
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933558Ab0CKSUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:20:24 -0500
Date: Thu, 11 Mar 2010 10:20:43 -0800 (PST)
Message-Id: <20100311.102043.40590962.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: monstr@monstr.eu, gregkh@suse.de, benh@kernel.crashing.org,
       akpm@linux-foundation.org, sfr@canb.auug.org.au, jgarzik@pobox.com,
       ben-linux@fluff.org, dwmw2@infradead.org, jeremy.kerr@canonical.com,
       James.Bottomley@suse.de, broonie@opensource.wolfsonmicro.com,
       microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       linux-ide@vger.kernel.org, netdev@vger.kernel.org,
       linux-i2c@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
       linux-scsi@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 00/37] OF: move device node pointer into struct device.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100311174830.4824.19820.stgit@angua>
References: <20100311174830.4824.19820.stgit@angua>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 11 Mar 2010 11:03:47 -0700

> Currently on OF enabled platforms, the device node pointer is stored in
> both device.archdata.of_node (.prom_node on sparc), and in of_device.node
> OF device tree support is being generalized to work on any platform, so
> instead of adding the of_node pointer to each platform's archdata
> individually, this patch series moves the of_node pointer into struct
> device proper and fixes up all users to reference the new location.
> 
> The last 3 patches in this series remove the old .archdata.of_node,
> .archdata.prom_node and of_device.node instances.
> 
> This series has been compile tested on powerpc, sparc and microblaze,
> (allmodconfig used on sparc and powerpc) and boot tested on an mpc5200
> powerpc.  All known (or at least all I could find) in-tree users of the
> old names have been removed.

Three or four of the patches don't apply because only your tree
has those "/* temporary */" comments, f.e. in arch/sparc/kernel/pci.c

I took care of this when applying to my tree.

> This series should also be fully bisectable.  After I collect acks, I
> would like to get this whole series into linux-next to see if I've
> missed any references, but I can probably hold off merging the last
> three patches when the 2.6.35 merge window opens to give out of tree
> users a bit more time to adapt.  In fact, I'd probably wait a few
> extra days after pushing out the bulk of this series before I push the
> last 3 patches into my linux-next branch to isolate the drivers that I
> missed while fixing.

I'd rather you just apply the sparc one immediately in 2.6.35 and
not wait at all.

