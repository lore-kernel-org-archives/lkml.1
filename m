Return-Path: <linux-kernel-owner+w=401wt.eu-S1760621AbYDKPIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760621AbYDKPIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 11:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759723AbYDKPIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 11:08:31 -0400
Received: from ozlabs.org ([203.10.76.45]:43742 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759639AbYDKPIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 11:08:31 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [patch 16/17] Immediate Values - Documentation
Date: Sat, 12 Apr 2008 01:06:52 +1000
User-Agent: KMail/1.9.9
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Adrian Bunk <bunk@stusta.de>, Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, akpm@osdl.org
References: <20080409150829.855195878@polymtl.ca> <200804101333.36419.rusty@rustcorp.com.au> <20080411011647.GA2785@Krystal>
In-Reply-To: <20080411011647.GA2785@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804120106.52981.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 April 2008 11:16:47 Mathieu Desnoyers wrote:
> * Rusty Russell (rusty@rustcorp.com.au) wrote:
> > On Thursday 10 April 2008 01:08:45 Mathieu Desnoyers wrote:
> > > If you have to read the immediate values from a function declared as
> > > __init or __exit, you should explicitly use _imv_read(), which will
> > > fall back on a global variable read. Failing to do so will leave a
> > > reference to the __init section after it is freed (it would generate a
> > > modpost warning).
> >
> > That's a real usability wart.  Couldn't we skip these in the patching
> > loop if required and revert so noone can make this mistake?
>
> Yeah, I know :(
>
> Well, only if we can find a way to detect the macro is put within a init
> or exit section. Is there some assembly trickery that would permit us to
> do that ?
>
> Otherwise, given the memory freed from the init section could be reused
> later by the kernel, I don't see how we can detect the pointer leads to
> a freed init section and, say, a module.

In theory although not in practice, since everyone vmallocs modules.  Let's 
not rely on that tho.

How about we sweep the immediate table on init discard and remove/mark all the 
init and exit references?

Cheers,
Rusty.
