Return-Path: <linux-kernel-owner+w=401wt.eu-S1161001AbXDWRXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161001AbXDWRXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 13:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161095AbXDWRXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 13:23:46 -0400
Received: from terminus.zytor.com ([192.83.249.54]:56055 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161001AbXDWRXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 13:23:45 -0400
Message-ID: <462CEB55.9070508@zytor.com>
Date: Mon, 23 Apr 2007 10:22:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Chuck Ebbert <cebbert@redhat.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 10/28] i386: map enough initial memory to create lowmem
 mappings
References: <20070414204154.871250608@goop.org>	<200704192250.52633.ak@suse.de> <4627D756.5020405@zytor.com>	<200704192304.01053.ak@suse.de> <4627DB0C.2010804@zytor.com>	<4627DDAD.4070805@redhat.com> <4627E099.209@goop.org> <m1d51vxxm4.fsf@ebiederm.dsl.xmission.com> <462CE027.4030302@goop.org> <462CE1E0.9060007@zytor.com> <462CE69E.8040207@goop.org>
In-Reply-To: <462CE69E.8040207@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>> Since we allocate the maximum possible memory statically, I fail to
>> see how holes could make the situation any worse, or better. 
> 
> No, we map enough space to map 4G (~4 pages), but we don't actually map
> 4G.  If a hole happened to start within that 4 page mapping, then the
> memory still wouldn't be available for allocation.
> 
> I think this is a bit of a spurious argument though, since if it were
> really a problem we'd have to worry about holes hitting the kernel image
> too.  As far as I can see, that's not considered to be a problem.
> 
> I think the real point is that there's currently a subtle dependency
> between head.S and bootmem allocation which happens between start_kernel
> and pagetable_init.  Your patch preventing over-mapping should make them
> easier to smoke out as it currently stands, but eliminating the problem
> by making alloc_bootmem create the mappings for itself does have
> appeal.  There would still be the dependency on head.S to map the kernel
> itself and the bootmem allocator bitmap.
> 

Agreed.  However, saying that your patch shouldn't go into the mainline 
kernel until that has been fixed is spurious and wrong.  It fixes a real 
problem with minimal risk.

	-hpa
