Return-Path: <linux-kernel-owner+w=401wt.eu-S1758228AbZDNRv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228AbZDNRv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbZDNRvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:51:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51582 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844AbZDNRvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:51:43 -0400
Date: Tue, 14 Apr 2009 19:54:33 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mark Lord <lkml@rtr.ca>
Cc: Andi Kleen <andi@firstfloor.org>,
       Anton Ertl <anton@mips.complang.tuwien.ac.at>,
       linux-kernel@vger.kernel.org
Subject: Re: Out-of-order writing by disk drives
Message-ID: <20090414175433.GY14687@one.firstfloor.org>
References: <87r5zv72cl.fsf@basil.nowhere.org> <E1Ltla2-0000bS-5j@a4.complang.tuwien.ac.at> <20090414172406.GX14687@one.firstfloor.org> <49E4CA75.902@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E4CA75.902@rtr.ca>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Does anyone else here find this rather peculiar?
> 
> The folks who actually care about barriers the most
> (apart from kernel developers) are probably enterprise users.
> 
> And who is most likely to be using RAID and LVM,
> where barriers generally don't work at all ?

The big enterprise users often have a SAN, so the LVM/RAID part is 
hidden somewhere between a block device, together with a lot of 
battery backed cache RAM (so that even running uncached is not too bad)
But on the other hand they also have UPSes, so data loss on power failure
might be not that big a problem for them.

Where I see it as a problem is with virtualization; LVM seems to be the
most sane way to manage file systems for lots of VMs and you likely
want barriers there too.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
