Return-Path: <linux-kernel-owner+w=401wt.eu-S934098AbYETPYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934098AbYETPYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933693AbYETPWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:22:24 -0400
Received: from aun.it.uu.se ([130.238.12.36]:33422 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933077AbYETPWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:22:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18482.60491.764019.292031@harpo.it.uu.se>
Date: Tue, 20 May 2008 17:20:43 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, roland@redhat.com, drepper@redhat.com,
       Hongjiu.lu@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, rmk+lkml@arm.linux.org.uk, dan@debian.org,
       asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
In-Reply-To: <4832E705.2010900@zytor.com>
References: <20080513011030.GA31448@linux-os.sc.intel.com>
	<18477.35703.679574.760417@harpo.it.uu.se>
	<20080518013416.GB30034@linux-os.sc.intel.com>
	<18481.37905.297556.288317@harpo.it.uu.se>
	<20080520015723.GD30034@linux-os.sc.intel.com>
	<4832A173.6020203@firstfloor.org>
	<18482.53246.642835.894623@harpo.it.uu.se>
	<4832E705.2010900@zytor.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin writes:
 > Mikael Pettersson wrote:
 > >  > 
 > >  > Are they always zeroed in earlier CPUs though?  If not that wouldn't
 > >  > work 100% reliably because whatever cookie you put in could have been
 > >  > there before by chance.
 > > 
 > > I wrote a test program (fill an area with zeroes, fxsave, inspect
 > > reserved fields, then fill it with ones, fxsave, inspect again),
 > > and all processors appear to just not write anything to the reserved
 > > fields after the last xmm register. (Tested on an old Mobile Athlon64,
 > > Opteron 280, P4 Xeon, Pentium-D, and C2 Xeon E5345.)
 > > 
 > > So the question now is what if anything has the Linux kernel written
 > > to those reserved fields. (Looking..) Hmm, signal delivery on x86-64
 > > seems to do fxsave directly to the fxsave area in the user's sigframe,
 > > which would imply that the reserved fields have unpredictable values.
 > > 
 > 
 > OK, so that's not a usable path unless we can find some area in the 
 > existing data set to put a flag.  Groan.

An ugly workaround could be to start clearing one of these fields,
and say that the data there is only valid for kernels >= 2.6.26.
(I said it was ugly...)

Or we go back to stashing a flag in uc_flags (which is kosher),
and try to figure out how to mark non-rt sigframes.

/Mikael
