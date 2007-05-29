Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbXE3Jjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbXE3Jjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 05:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbXE3JjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 05:39:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35084 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbXE3JjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 05:39:25 -0400
Date: Tue, 29 May 2007 16:58:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add a trivial patch style checker
Message-ID: <20070529145818.GB5024@one.firstfloor.org>
References: <9a1288909c10f2935af82ec5cea0c46b@pinky> <p738xb8fjv2.fsf@bingen.suse.de> <20070529115324.GB18437@osiris.boeblingen.de.ibm.com> <20070529131903.GA5024@one.firstfloor.org> <20070529142222.GC18437@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529142222.GC18437@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So you prefer random data corruption over an emergency stop?

With an oops you can at least recover the system and actually 
look at the problem. On a machine with a panic you're just dead
and the probability of actually being able to do something about the problem
is much lower. On x86 systems you typically don't even get 
any message out.

And I'm not convinced drivers are in a good position to decide
if memory was likely corrupted or not anyways. At least the
panics I see in driver sources seem to be just random logic
bugs from someone not familiar with BUG().

Also they typically don't make much attempt to figure out
if there might have been data corruption.

If you're really worried about memory corruption in drivers
you should just use an IOMMU.

> That doesn't make much sense to me...

So you're always setting panic_on_oops? 

-Andi

