Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbYLJRO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbYLJRO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 12:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbYLJROS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 12:14:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41584 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753567AbYLJROR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 12:14:17 -0500
Date: Wed, 10 Dec 2008 09:13:30 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Frans Pop <elendil@planet.nl>, Ingo Molnar <mingo@elte.hu>,
       lenb@kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Greg KH <greg@kroah.com>, jbarnes@virtuousgeek.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: "APIC error on CPU1: 00(40)" during resume (was: Regression from
 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500)
In-Reply-To: <20081210165252.GA13041@srcf.ucam.org>
Message-ID: <alpine.LFD.2.00.0812100859520.3340@localhost.localdomain>
References: <200812020320.31876.rjw@sisk.pl> <200812101506.45691.elendil@planet.nl> <alpine.LFD.2.00.0812100740390.3340@localhost.localdomain> <200812101705.18899.elendil@planet.nl> <alpine.LFD.2.00.0812100819570.3340@localhost.localdomain>
 <20081210165252.GA13041@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 10 Dec 2008, Matthew Garrett wrote:

> On Wed, Dec 10, 2008 at 08:26:37AM -0800, Linus Torvalds wrote:
> 
> > So it looks like we don't reprogram the APIC -at-all- on secondary CPU's.
> > 
> > What am I missing?
> 
> We unplug all CPUs except the boot one at suspend time. Does the APIC 
> get reprogrammed when they're replugged on resume?

Ahh, indeed. That ends up doing setup_local_APIC() in smp_callin().

I wonder if we should do that from apic_resume() too - instead of saving 
any state we could probably just re-initialize it.

The setup_local_APIC() function also seems to be a lot more careful than 
"resume_apic()" is about ordering (well, at least it has _comments_ on the 
ordering), and it does things like ack'ing all pending irq's.

Hmm.

			Linus
