Return-Path: <linux-kernel-owner+w=401wt.eu-S1761841AbYETRxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761841AbYETRxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 13:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756397AbYETRx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 13:53:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:45226 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755549AbYETRxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 13:53:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,516,1204531200"; 
   d="scan'208";a="566717466"
Date: Tue, 20 May 2008 10:53:25 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, roland@redhat.com, drepper@redhat.com,
       Hongjiu.lu@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, rmk+lkml@arm.linux.org.uk, dan@debian.org,
       asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
Message-ID: <20080520175325.GE30034@linux-os.sc.intel.com>
References: <20080513011030.GA31448@linux-os.sc.intel.com> <18477.35703.679574.760417@harpo.it.uu.se> <20080518013416.GB30034@linux-os.sc.intel.com> <18481.37905.297556.288317@harpo.it.uu.se> <20080520015723.GD30034@linux-os.sc.intel.com> <4832A173.6020203@firstfloor.org> <18482.53246.642835.894623@harpo.it.uu.se> <4832E705.2010900@zytor.com> <18482.60491.764019.292031@harpo.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18482.60491.764019.292031@harpo.it.uu.se>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 05:20:43PM +0200, Mikael Pettersson wrote:
> H. Peter Anvin writes:
>  > Mikael Pettersson wrote:
>  > > So the question now is what if anything has the Linux kernel written
>  > > to those reserved fields. (Looking..) Hmm, signal delivery on x86-64
>  > > seems to do fxsave directly to the fxsave area in the user's sigframe,
>  > > which would imply that the reserved fields have unpredictable values.
>  > > 
>  > 
>  > OK, so that's not a usable path unless we can find some area in the 
>  > existing data set to put a flag.  Groan.
> 
> An ugly workaround could be to start clearing one of these fields,
> and say that the data there is only valid for kernels >= 2.6.26.
> (I said it was ugly...)
> 
> Or we go back to stashing a flag in uc_flags (which is kosher),
> and try to figure out how to mark non-rt sigframes.

This issue of not-zeroing, is present in only 64bit kernels and for 64bit apps,
right?

64bit app signal handling uses only rt_frame, so we can add an uc_flag for
them and for 32bit apps, kernel was always zero'ing the reserved bits
at the end of _fpstate.

In short, for non-rt frames, they can check the reserved bits at the end
of fpstate frame and for rt-frames (perhaps even for 32bit rt frame handling)
apps can check for uc_flag aswell, for extended state presence. Is this
good enough?

thanks,
suresh
