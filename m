Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151Ab0AEAG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab0AEAG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027Ab0AEAG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:06:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:14407 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002Ab0AEAG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:06:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,501,1257148800"; 
   d="scan'208";a="528429849"
Subject: Re: Subject: [PATCH 1/2] x86: get back 15 vectors
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       NetDEV list <netdev@vger.kernel.org>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
In-Reply-To: <4B42467F.5040008@zytor.com>
References: <4B347AEE.6030705@kernel.org> <20091228094707.GH24690@elte.hu>
	 <4B398ECD.1080506@kernel.org>
	 <4807377b1001031906s6b1ee576jc021da2642bb4147@mail.gmail.com>
	 <4B415E73.1050801@kernel.org> <4B419113.1090204@kernel.org>
	 <m1aawtlu6y.fsf@fess.ebiederm.org> <4B423B08.3010005@zytor.com>
	 <m1my0thelq.fsf@fess.ebiederm.org>  <4B424305.7050803@kernel.org>
	 <1262634353.2700.49.camel@sbs-t61.sc.intel.com>
	 <4B42467F.5040008@zytor.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 04 Jan 2010 16:05:44 -0800
Message-Id: <1262649945.2700.364.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-04 at 11:50 -0800, H. Peter Anvin wrote:
> On 01/04/2010 11:45 AM, Suresh Siddha wrote:
> > On Mon, 2010-01-04 at 11:35 -0800, Yinghai Lu wrote:
> >> sth like this?
> >>
> >> Subject: [PATCH 1/2] x86: get back 16 vectors
> >>
> >> -v2: according to hpa that we could start from 0x10
> >>      according to Eric, we should hold 16 vectors for IRQ MOVE
> >>
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >>
> > 
> > Yinghai we have to change IRQ_MOVE_CLEANUP_VECTOR to 0x1f or so. From
> > the cpu perspective this vector is documented as illegal, so we need to
> > check if this change will work on the cpu's we have today to get some
> > confidence.
> > 
> 
> It's documented as reserved, not illegal.  The ability for the APIC to
> generate vectors starting at 0x10 is documented, as is the ability for
> the CPU to receive any vector number as an interrupt -- in fact, the
> legacy BIOS relies on being able to receive interrupts starting at
> vector 0x08.  It causes problems galore, but only at the software level.

I have checked out couple of platforms (including 32-bit atom) and 0x1f
vector logic seems to be working.

Hopefully we won't have other hardware or software issues (vmm
restrictions etc) with this logic.

thanks,
suresh

