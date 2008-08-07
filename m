Return-Path: <linux-kernel-owner+w=401wt.eu-S1756878AbYHGV5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbYHGV5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 17:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbYHGV5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 17:57:13 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:37269 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751344AbYHGV5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 17:57:13 -0400
Subject: Re: [PATCH]Fix broken VMI in 2.6.27-rc..
From: Zachary Amsden <zach@vmware.com>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Alok Kataria <akataria@vmware.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <489B6E83.7000202@kernel.org>
References: <1218136365.23770.52.camel@alok-dev1>
	 <489B6710.9000604@kernel.org>
	 <1218144438.20178.336.camel@bodhitayantram.eng.vmware.com>
	 <489B6A5C.8030400@kernel.org>
	 <1218145344.20178.347.camel@bodhitayantram.eng.vmware.com>
	 <489B6E83.7000202@kernel.org>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 14:55:54 -0700
Message-Id: <1218146154.20178.352.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-07 at 14:52 -0700, H. Peter Anvin wrote:
> Zachary Amsden wrote:
> >>>
> >> Okay, you lost me about halfway through that... could you perhaps
> >> describe the problem from the beginning, exactly what you're trying to do?
> >
> > A kernel compiled with VMI enabled may run on a non-VMI platform.  If
> > that is the case, the fixmap should not be relocated.  If however, a VMI
> > ROM is found, we need to hijack up to 64-MB of linear address space from
> > the top of memory down.  This means moving the fixmap down by the same
> > amount.
> >
> 
> I take it there are no alternatives other than putting this at the end
> of memory?

Nope, it must be in an area allowing for segmentation protection, while
keeping the kernel on zero-based segments; that means only the end of
linear address space is sufficient.


> Realistically speaking, any (virtual) machine which does *not* have a
> full complement of lowmem (i.e. less than 896 MB in the common case)
> will not suffer significatly from losing a few megabytes of address space.

Yes, the reason to make the fixmap moveable is to allow as much address
space as possible for big memory (physical) machines.

