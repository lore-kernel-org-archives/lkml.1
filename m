Return-Path: <linux-kernel-owner+w=401wt.eu-S1758454AbYFYPfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758454AbYFYPfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 11:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYFYPfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 11:35:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56801 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbYFYPfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 11:35:23 -0400
Message-ID: <48626460.1000905@zytor.com>
Date: Wed, 25 Jun 2008 08:29:36 -0700
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
References: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com> <20080622142212.5591.64592.sendpatchset@polaris-admin.engr.sgi.com> <86802c440806221238g78300952t2fc7f406c1842273@mail.gmail.com> <20080623060939.6b6b3183.pj@sgi.com> <86802c440806241429s7f5e899dn67d42303247f618@mail.gmail.com> <20080624203252.f932c631.pj@sgi.com> <4861A5DF.5010104@zytor.com> <20080624211711.8c6d5105.pj@sgi.com> <4861AAEF.3020103@zytor.com> <alpine.LFD.1.10.0806241949030.13106@hp.linux-foundation.org> <20080624220810.b2ec0c6a.pj@sgi.com> <alpine.LFD.1.10.0806242101460.20369@hp.linux-foundation.org> <4861D10F.2010308@zytor.com> <alpine.LFD.1.10.0806250740460.4733@hp.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806250740460.4733@hp.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 24 Jun 2008, H. Peter Anvin wrote:
>> Any reason we can't just re-define %p to print the 0x prefix, just as glibc
>> does?  It'd be easy enough to go and sed out all the 0x%p's currently in the
>> kernel.
> 
> You didn't listen. I want #p to do the _symbolic_ address. The thing we 
> have in the backtraces etc. With nice symbol offset information etc.
> 
> The '0x<hex>' thing isn't all that interesting. You can do it by adding 
> the '0x' by hand, or by using a cast and using %#lx instead.
> 

You're right, I didn't.  I still think the 0x%p's and -- even worse -- 
0x%08lx's (what about 64 bits?!) we currently have *all over the kernel* 
suck, but yes, that's a minor problem and getting the symbolic info 
would be a very nice thing.

It looks like gcc will warn about just about ever modifier to %p.  I 
wondered whose diseased brain came up with that idea.

Overall, I think the glibc people have botched their printf extensions 
horribly, failing to pick up the very useful %I extension from Windows 
and instead using %I for something completely conflicting is 
particularly pissy.

	-hpa

