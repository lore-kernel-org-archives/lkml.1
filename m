Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbYJVWqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbYJVWqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 18:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbYJVWqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 18:46:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45223 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbYJVWqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 18:46:43 -0400
Date: Thu, 23 Oct 2008 00:54:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alok Kataria <akataria@vmware.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH] Skip tsc synchronization checks if CONSTANT_TSC bit is set.
Message-ID: <20081022225409.GB27492@one.firstfloor.org>
References: <20081021174008.GH12825@one.firstfloor.org> <1224612294.6161.43.camel@alok-dev1> <20081021181536.GI12825@one.firstfloor.org> <1224616236.6161.60.camel@alok-dev1> <20081021192746.GJ12825@one.firstfloor.org> <1224703427.13953.8.camel@alok-dev1> <20081022195845.GP12825@one.firstfloor.org> <1224712846.13953.37.camel@alok-dev1> <20081022221316.GW12825@one.firstfloor.org> <1224713518.13953.46.camel@alok-dev1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224713518.13953.46.camel@alok-dev1>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Not really, there are problems with the pm timer too, the one about
> missing the counter wrap and time dropping in chunks of 4 seconds.
> Tried to explain it over here, http://lkml.org/lkml/2008/10/22/525

Well then pit. Or are you saying time is always broken on VMware & Linux?

> So TSC is the ideal clocksource from performance and correctness point
> of view for VMware. 

But you don't seem to emulate it "ideal"ly otherwise you wouldn't
need all these hacks you're adding? 

I think you should either implement a TSC that matches what
real hardware does (including CPUID semantics) or implement
a real vmware PV timer and just say it's PV and not fully virtualized. 
But doesn't the vmware paravirt ops have that already anyways?

But I personally think it wouldn't really scale to add detection for 
more and more "nearly PV" hypervisors to the standard native kernel.

-Andi
