Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbXJ3SvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbXJ3SvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 14:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbXJ3SvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 14:51:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:50686 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933AbXJ3SvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 14:51:08 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: pci-disable-decode-of-io-memory-during-bar-sizing.patch
Date: Tue, 30 Oct 2007 19:50:58 +0100
User-Agent: KMail/1.9.6
Cc: Robert Hancock <hancockr@shaw.ca>, Greg KH <greg@kroah.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, akpm@linux-foundation.org,
       rajesh.shah@intel.com, linux-kernel <linux-kernel@vger.kernel.org>
References: <200708151919.l7FJJfUE010966@imap1.linux-foundation.org> <47267232.3020506@shaw.ca> <alpine.LFD.0.999.0710300811230.30120@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710300811230.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710301950.58519.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> At that point, almost all the issues with mmconfig just go away, BECAUSE 
> NOBODY USES IT, so it doesn't matter if it's broken?

We seem to slowly grow more uses of registers > 256, but yes it's still mostly 
non critical stuff.
 
> The fact is, CONF1 style accesses are just safer, and *work*. 
> 
> Can we please just do that? 

At least for the AMD GART IOMMU I would prefer if that was not done.
It has a pci config space access in a time critical path (flush).
And Family10h supports accessing the northbridge using mmconfig.

I believe the tigon3 driver also does config space access frequently
on some chips.

Also there are still the old x86 Macs where conf1 doesn't work.

-Andi
