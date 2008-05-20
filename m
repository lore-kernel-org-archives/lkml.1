Return-Path: <linux-kernel-owner+w=401wt.eu-S1763290AbYETI7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763290AbYETI7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 04:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758857AbYETI7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 04:59:47 -0400
Received: from aun.it.uu.se ([130.238.12.36]:61350 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853AbYETI7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 04:59:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18482.37548.885708.24670@harpo.it.uu.se>
Date: Tue, 20 May 2008 10:58:20 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, andi@firstfloor.org, roland@redhat.com,
       drepper@redhat.com, Hongjiu.lu@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, rmk+lkml@arm.linux.org.uk, dan@debian.org,
       asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
In-Reply-To: <20080520015723.GD30034@linux-os.sc.intel.com>
References: <20080513011030.GA31448@linux-os.sc.intel.com>
	<18477.35703.679574.760417@harpo.it.uu.se>
	<20080518013416.GB30034@linux-os.sc.intel.com>
	<18481.37905.297556.288317@harpo.it.uu.se>
	<20080520015723.GD30034@linux-os.sc.intel.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha writes:
 > On Mon, May 19, 2008 at 04:52:01PM +0200, Mikael Pettersson wrote:
 > > > But we can
 > > >use some what similar magic, if the fxsave/fxrstor give away
 > > >some of the fields at the end of fxsave image (today it is reserved
 > > >and ignored during fxsave/fxrstor) for software use.
 > > >We can then use these fields at the end of fpstate, to indicate the presence of
 > > >xstate. But this requires some architecture changes like giving
 > > >away this space for SW use. We can take this to architects and
 > > >see what they think.
 > > 
 > > If the HW doesn't store anything valuable there, we could store
 > > SW flags/cookies there on signal delivery, and clear them before
 > > fxrstor (unless the HW is known to ignore those fields).
 > > But it depends on how forgiving the HW is.
 > 
 > Ok. CPU folks are planning to make some of the bytes at the end of fxsave
 > image, SW usable.

Nice.

 > We can use some of these fields, to represent the extended state
 > presence with a cookie, save area size, mask of the state
 > stored. If needed, we can include the start address of the fpstate pointer
 > (also as part of the cookie), so that we can detect the situation,
 > where apps are just memcopying sizeof(struct _fpstate) from the fpstate
 > pointer (but not aware of the extended state).

I use a similar technique to detect user-space mangling
of ucontexts on Solaris.

 > we don't need any ucontext_t extensions any more and just
 > use the fpstate pointer to indicate the extended state aswell, right?

Yes, the old magic distinguishes x87-only from x87+fxsr, the new magic
distinguishes fxsr from xsave.

 > In addition, we need to make sure that for 32bit non-rt sigframes, we
 > don't modify the extramask[] offset.

Thanks,

/Mikael
