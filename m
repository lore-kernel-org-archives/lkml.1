Return-Path: <linux-kernel-owner+w=401wt.eu-S1754225AbYGZBQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbYGZBQ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 21:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbYGZBQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 21:16:20 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:36542 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbYGZBQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 21:16:20 -0400
Date: Fri, 25 Jul 2008 19:16:00 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>, Alex Chiang <achiang@hp.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       Kristen Accardi <kristen.c.accardi@intel.com>
Subject: Re: post 2.6.26 requires pciehp_slot_with_bus
Message-ID: <20080726011600.GA19079@parisc-linux.org>
References: <20080724134737.4b91f30d@mjolnir.drzeus.cx> <20080725012916.06679a6d@mjolnir.drzeus.cx> <48895BA1.1030606@jp.fujitsu.com> <200807251518.53462.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807251518.53462.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 03:18:53PM -0700, Jesse Barnes wrote:
> I think that's fine (automatically creating duplicate devices with names to 
> differentiate them), but I think we should also try harder to avoid adding 
> duplicates.
> 
> In Pierre's case, and on my T61, there's only one actual hotplug slot 
> available, but the firmware creates duplicate physical slot numbers and sets 
> the HP_CAP bit on everything, both of which are obviously wrong (well I 
> suppose you could pop these chips off the board, but it's not very 
> practical).  However, afaict that "other" OS uses the _RMV method to 
> determine whether a given slot is actually hot pluggable.  On my T61 at 
> least, this seems to be accurate: only one of my EXP* objects has a _RMV 
> method.

I think you're getting distracted from the real problem we're trying to
solve here, the reason for introducing the pci_slot driver in the first
place: we want to have information on all slots, not just hotplug ones.

So while this is growing out of the hotplug system, we need to register
all slots, even ones without _RMV.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
