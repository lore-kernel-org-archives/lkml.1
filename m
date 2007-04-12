Return-Path: <linux-kernel-owner+w=401wt.eu-S2992553AbXDLPNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992553AbXDLPNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 11:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992555AbXDLPNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 11:13:32 -0400
Received: from kanga.kvack.org ([66.96.29.28]:56427 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992553AbXDLPNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 11:13:31 -0400
Date: Thu, 12 Apr 2007 11:13:25 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Ken Chen <kenchen@google.com>
Cc: Zach Brown <zach.brown@oracle.com>, akpm@linux-foundation.org,
       linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] convert aio event reap to use atomic-op instead of spin_lock
Message-ID: <20070412151325.GQ13621@kvack.org>
References: <20070410235353.325A7346F64@localhost> <20070411180038.GN28322@mami.zabbo.net> <b040c32a0704120050h5b4f03d3ve8813d96c18e082f@mail.gmail.com> <20070412143131.GP13621@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412143131.GP13621@kvack.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 10:31:31AM -0400, Benjamin LaHaise wrote:
> On Thu, Apr 12, 2007 at 12:50:39AM -0700, Ken Chen wrote:
> > I ran through the autotest (with bug fix in the test code).  It passes
> > the regression tests. I made the following change since last rev:
> 
> By removing the spinlock around ring insertion, you've made it possible 
> for two events being inserted on different CPUs to end up creating 
> inconsistent state, as there is nothing which guarantees that resulting 
> event in the ring will be wholely one event or another.

Ignore that, I misread the function it was applied to.  -ENEEDCOFFEE.  Yes, 
that spinlock can go if we're doing cmpxchg().

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <zyntrop@kvack.org>.
