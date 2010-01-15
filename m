Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab0AOCCA (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 21:02:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077Ab0AOCB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 21:01:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:15707 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556Ab0AOCB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 21:01:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,279,1262592000"; 
   d="scan'208";a="587308328"
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "dmarkh@cfl.rr.com" <dmarkh@cfl.rr.com>
Cc: "markh@compro.net" <markh@compro.net>, Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alain Knaff <alain@knaff.lu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "fdutils@fdutils.linux.lu" <fdutils@fdutils.linux.lu>,
        "Li, Shaohua" <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4B4C3B1A.50906@cfl.rr.com>
References: <alpine.LFD.2.00.0912220922250.31313@localhost.localdomain>
	 <4B310879.9050701@compro.net>
	 <1261525076.16916.4.camel@localhost.localdomain>
	 <4B3162BC.9000508@cfl.rr.com> <4B3214EC.6020308@compro.net>
	 <6598A4E21F1DB24D80BF72956484F59802EFD1C6@orsmsx001.amr.corp.intel.com>
	 <4B32386B.2060509@compro.net>
	 <alpine.LFD.2.00.0912230828230.6879@localhost.localdomain>
	 <87bphpd4rt.fsf@basil.nowhere.org> <4B32565E.6000501@compro.net>
	 <20091223191806.GA3336@linux-os.sc.intel.com> <4B3270FE.5090607@compro.net>
	 <1261600243.16916.56.camel@localhost.localdomain>
	 <4B476E8D.1030308@compro.net>
	 <1263255557.16916.132.camel@localhost.localdomain>
	 <4B4C3B1A.50906@cfl.rr.com>
Content-Type: text/plain
Date: Thu, 14 Jan 2010 18:01:57 -0800
Message-Id: <1263520917.16916.171.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-12 at 01:04 -0800, Mark Hounschell wrote:
> On 01/11/2010 07:19 PM, Pallipadi, Venkatesh wrote:
> > 
> > Sorry for not following up on this. We have narrowed this down to HPET
> > MSI and floppy DMA. I still don't know how HPET MSI interrupts are
> > breaking floppy DMA.
> > 
> > You are seeing the problem on two different systems. Correct? Do you
> > have any system where this works with HPET MSI enabled?
> > 
> 
> I see the problem on every system in which the HPET2 shows up in
> /proc/interrupts. The machines that work with HPET enabled don't show HPET
> at all in /proc/interrupts.  I have some of each. All the boxes that fail
> here use the (AMD) 790x series chip sets.
> 
> > Couple of options on how we can go about this one:
> > 1) Change the HPET-MSI change to not get activated when there are no
> > C-states with LAPIC stoppage involved. This will resolve the problem on
> > the systems you reported as there are no deep C-states. But, I fear that
> > with the actual problem unresolved, we may hit it in future with this or
> > some other platform having same issue with CPUs that support deep
> > C-state.
> > 2) Try this testcase on few other platforms that support HPET-MSI and
> > deep C-states and check how widespread the problem is and then add a
> > whitelist-blacklist for HPET MSI usage.
> > 
> > I think, for 2.6.33 option 1 is better. Will work on that and send in
> > patches for you test.
> > 
> 

Mark,

I just sent out a patchset that should workaround the problem here. Can
you check and let me know whether thats the case.

We will still need a simpler/smaller workaround for .33. Will send a
patch for that soon.

Also, are you testing this with usb floppy controller? I tried to test
it on my end, but fdformat doesn't seem to like my usb floppy drive. I
tried, 'ufiformat -f 1440 <dev>', with which I am not able to reproduce
the failure on any of my boxes. Not sure whether that really means I
don't hit this bug or that is going through totally different code path.

Thanks,
Venki
 

