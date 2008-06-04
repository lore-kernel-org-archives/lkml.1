Return-Path: <linux-kernel-owner+w=401wt.eu-S1760087AbYFDPIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087AbYFDPIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 11:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbYFDPIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 11:08:04 -0400
Received: from relay2.sgi.com ([192.48.171.30]:53116 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750895AbYFDPIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 11:08:01 -0400
Message-ID: <4846AFCF.30500@sgi.com>
Date: Wed, 04 Jun 2008 08:07:59 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Lameter <clameter@sgi.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 00/41] cpu alloc / cpu ops v3: Optimize per cpu access
References: <20080530035620.587204923@sgi.com> <20080529215827.b659d032.akpm@linux-foundation.org>
In-Reply-To: <20080529215827.b659d032.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 29 May 2008 20:56:20 -0700 Christoph Lameter <clameter@sgi.com> wrote:
> 
>> In various places the kernel maintains arrays of pointers indexed by
>> processor numbers. These are used to locate objects that need to be used
>> when executing on a specirfic processor. Both the slab allocator
>> and the page allocator use these arrays and there the arrays are used in
>> performance critical code. The allocpercpu functionality is a simple
>> allocator to provide these arrays.
> 
> All seems reasonable to me.  The obvious question is "how do we size
> the arena".  We either waste memory or, much worse, run out.
> 
> And running out is a real possibility, I think.  Most people will only
> mount a handful of XFS filesystems.  But some customer will come along
> who wants to mount 5,000, and distributors will need to cater for that,
> but how can they?
> 
> I wonder if we can arrange for the default to be overridden via a
> kernel boot option?
> 
> 
> Another obvious question is "how much of a problem will we have with
> internal fragmentation"?  This might be a drop-dead showstopper.

One problem with variable sized cpu_alloc area is this comment in bitmap.h:

 * Note that nbits should be always a compile time evaluable constant.
 * Otherwise many inlines will generate horrible code.

I'm guessing since this will be of low use and not performance critical,
then we can ignore the "horrible code"?  ;-)

Thanks,
Mike

