Return-Path: <linux-kernel-owner+w=401wt.eu-S1753698AbXDWQnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbXDWQnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 12:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbXDWQnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 12:43:41 -0400
Received: from terminus.zytor.com ([192.83.249.54]:52227 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698AbXDWQnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 12:43:40 -0400
Message-ID: <462CE1E0.9060007@zytor.com>
Date: Mon, 23 Apr 2007 09:42:08 -0700
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
References: <20070414204154.871250608@goop.org>	<200704192250.52633.ak@suse.de> <4627D756.5020405@zytor.com>	<200704192304.01053.ak@suse.de> <4627DB0C.2010804@zytor.com>	<4627DDAD.4070805@redhat.com> <4627E099.209@goop.org> <m1d51vxxm4.fsf@ebiederm.dsl.xmission.com> <462CE027.4030302@goop.org>
In-Reply-To: <462CE027.4030302@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Eric W. Biederman wrote:
>> The only way to ensure this will not happen is to do what we do
>> on x86_64 and map the new page table page into our address space
>> before we write to it.  Assuming the page we allocate is already
>> mapped is simply not robust.
>>   
> 
> So you mean make alloc_bootmem make sure there's a mapping for the
> returned page?  That would be simple enough, though it might interact
> strangely with the actual construction of the memory mappings (what if
> the page alloc_bootmem just allocated for the pagetable is the page
> pagetable_init is actually trying to map?).
> 
> I'm not sure about the issue with holes.  I assume you mean that just
> because head.S maps a chunk of memory, it isn't necessarily available
> for allocation because its a hole.  But does alloc_bootmem know to avoid
> them anyway?  Has it already parsed e820 at that point?
> 

Since we allocate the maximum possible memory statically, I fail to see 
how holes could make the situation any worse, or better.

	-hpa
