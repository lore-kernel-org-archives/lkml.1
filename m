Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbZERTnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbZERTnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 15:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbZERTmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 15:42:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34493 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbZERTmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 15:42:52 -0400
Message-ID: <4A11B9E7.8010707@zytor.com>
Date: Mon, 18 May 2009 12:41:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: suresh.b.siddha@intel.com
CC: Tejun Heo <tj@kernel.org>, "JBeulich@novell.com" <JBeulich@novell.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel-owner@vger.kernel.org" 
	<linux-kernel-owner@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] x86,percpu: fix pageattr handling with remap allocator
References: <1242305390-21958-1-git-send-email-tj@kernel.org>	 <1242436626.27006.8623.camel@localhost.localdomain>	 <4A0ED8D8.2010303@kernel.org>	 <1242500964.27006.8636.camel@localhost.localdomain>	 <4A0F672A.3000309@kernel.org> <1242674444.27006.8691.camel@localhost.localdomain>
In-Reply-To: <1242674444.27006.8691.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> 
> Can we don't use PERCPU_DYNAMIC_RESERVE in the first chunk and for
> dynamic per_cpu_ptr's we can use some other offset such as
> per_cpu_ptr_offset() or some such thing?
> 
> Then we can separate the static and dynamic chunks. And use large page
> kernel-direct mappings for fast access for critical common things and
> use small page accesses for dynamic and not so common accesses.
> 
> Just checking to see if we can reduce the complexity of setting up the
> percpu areas (different versions for embed, non-embed etc) and handling
> all these aliases with simple code, rather than making it complex.
> 

I'm confused what you're suggesting here.  The whole point of the percpu
unification work is that we can use %gs:absolute type references to hit
a variable right away.  Although in theory we could use both %fs and %gs
for pointers, setting up both would greatly increase the cost of
entering the kernel, especially on 64 bits.

This means all percpu data has to have a constant (virtual) offset from
the beginning of the static percpu area.

	-hpa

