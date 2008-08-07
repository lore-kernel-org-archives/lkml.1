Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbYHGV2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbYHGV2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 17:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYHGV2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 17:28:40 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:36260 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901AbYHGV2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 17:28:40 -0400
Subject: Re: [PATCH]Fix broken VMI in 2.6.27-rc..
From: Zachary Amsden <zach@vmware.com>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Alok Kataria <akataria@vmware.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <489B6710.9000604@kernel.org>
References: <1218136365.23770.52.camel@alok-dev1>
	 <489B6710.9000604@kernel.org>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 14:27:18 -0700
Message-Id: <1218144438.20178.336.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-07 at 14:20 -0700, H. Peter Anvin wrote:
> Alok Kataria wrote:
> >
> > VMI relies on relocating the fixmap area to make room for the
> > hypervisor. These 2 commits started accessing the fixmap area's and
> > using them before VMI got a chance to check if it wants to relocate the
> > fixmap area. Once VMI got to the point of relocating the fixmap area's
> > it resulted in BUG's.
> >
> 
> Could you describe this in more detail?  I am not super-happy about this
> solution if there is a better one, like simply locating the fixmap area
> out of the way to start with.

That can't be done until we know the size of the hole to relocate, which
isn't known until we probe in the first meg of memory to find the
associated ROM.  It used to be the case that other things that poked
around with platform specific memory and checking ROM areas lived around
here in setup.c, so it was a nice place to put it.  With all the
abstraction and combination and overifdeffing going on here, that might
no longer be the case.

We could move it earlier, but then we'd need another hook to call in
after max_low_pfn is known.

Or we could remove the dependency on max_low_pfn and just create a
liberal linear to physical mapping for lomem which spans all possible
low memory; then it doesn't matter so much where it is called.

Zach

