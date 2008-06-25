Return-Path: <linux-kernel-owner+w=401wt.eu-S1756329AbYFYFBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329AbYFYFBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 01:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbYFYFBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 01:01:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43356 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbYFYFBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 01:01:41 -0400
Message-ID: <4861D10F.2010308@zytor.com>
Date: Tue, 24 Jun 2008 22:01:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Paul Jackson <pj@sgi.com>, yhlu.kernel@gmail.com,
       akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       steiner@sgi.com, travis@sgi.com, linux-kernel@vger.kernel.org,
       ying.huang@intel.com, andi@firstfloor.org
Subject: Re: [PATCH 4/5 v2] x86 boot: show pfn addresses in hex not decimal
 in some kernel info printks
References: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com> <20080622142212.5591.64592.sendpatchset@polaris-admin.engr.sgi.com> <86802c440806221238g78300952t2fc7f406c1842273@mail.gmail.com> <20080623060939.6b6b3183.pj@sgi.com> <86802c440806241429s7f5e899dn67d42303247f618@mail.gmail.com> <20080624203252.f932c631.pj@sgi.com> <4861A5DF.5010104@zytor.com> <20080624211711.8c6d5105.pj@sgi.com> <4861AAEF.3020103@zytor.com> <alpine.LFD.1.10.0806241949030.13106@hp.linux-foundation.org> <20080624220810.b2ec0c6a.pj@sgi.com> <alpine.LFD.1.10.0806242101460.20369@hp.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806242101460.20369@hp.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 24 Jun 2008, Paul Jackson wrote:
>> I'd be inclined instead to use "%P" for symbolic addrs.
> 
> That doesn't work - gcc warns about it.
> 
> That turns out to be a problem with %#p too. 
> 
> It's really irritating how we cannot extend on the printk strings without 
> either having to throw out gcc warnings altogether. gcc has no extension 
> mechanism to the built-in rules ;/
> 
> The format warnings are too useful to drop entirely. I guess sparse could 
> be taught to do them, and then we could drop the gcc support for them. But 
> that would still limit coverage a _lot_.
> 

Any reason we can't just re-define %p to print the 0x prefix, just as 
glibc does?  It'd be easy enough to go and sed out all the 0x%p's 
currently in the kernel.

	-hpa
