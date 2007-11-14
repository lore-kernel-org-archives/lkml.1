Return-Path: <linux-kernel-owner+w=401wt.eu-S1757852AbXKNOfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852AbXKNOfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 09:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbXKNOfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 09:35:37 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60086 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276AbXKNOfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 09:35:37 -0500
Date: Wed, 14 Nov 2007 15:35:33 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andi Kleen <andi@firstfloor.org>, Greg KH <greg@kroah.com>,
       Alex Chiang <achiang@hp.com>, gregkh@suse.de,
       kristen.c.accardi@intel.com, lenb@kernel.org, richard.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071114143533.GF17145@one.firstfloor.org>
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113170129.GA20185@kroah.com> <p73sl39y6qb.fsf@bingen.suse.de> <20071114141751.GS17785@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114141751.GS17785@parisc-linux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 07:17:51AM -0700, Matthew Wilcox wrote:
> On Wed, Nov 14, 2007 at 02:07:56AM +0100, Andi Kleen wrote:
> > It's not only complexity. Each new sysfs entry costs memory.
> > Memory is not free. There should be always a good reason for those.
> 
> It's not a lot of memory; it's one directory and a couple of files for
> each PCI slot in the system.  Even huge systems have maybe 200 slots.
> In order for this to take up as much as one page of ram on a typical PC
> with six slots, this would have to consume 680 bytes per directory.  I
> don't think sysfs is that inefficient (and if it is, maybe this feature
> is not where the problem is, given the 'power' directory per device, the
> 19 files per scsi device, the huge numbers of symlinks, etc).

It becomes much more when someone does a find /sys. dentries are 
expensive. They eventually can get pruned again, but it's still
costly to do that.

-Andi
