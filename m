Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbZJBPsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbZJBPsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 11:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753615AbZJBPst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 11:48:49 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:47527 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbZJBPss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 11:48:48 -0400
Subject: Re: linux-next: tree build failure
From: Hollis Blanchard <hollisb@us.ibm.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: sfr@canb.auug.org.au, akpm@linux-foundation.org,
       linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
In-Reply-To: <4AC318450200007800017355@vpn.id2.novell.com>
References: <4AC1E15502000078000516B5@vpn.id2.novell.com>
	 <1254267572.15622.1621.camel@slab.beaverton.ibm.com>
	 <4AC318450200007800017355@vpn.id2.novell.com>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Fri, 02 Oct 2009 08:48:36 -0700
Message-Id: <1254498517.3839.17.camel@slab.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-30 at 07:35 +0100, Jan Beulich wrote:
> >>> Hollis Blanchard <hollisb@us.ibm.com> 30.09.09 01:39 >>>
> >On Tue, 2009-09-29 at 10:28 +0100, Jan Beulich wrote:
> >> >>> Hollis Blanchard  09/29/09 2:00 AM >>>
> >> >First, I think there is a real bug here, and the code should read like
> >> >this (to match the comment):
> >> >    /* type has to be known at build time for optimization */
> >> >-    BUILD_BUG_ON(__builtin_constant_p(type));
> >> >+    BUILD_BUG_ON(!__builtin_constant_p(type));
> >> >
> >> >However, I get the same build error *both* ways, i.e.
> >> >__builtin_constant_p(type) evaluates to both 0 and 1? Either that, or
> >> >the new BUILD_BUG_ON() macro isn't working...
> >> 
> >> No, at this point of the compilation process it's neither zero nor one,
> >> it's simply considered non-constant by the compiler at that stage
> >> (this builtin is used for optimization, not during parsing, and the
> >> error gets generated when the body of the function gets parsed,
> >> not when code gets generated from it).
> >
> >I think I see what you're saying. Do you have a fix to suggest?
> 
> The one Rusty suggested the other day may help here. I don't like it
> as a drop-in replacement for BUILD_BUG_ON() though (due to it
> deferring the error generated to the linking stage), I'd rather view
> this as an improvement to MAYBE_BUILD_BUG_ON() (which should
> then be used here).

Can you be more specific?

I have no idea what Rusty suggested where. I can't even guess what
MAYBE_BUILD_BUG_ON() is supposed to do (sounds like a terrible name).

All I know is that this used to build...

-- 
Hollis Blanchard
IBM Linux Technology Center

