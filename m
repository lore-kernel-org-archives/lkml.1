Return-Path: <linux-kernel-owner+w=401wt.eu-S1756978AbYG3GxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbYG3GxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 02:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbYG3GxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 02:53:16 -0400
Received: from ozlabs.org ([203.10.76.45]:53929 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbYG3GxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 02:53:15 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 2/2] lguest: use get_user_pages_fast() instead of get_user_pages()
Date: Wed, 30 Jul 2008 16:53:09 +1000
User-Agent: KMail/1.9.9
Cc: lguest <lguest@ozlabs.org>, linux-kernel@vger.kernel.org,
       "kvm-devel" <kvm-devel@lists.sourceforge.net>
References: <200807301438.55941.rusty@rustcorp.com.au> <200807301439.47856.rusty@rustcorp.com.au> <200807301530.10205.nickpiggin@yahoo.com.au>
In-Reply-To: <200807301530.10205.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807301653.10154.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 July 2008 15:30:10 Nick Piggin wrote:
> On Wednesday 30 July 2008 14:39, Rusty Russell wrote:
> > 	Before: 5.93 seconds
> > 	After: 5.40 seconds
> >
> > (Counts of slow vs fastpath in this usage are 6092 and 2852462
> > respectively.)
> >
> > And more importantly for lguest, the code is simpler.
>
> Cool. That's actually a fairly significant straight-line performance
> improvement, given that the lguest processes are running one-at-a-time
> right? (and not contending on the locks or bouncing cachelines too much)

Yep.  I mean, the performance is abysmal either way (native for this is about 
10x faster), but it would be interesting to see kvm numbers as they have a 
more sophisticated shadow page table setup.  Not as trivial as lguest since 
they seem to use the mm sem to protect other things...

Cheers,
Rusty.
