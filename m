Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbYHGXN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbYHGXN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 19:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYHGXNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 19:13:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53986 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbYHGXNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 19:13:19 -0400
Message-ID: <489B8163.3070300@kernel.org>
Date: Thu, 07 Aug 2008 16:12:35 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Zachary Amsden <zach@vmware.com>, Alok Kataria <akataria@vmware.com>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix broken VMI in 2.6.27-rc..
References: <1218136365.23770.52.camel@alok-dev1>  <489B6710.9000604@kernel.org>  <1218144438.20178.336.camel@bodhitayantram.eng.vmware.com>  <489B6A5C.8030400@kernel.org>  <1218145344.20178.347.camel@bodhitayantram.eng.vmware.com>  <489B6E83.7000202@kernel.org> <1218146154.20178.352.camel@bodhitayantram.eng.vmware.com> <489B7470.5030408@kernel.org> <alpine.LFD.1.10.0808071533100.3462@nehalem.linux-foundation.org> <489B7DFE.5010402@kernel.org> <alpine.LFD.1.10.0808071603330.3462@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808071603330.3462@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 7 Aug 2008, H. Peter Anvin wrote:
>> Just moving it down by 4 MB doesn't help, since the VMI guys want as much as
>> 64 MB, which is half the standard vmalloc area and hence too much address
>> space lost.  We can't put it at the bottom of the vmalloc area, since that
>> boundary is not fixed, either.
> 
> Yeah, ok. Since this is a 32-bit only issue, 64MB is actually a fair chunk 
> of our already limited virtual space.
> 
>> The one remaining fixed boundary in the machine is the kernel-userspace
>> boundary.  Hence moving the 1:1 area up by one PDE unit and sticking the
>> fixmap area in that region.
> 
> Yeah, ok, but I'd be more nervous about the validation issues there. There 
> might be a lot of code that assumes that TASK_SIZE is the start of the 1:1 
> area. It does sound like a good approach, it just makes me worry about the 
> test coverage.
> 

Indeed.  Unfortunately I don't see any other options.

	-hpa
