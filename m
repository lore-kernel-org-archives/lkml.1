Return-Path: <linux-kernel-owner+w=401wt.eu-S1758975AbXKMRFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975AbXKMRFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 12:05:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbXKMRFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 12:05:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55622 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbXKMRFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 12:05:09 -0500
Date: Tue, 13 Nov 2007 09:01:29 -0800
From: Greg KH <greg@kroah.com>
To: Alex Chiang <achiang@hp.com>
Cc: gregkh@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org,
       matthew@wil.cx, richard.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071113170129.GA20185@kroah.com>
References: <20071113000853.GA13341@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113000853.GA13341@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 05:08:53PM -0700, Alex Chiang wrote:
> Hello,
> 
> [this patch series touches a few subsystems; hopefully I got all
> the right maintainers]
> 
> Recently, Matthew Wilcox sent out the following mail about PCI
> slots:
> 
>   http://marc.info/?l=linux-pci&m=119432330418980&w=2
> 
> The following patch series is a rough first cut at implementing
> the ideas he outlined, namely, that PCI slots are physical
> objects that we care about, independent of their hotplug
> capabilities.

I'm still not sold on this idea at all.  I'm really betting that there
is a lot of incorrect acpi slot information floating around in machines
and odd things will show up in these slot entries.

I say this because for a long time there was no "standard" acpi entries
for hotplug slots and different companies did different things.  Hence
the "odd" IBM acpi hotplug implementation as one example.  If this is
going to go anywhere, you need to get IBM to agree that it works
properly with all their machines...

Also, some companies already provide userspace tools to get all of this
information about the different slots in a system and what is where,
from userspace, no kernel changes are needed.  So, why add all this
extra complexity to the kernel if it is not needed?

thanks,

greg k-h
