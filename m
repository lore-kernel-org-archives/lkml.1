Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbZHMJks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbZHMJks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 05:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbZHMJks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 05:40:48 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:54521 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751512AbZHMJkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 05:40:47 -0400
Subject: Re: kmemleak: Protect the seq start/next/stop sequence
	byrcu_read_lock()
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090813065253.GC12143@elte.hu>
References: <20090812205215.GA21451@elte.hu>
	 <1250115375.11496.25.camel@pc1117.cambridge.arm.com>
	 <20090813065253.GC12143@elte.hu>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 13 Aug 2009 10:39:56 +0100
Message-Id: <1250156396.13180.24.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Aug 2009 09:39:57.0428 (UTC) FILETIME=[05116340:01CA1BFA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 08:52 +0200, Ingo Molnar wrote:
> * Catalin Marinas <catalin.marinas@arm.com> wrote:
> 
> > On Wed, 2009-08-12 at 21:52 +0100, Ingo Molnar wrote:
> > > * Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > 
> > > > kmemleak: Allow rescheduling during an object scanning
> > > 
> > > i tried this in -tip testing, and it crashes quickly:
> > > 
> > > [   81.900051] BUG: unable to handle kernel paging request at ffff880020000000
> > > [   81.901382] IP: [<ffffffff8112ae7e>] scan_block+0xee/0x190
> > 
> > It looks like my check for object->flags & OBJECT_ALLOCATED in 
> > scan_object() may not be enough.
> > 
> > I'm a bit confused as the config you sent says x86_32 but the 
> > fault address above looks like a 64 bit one (and my knowledge of 
> > x86 isn't great). Is this x86_64?
> 
> ahm indeed. It crashed not straight during bootup but while my tests 
> built the next kernel iteration already (with a new random config), 

Looking through the code and documentation, the fault address above
seems to be the directly mapped RAM. Do you have 512MB of RAM or less on
your machine? Or is there a hole in the virtual space at that point?

-- 
Catalin

