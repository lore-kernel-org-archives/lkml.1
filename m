Return-Path: <linux-kernel-owner+w=401wt.eu-S1760196AbZEHQdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196AbZEHQdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 12:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbZEHQde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 12:33:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:44262 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbZEHQdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 12:33:33 -0400
Subject: Re: [PATCH 2/2] SLUB: Use GFP_PANIC for early-boot allocations
From: Peter Zijlstra <peterz@infradead.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, rientjes@google.com
In-Reply-To: <20090508161553.GL6132@lenovo>
References: <1241795429.28600.61.camel@penberg-laptop>
	 <alpine.DEB.1.10.0905081127240.26361@qirst.com>
	 <1241797017.28600.63.camel@penberg-laptop>
	 <1241797364.6311.2914.camel@laptop>
	 <1241797558.28600.68.camel@penberg-laptop>
	 <1241797858.6311.2925.camel@laptop>  <20090508161553.GL6132@lenovo>
Content-Type: text/plain
Date: Fri, 08 May 2009 18:31:07 +0200
Message-Id: <1241800267.6311.2969.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-08 at 20:15 +0400, Cyrill Gorcunov wrote:
> [Peter Zijlstra - Fri, May 08, 2009 at 05:50:58PM +0200]
> | On Fri, 2009-05-08 at 18:45 +0300, Pekka Enberg wrote:
> | 
> | > On Fri, 2009-05-08 at 17:42 +0200, Peter Zijlstra wrote:
> | > > BUG_ON((gfp & __GFP_PANIC) && (system_state != STATE_BOOTING));
> | > 
> | > There's no technical reason not to use GFP_PANIC when system_state !=
> | > STATE_BOOTING so I don't think it's needed. It's just that GFP_PANIC
> | > (and BUG_ON) is IMHO too harsh for create_unique_id().
> | 
> | Shouldn't we handle every allocation failure after booting?
> 
> Definitely
> 
> | 
> | I think it _is_ a bug to panic on allocation failures once we're
> | running.
> |
> 
> But Peter I believe there was no suggestion to use GFP_PANIC everywhere
> to get rid of error handling. But rather to use it in case if kmalloc is
> followed by BUG_ON.

Well, what I'm saying is that that either is a genuine bug we should
fix, or its boot code, which is exactly what my assertion above tests
for.

I really believe GFP_PANIC usage outside of system_state ==
STATE_BOOTING is a bug we should fix. Not create a better syntax for.

What code outside of booting is allowed to bring down the kernel on an
allocation failure?

