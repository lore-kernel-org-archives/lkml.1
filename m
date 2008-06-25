Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbYFYEE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbYFYEE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbYFYEEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:04:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750944AbYFYEEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:04:46 -0400
Date: Tue, 24 Jun 2008 21:04:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul Jackson <pj@sgi.com>
cc: hpa@zytor.com, yhlu.kernel@gmail.com, akpm@linux-foundation.org,
       mingo@elte.hu, tglx@linutronix.de, steiner@sgi.com, travis@sgi.com,
       linux-kernel@vger.kernel.org, ying.huang@intel.com, andi@firstfloor.org
Subject: Re: [PATCH 4/5 v2] x86 boot: show pfn addresses in hex not decimal
 in some kernel info printks
In-Reply-To: <20080624220810.b2ec0c6a.pj@sgi.com>
Message-ID: <alpine.LFD.1.10.0806242101460.20369@hp.linux-foundation.org>
References: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com> <20080622142212.5591.64592.sendpatchset@polaris-admin.engr.sgi.com> <86802c440806221238g78300952t2fc7f406c1842273@mail.gmail.com> <20080623060939.6b6b3183.pj@sgi.com>
 <86802c440806241429s7f5e899dn67d42303247f618@mail.gmail.com> <20080624203252.f932c631.pj@sgi.com> <4861A5DF.5010104@zytor.com> <20080624211711.8c6d5105.pj@sgi.com> <4861AAEF.3020103@zytor.com> <alpine.LFD.1.10.0806241949030.13106@hp.linux-foundation.org>
 <20080624220810.b2ec0c6a.pj@sgi.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Jun 2008, Paul Jackson wrote:
> 
> I'd be inclined instead to use "%P" for symbolic addrs.

That doesn't work - gcc warns about it.

That turns out to be a problem with %#p too. 

It's really irritating how we cannot extend on the printk strings without 
either having to throw out gcc warnings altogether. gcc has no extension 
mechanism to the built-in rules ;/

The format warnings are too useful to drop entirely. I guess sparse could 
be taught to do them, and then we could drop the gcc support for them. But 
that would still limit coverage a _lot_.

		Linus
